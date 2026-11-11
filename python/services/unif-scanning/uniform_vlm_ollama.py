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
#    Try others:  set VLM_MODEL=gemma3:4b in your .env
# ---
OLLAMA_URL = os.getenv("OLLAMA_URL", "http://127.0.0.1:11434/api/generate")
VLM_MODEL = os.getenv("VLM_MODEL", "qwen2.5vl:3b")
VLM_IMAGE_SIDE = int(os.getenv("VLM_IMAGE_SIDE", "448"))  # smaller = faster

# Edit this so it matches what your PE pants actually look like.
PANTS_QUESTION = (
    "Look only at the person's pants. Are they (A) blue athletic track pants "
    "with a white stripe down the side, or (B) denim jeans or any other kind "
    "of pants? Answer with a single letter."
)


def pad_to_square(img_bgr, fill=127):
    h, w = img_bgr.shape[:2]
    s = max(h, w)
    out = np.full((s, s, 3), fill, dtype=np.uint8)
    y0, x0 = (s - h) // 2, (s - w) // 2
    out[y0:y0 + h, x0:x0 + w] = img_bgr
    return out


def ask_vlm(img_bgr, question, side=VLM_IMAGE_SIDE):
    img = cv2.resize(pad_to_square(img_bgr), (side, side))
    ok, buf = cv2.imencode(".jpg", img, [cv2.IMWRITE_JPEG_QUALITY, 90])
    if not ok:
        raise RuntimeError("Could not encode image for the VLM.")

    response = requests.post(
        OLLAMA_URL,
        json={
            "model": VLM_MODEL,
            "prompt": question,
            "images": [base64.b64encode(buf.tobytes()).decode()],
            "stream": False,
            "keep_alive": "30m",  # keep the model loaded between students
            "options": {"temperature": 0, "num_predict": 6},
        },
        timeout=180,
    )
    response.raise_for_status()
    return response.json()["response"].strip()


def warm_up_vlm():
    """Loads the model into memory so the first real student isn't slow."""
    try:
        print(f"Warming up VLM ({VLM_MODEL})...")
        t0 = time.time()
        blank = np.full((VLM_IMAGE_SIDE, VLM_IMAGE_SIDE, 3), 127, dtype=np.uint8)
        ask_vlm(blank, "Answer with a single letter: A")
        print(f"VLM ready (warm-up took {time.time() - t0:.1f}s).")
    except Exception as e:
        print(f"VLM warm-up failed: {e}\n"
              f"Is Ollama running, and did you run 'ollama pull {VLM_MODEL}'?")


# ---
# 4. SHARED STATE
# ---
running = True
cap = None
freeze_frame = None
frame_timestamp_ms = 0
latest_frame_bytes = None
student_crop_frame = None


# ---
# 5. CAMERA THREAD
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
# 6. LIFESPAN MANAGER
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
# 7. FASTAPI SETUP
# ---
app = FastAPI(lifespan=lifespan)
app.add_middleware(
    CORSMiddleware,
    allow_origins=["http://localhost:8000", "http://localhost:5173", "http://127.0.0.1:8000"],
    allow_methods=["*"],
    allow_headers=["*"]
)


# ---
# 8. STREAM GENERATOR
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
# 9. ENDPOINTS
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

    print("ID Scanned. Checking attire...")
    inference_start = time.time()

    try:
        answer = ask_vlm(crop.copy(), PANTS_QUESTION)
        elapsed_time = time.time() - inference_start

        match = re.match(r"\W*([AB])\b", answer.upper())
        letter = match.group(1) if match else None
        is_approved = letter == "A"

        print("\n--- VLM DECISION ---")
        print(f"Model: {VLM_MODEL}")
        print(f"Time Taken: {elapsed_time:.2f} seconds")
        print(f"RAW ANSWER: {answer!r}")
        print(f"APPROVED: {is_approved}")
        print("--------------------\n")

        if letter is None:
            return {
                "status": "UNSURE",
                "reason": f"Unexpected VLM answer: {answer!r}",
                "processing_time_seconds": round(elapsed_time, 2),
            }

        return {
            "status": "APPROVED" if is_approved else "DENIED",
            "reason": answer,
            "processing_time_seconds": round(elapsed_time, 2),
        }

    except requests.exceptions.ConnectionError:
        return {"status": "ERROR",
                "detail": "Could not reach Ollama. Is it running? (start the Ollama app or run 'ollama serve')"}
    except Exception as e:
        print(f"Error during VLM inference: {e}")
        return {"status": "ERROR", "detail": str(e)}


if __name__ == "__main__":
    uvicorn.run(app, host="127.0.0.1", port=8002)
