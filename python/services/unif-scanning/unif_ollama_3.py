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
# 2. MEDIAPIPE SETUP
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
# 3. VLM SETUP (Ollama, no PyTorch needed)
#    Setup once:  ollama pull qwen2.5vl:3b
#
#    Optional .env settings:
#      VLM_MODEL=qwen2.5vl:3b      (try gemma3:4b or qwen2.5vl:7b if accuracy is short)
#      REFERENCE_IMAGE=path/to/pe_unif.png
#      COMPARE_HEIGHT=504          (smaller = faster, larger = more shirt detail)
#      PANEL_RATIO=0.5             (panel width / height)
#      DEBUG_SAVE_COMPARISON=0     (1 = save the stitched image to see exactly what the model
#                                   sees. It overwrites ONE file each scan. Turn off for real use.)
# ---
OLLAMA_URL = os.getenv("OLLAMA_URL", "http://127.0.0.1:11434/api/generate")
VLM_MODEL = os.getenv("VLM_MODEL", "qwen2.5vl:3b")
REFERENCE_PATH = os.getenv("REFERENCE_IMAGE", os.path.join(script_dir, "pe_unif.png"))
PANEL_H = int(os.getenv("COMPARE_HEIGHT", "504"))
PANEL_RATIO = float(os.getenv("PANEL_RATIO", "0.5"))
PANEL_W = int(PANEL_H * PANEL_RATIO)
GAP = 14
DEBUG_SAVE_COMPARISON = os.getenv("DEBUG_SAVE_COMPARISON", "0") == "1"

# COMPARE_PROMPT = (
#     "The image shows two photos side by side, separated by a white line. "
#     "LEFT: the official school uniform. RIGHT: a student at the gate. "
#     "Ignore faces, hair, skin, blank areas, and backgrounds. Compare only the clothing, "
#     "looking closely at the printed design on the shirt and at the color and style of the pants.\n"
#     "Question 1 (SHIRT): Is the shirt on the right the same color and printed design as the shirt on the left?\n"
#     "Question 2 (PANTS): Are the pants on the right the EXACT same color and style as the pants on the left?\n"
#     "Answer in exactly this format and nothing else:\n"
#     "SHIRT: YES or NO\n"
#     "PANTS: YES or NO"
# )

import json

# ---
# 4. REFERENCE IMAGE LOADING (No gray padding needed for Qwen2.5-VL)
# ---
def prep_vlm_image(img_bgr, max_dim=448):
    """Resize preserving aspect ratio to a multiple-friendly dimension, then JPEG encode."""
    h, w = img_bgr.shape[:2]
    if max(h, w) > max_dim:
        scale = max_dim / max(h, w)
        img_bgr = cv2.resize(img_bgr, (int(w * scale), int(h * scale)), interpolation=cv2.INTER_AREA)
    ok, buf = cv2.imencode(".jpg", img_bgr, [cv2.IMWRITE_JPEG_QUALITY, 85])
    if not ok:
        raise RuntimeError("Could not encode image for the VLM.")
    return base64.b64encode(buf.tobytes()).decode()


reference_b64 = None


def load_reference(path=REFERENCE_PATH):
    global reference_b64
    ref_img = cv2.imread(path)
    if ref_img is None:
        print(f"WARNING: could not read reference uniform image at {path}")
        return
    # Pre-resize and pre-encode ONCE so scans don't repeat this work
    reference_b64 = prep_vlm_image(ref_img, max_dim=448)
    print(f"Reference uniform loaded & cached: {os.path.basename(path)}")


load_reference()


# ---
# 5. VLM CALL (Structured JSON Output + Dynamic Image Comparison)
# ---
UNIFORM_SCHEMA = {
    "type": "object",
    "properties": {
        "obs": {"type": "string"},
        "shirt": {"type": "string", "enum": ["YES", "NO"]},
        "pants": {"type": "string", "enum": ["YES", "NO"]}
    },
    "required": ["obs", "shirt", "pants"]
}

COMPARE_PROMPT = (
    "图1是官方校服标准图，图2是门禁处的学生。"
    "忽略人脸和背景，仔细对比图2学生的衣服是否与图1校服一致（注意上衣颜色、印花图案，以及裤子颜色和款式）。"
    "在obs中用10个字以内简述图2衣裤，然后在shirt和pants中严格判断图2是否与图1匹配。"
)


