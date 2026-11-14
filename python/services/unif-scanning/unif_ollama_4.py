import os
import re
import cv2
import time
import base64
import threading
import asyncio
import numpy as np
import requests
import mediapipe as mp
from mediapipe.tasks import python
from mediapipe.tasks.python import vision
import uvicorn
from fastapi import FastAPI, Depends, HTTPException, Query
from fastapi.responses import StreamingResponse
from fastapi.middleware.cors import CORSMiddleware
from contextlib import asynccontextmanager
from dotenv import load_dotenv

# ---
# 1. SECURITY SETUP
# ---
load_dotenv()
GATE_TOKEN = os.getenv("GATE_TOKEN")
if not GATE_TOKEN:
    print("WARNING: GATE_TOKEN not set in .env, using the built-in default. "
          "Set a real token before any demo or deployment.")
    GATE_TOKEN = "verifigate_super_secret_2026"


def verify_access(token: str = Query(None)):
    if token != GATE_TOKEN:
        raise HTTPException(status_code=401, detail="Unauthorized Access: Invalid Token")


# ---
# 2. SHARED STATE (Declared early so threads never see undefined variables)
# ---
running = True
cap = None
freeze_frame = None
frame_timestamp_ms = 0
latest_frame_bytes = None
student_crop_frame = None
scan_lock = threading.Lock()


# ---
# 3. MEDIAPIPE SETUP
# ---
script_dir = os.path.dirname(os.path.abspath(__file__))
task_path = os.path.join(script_dir, "pose_landmarker_full.task")

base_options = python.BaseOptions(model_asset_path=task_path)
options = vision.PoseLandmarkerOptions(
    base_options=base_options,
    running_mode=vision.RunningMode.VIDEO,
    num_poses=1,
    min_pose_detection_confidence=0.5,
    min_pose_presence_confidence=0.7,
    min_tracking_confidence=0.5
)
pose_landmarker = vision.PoseLandmarker.create_from_options(options)


# ---
# 4. VLM SETUP & SIDE-BY-SIDE LOGIC
# ---
OLLAMA_URL = os.getenv("OLLAMA_URL", "http://127.0.0.1:11434/api/generate")
VLM_MODEL = os.getenv("VLM_MODEL", "qwen2.5vl:3b")
REFERENCE_PATH = os.getenv("REFERENCE_IMAGE", os.path.join(script_dir, "pe_unif.png"))
TARGET_H = 336  # Height for side-by-side comparison

ref_shrunk_bgr = None


def load_reference():
    """Resizes the reference uniform once at startup."""
    global ref_shrunk_bgr
    ref_img = cv2.imread(REFERENCE_PATH)
    if ref_img is None:
        print(f"WARNING: could not read reference uniform image at {REFERENCE_PATH}")
        return
    h, w = ref_img.shape[:2]
    new_w = max(1, int(w * (TARGET_H / h)))
    ref_shrunk_bgr = cv2.resize(ref_img, (new_w, TARGET_H), interpolation=cv2.INTER_AREA)
    print(f"Reference uniform cached ({new_w}x{TARGET_H}).")


load_reference()


def create_comparison_image(live_bgr):
    """Horizontal stitch (<1ms): [Ref | Line | Student]. Single image avoids OOM."""
    h, w = live_bgr.shape[:2]
    new_w = max(1, int(w * (TARGET_H / h)))
    live_resized = cv2.resize(live_bgr, (new_w, TARGET_H), interpolation=cv2.INTER_AREA)
    divider = np.full((TARGET_H, 6, 3), 255, dtype=np.uint8)
    return cv2.hconcat([ref_shrunk_bgr, divider, live_resized])


COMPARE_PROMPT = (
    "这是一张左右拼接的对比图，中间有白线隔开。左边是标准校服，右边是学生。\n"
    "请仔细对比右边学生的服装是否符合左边的标准校服，按顺序严格输出三行：\n"
    "DESC: [用15字以内简述右边学生的服装特征]\n"
    "SHIRT: [YES 或 NO]\n"
    "PANTS: [YES 或 NO]"
)


# ---
# 5. PARSER & VLM INFERENCE
# ---
def parse_checklist(text):
    t = text.upper()
    shirt = re.search(r"SHIRT\W*(YES|NO)\b", t)
    pants = re.search(r"PANTS\W*(YES|NO)\b", t)
    return (shirt.group(1) if shirt else None, pants.group(1) if pants else None)