def ask_vlm(ref_image_b64, live_bgr, question=COMPARE_PROMPT):
    live_b64 = prep_vlm_image(live_bgr, max_dim=448)

    response = requests.post(
        OLLAMA_URL,
        json={
            "model": VLM_MODEL,
            "prompt": question,
            "images": [ref_image_b64, live_b64],
            "format": UNIFORM_SCHEMA,  # Forces valid JSON with exact YES/NO enums
            "stream": False,
            "keep_alive": -1,  # Keep loaded permanently in VRAM/RAM
            "options": {
                "temperature": 0,
                "num_gpu": -1,
                "num_predict": 80,  # Enough room for short Chinese obs + JSON keys
            },
        },
        timeout=180,
    )
    response.raise_for_status()
    return json.loads(response.json()["response"])


def warm_up_vlm():
    """Loads the model into memory so the first real student isn't slow."""
    try:
        print(f"Warming up VLM ({VLM_MODEL})...")
        t0 = time.time()
        blank = np.full((224, 224, 3), 127, dtype=np.uint8)
        blank_b64 = prep_vlm_image(blank, max_dim=224)
        ask_vlm(blank_b64, blank, "输出任意简短描述并选择YES或NO。")
        print(f"VLM ready (warm-up took {time.time() - t0:.1f}s).")
    except Exception as e:
        print(f"VLM warm-up failed: {e}\n"
              f"Is Ollama running, and did you run 'ollama pull {VLM_MODEL}'?")

# ---
# 6. SHARED STATE
# ---
running = True
cap = None
freeze_frame = None
frame_timestamp_ms = 0
latest_frame_bytes = None
student_crop_frame = None
scan_lock = threading.Lock()  # one uniform check at a time


# ---
# 7. CAMERA THREAD
# ---
def capture_camera():
    global freeze_frame, frame_timestamp_ms, latest_frame_bytes, running, cap, student_crop_frame

    frozen_bytes = None  # encoded once while frozen, so we don't re-encode ~100x/sec

    try:
        while running:
            # While frozen, just keep serving the cached image.
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

                    padding_ratio_x = 0.05
                    padding_ratio_y_bottom = 0.05
                    padding_ratio_y_head = 0.15
                    padding_x = int(width * padding_ratio_x)
                    padding_y_bottom = int(height * padding_ratio_y_bottom)
                    padding_y_top = int(height * padding_ratio_y_head)

                    x_min = max(0, x_min - padding_x)
                    y_min = max(0, y_min - padding_y_top)
                    x_max = min(width, x_max + padding_x)
                    y_max = min(height, y_max + padding_y_bottom)

                    if x_max > x_min and y_max > y_min:
                        # Set the crop first, then freeze, so a scan never sees a stale crop.
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
# 8. LIFESPAN MANAGER
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
# 9. FASTAPI SETUP
# ---
app = FastAPI(lifespan=lifespan)
app.add_middleware(
    CORSMiddleware,
    allow_origins=["http://localhost:8000", "http://localhost:5173", "http://127.0.0.1:8000"],
    allow_methods=["*"],
    allow_headers=["*"]
)


# ---
# 10. STREAM GENERATOR
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
# 11. ENDPOINTS
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
    if reference_b64 is None:
        return {"status": "ERROR", "detail": f"Reference uniform image not found at {REFERENCE_PATH}"}

    if not scan_lock.acquire(blocking=False):
        return {"status": "BUSY", "detail": "A uniform check is already in progress."}

    print("ID Scanned. Comparing outfit to reference...")
    try:
        t0 = time.time()
        # Compare pre-cached reference image against the live student crop
        result = ask_vlm(reference_b64, cv2.flip(crop.copy(), 1))
        elapsed = time.time() - t0

        shirt = result["shirt"]  # Guaranteed "YES" or "NO"
        pants = result["pants"]  # Guaranteed "YES" or "NO"
        obs = result.get("obs", "")

        print("\n--- VLM DECISION ---")
        print(f"Model: {VLM_MODEL}")
        print(f"Time Taken: {elapsed:.2f} seconds")
        print(f"OBS: {obs} | SHIRT: {shirt} | PANTS: {pants}")
        print("--------------------\n")

        base = {
            "shirt_match": shirt == "YES",
            "pants_match": pants == "YES",
            "observation": obs,
            "processing_time_seconds": round(elapsed, 2),
        }

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