def ask_vlm(live_bgr, question, timeout=60):
    if ref_shrunk_bgr is None:
        raise RuntimeError("Reference image is not loaded.")

    stitched_img = create_comparison_image(live_bgr)
    ok, buf = cv2.imencode(".jpg", stitched_img, [cv2.IMWRITE_JPEG_QUALITY, 85])
    if not ok:
        raise RuntimeError("Could not encode stitched image.")
    stitched_b64 = base64.b64encode(buf.tobytes()).decode()

    response = requests.post(
        OLLAMA_URL,
        json={
            "model": VLM_MODEL,
            "prompt": question,
            "images": [stitched_b64],
            "stream": False,
            "keep_alive": "24h",
            "options": {
                "temperature": 0,
                "num_ctx": 2048,
                "num_predict": 45,
            },
        },
        timeout=timeout,
    )

    if response.status_code != 200:
        try:
            err_details = response.json().get("error", response.text)
        except Exception:
            err_details = response.text
        raise RuntimeError(f"Ollama {response.status_code} Error: {err_details}")

    return response.json()["response"].strip()


def warm_up_vlm():
    """Warms up the model in VRAM."""
    try:
        print(f"Warming up VLM ({VLM_MODEL})...")
        t0 = time.time()
        blank_student = np.full((TARGET_H, TARGET_H // 2, 3), 127, dtype=np.uint8)
        ask_vlm(blank_student, "Answer with one word: OK", timeout=120)
        print(f"VLM ready (warm-up took {time.time() - t0:.1f}s).")
    except Exception as e:
        print(f"VLM warm-up failed: {e}\n"
              f"Is Ollama running, and did you run 'ollama pull {VLM_MODEL}'?")


# ---
# 6. CAMERA THREAD
# ---
def capture_camera():
    global freeze_frame, frame_timestamp_ms, latest_frame_bytes, running, cap, student_crop_frame

    frozen_bytes = None

    try:
        while running:
            if freeze_frame is not None:
                if frozen_bytes is None:
                    ret, buffer = cv2.imencode(".jpg", freeze_frame)
                    if ret:
                        frozen_bytes = buffer.tobytes()
                if frozen_bytes is not None:
                    latest_frame_bytes = frozen_bytes
                time.sleep(0.05)
                continue
            frozen_bytes = None

            success, frame = cap.read()
            if not success:
                time.sleep(0.01)
                continue

            frame = cv2.flip(frame, 1)
            rgb = cv2.cvtColor(frame, cv2.COLOR_BGR2RGB)
            mp_image = mp.Image(image_format=mp.ImageFormat.SRGB, data=rgb)
            frame_timestamp_ms += 33

            result = pose_landmarker.detect_for_video(mp_image, frame_timestamp_ms)
            height, width = frame.shape[:2]

            if result.pose_landmarks:
                landmarks = result.pose_landmarks[0]
                nose_norm_coords = landmarks[0]
                l_foot_norm_coords, r_foot_norm_coords = landmarks[31], landmarks[32]

                highest_foot_landmark = max(l_foot_norm_coords.y, r_foot_norm_coords.y)
                body_ratio = highest_foot_landmark - nose_norm_coords.y

                low_threshold = 0.70
                high_threshold = 0.80

                if low_threshold < body_ratio < high_threshold:
                    all_x_norm_coords = [lm.x for lm in landmarks]
                    all_y_norm_coords = [lm.y for lm in landmarks]

                    x_min, x_max = int(min(all_x_norm_coords) * width), int(max(all_x_norm_coords) * width)
                    y_min, y_max = int(min(all_y_norm_coords) * height), int(max(all_y_norm_coords) * height)

                    padding_x = int(width * 0.05)
                    padding_y_bottom = int(height * 0.05)
                    padding_y_top = int(height * 0.15)

                    x_min = max(0, x_min - padding_x)
                    y_min = max(0, y_min - padding_y_top)
                    x_max = min(width, x_max + padding_x)
                    y_max = min(height, y_max + padding_y_bottom)

                    if x_max > x_min and y_max > y_min:
                        student_crop_frame = frame[y_min:y_max, x_min:x_max].copy()
                        freeze_frame = frame.copy()
                    else:
                        print("Bounding box invalid, skipping crop.")

            ret, buffer = cv2.imencode(".jpg", frame)
            if ret:
                latest_frame_bytes = buffer.tobytes()

            time.sleep(0.01)

    except Exception as e:
        print(f"\nCritical error in camera thread: {e}\n")
        running = False


# ---
# 7. LIFESPAN MANAGER
# ---
@asynccontextmanager
async def lifespan(app: FastAPI):
    global cap, running
    cap = cv2.VideoCapture(0)
    cam_thread = threading.Thread(target=capture_camera, daemon=True)
    cam_thread.start()
    threading.Thread(target=warm_up_vlm, daemon=True).start()
    yield
    running = False
    cam_thread.join(timeout=2.0)
    if cap is not None and cap.isOpened():
        cap.release()


# ---
# 8. FASTAPI SETUP
# ---
app = FastAPI(lifespan=lifespan)
app.add_middleware(
    CORSMiddleware,
    allow_origins=["http://localhost:8000", "http://localhost:5173", "http://127.0.0.1:8000"],
    allow_methods=["*"],
    allow_headers=["*"]
)


# ---
# 9. STREAM GENERATOR
# ---
async def generate_frames():
    global running, latest_frame_bytes
    try:
        while running:
            frame_bytes = latest_frame_bytes
            if frame_bytes is not None:
                try:
                    yield (b'--frame\r\n'
                           b'Content-Type: image/jpeg\r\n\r\n' + frame_bytes + b'\r\n')
                except (RuntimeError, ConnectionError, BrokenPipeError):
                    break
            await asyncio.sleep(0.03)
    except asyncio.CancelledError:
        pass


# ---
# 10. ENDPOINTS
# ---
@app.get("/video_feed", dependencies=[Depends(verify_access)])
async def video_feed():
    return StreamingResponse(generate_frames(), media_type="multipart/x-mixed-replace; boundary=frame")


@app.get("/reset_frame", dependencies=[Depends(verify_access)])
def reset_frame():
    global freeze_frame, student_crop_frame
    freeze_frame = None
    student_crop_frame = None
    return {"status": "Frame reset"}


@app.get("/id_scanned", dependencies=[Depends(verify_access)])
def scan_demo():
    crop = student_crop_frame
    if freeze_frame is None or crop is None:
        return {"status": "Error", "detail": "No student fully in frame yet."}
    if ref_shrunk_bgr is None:
        return {"status": "ERROR", "detail": f"Reference uniform image not found at {REFERENCE_PATH}"}

    if not scan_lock.acquire(blocking=False):
        return {"status": "BUSY", "detail": "A uniform check is already in progress."}

    print("ID Scanned. Comparing outfit to reference...")
    try:
        t0 = time.time()
        
        answer = ask_vlm(cv2.flip(crop.copy(), 1), COMPARE_PROMPT)
        
        elapsed = time.time() - t0

        shirt, pants = parse_checklist(answer)
        print("\n--- VLM DECISION ---")
        print(f"Model: {VLM_MODEL}")
        print(f"Time Taken: {elapsed:.2f} seconds")
        print(f"RAW ANSWER: {answer!r}")
        print(f"SHIRT: {shirt} | PANTS: {pants}")
        print("--------------------\n")

        base = {
            "shirt_match": None if shirt is None else shirt == "YES",
            "pants_match": None if pants is None else pants == "YES",
            "raw_answer": answer,
            "processing_time_seconds": round(elapsed, 2),
        }

        if shirt is None or pants is None:
            return {"status": "UNSURE", "reason": "The model's answer could not be read.", **base}

        if shirt == "YES" and pants == "YES":
            return {"status": "APPROVED", "reason": "Shirt and pants match the reference.", **base}

        problems = []
        if shirt == "NO":
            problems.append("shirt does not match")
        if pants == "NO":
            problems.append("pants do not match")
        return {"status": "DENIED", "reason": "; ".join(problems).capitalize() + ".", **base}

    except requests.exceptions.ConnectionError:
        return {"status": "ERROR",
                "detail": "Could not reach Ollama. Is it running? (start the Ollama app or run 'ollama serve')"}
    except Exception as e:
        print(f"Error during VLM inference: {e}")
        return {"status": "ERROR", "detail": str(e)}
    finally:
        scan_lock.release()


if __name__ == "__main__":
    uvicorn.run(app, host="127.0.0.1", port=8002)