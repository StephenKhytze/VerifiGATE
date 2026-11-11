import os
import re
import gzip
import shutil
import cv2
import time
import threading
import asyncio
import numpy as np
import mediapipe as mp
from mediapipe.tasks import python
from mediapipe.tasks.python import vision
from PIL import Image
import moondream as md
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
# 3. MOONDREAM SETUP (int8 weights, CPU, no PyTorch/transformers)
#
#    Setup once:
#      pip install moondream==0.0.5
#      Download moondream-2b-int8.mf (or the .mf.gz) from the model table in
#      https://github.com/vikhyat/moondream and put it next to this script.
#      The 0.5B int8 file is faster but less accurate: point MOONDREAM_MODEL at it.
#
#    Optional .env settings:
#      MOONDREAM_MODEL=path/to/model.mf
#      REFERENCE_IMAGE=path/to/pe_unif.png
#      COMPARE_HEIGHT=512        (raise to 640-768 for more shirt detail, but slower)
#      ASK_FOR_REASON=0          (1 = ask for a one-sentence reason, a bit slower)
#      DEBUG_SAVE_COMPARISON=0   (1 = save the stitched image to see what the model sees;
#                                 it overwrites ONE file each scan. Turn off for real use.)
# ---
MODEL_PATH = os.getenv("MOONDREAM_MODEL", os.path.join(script_dir, "moondream-2b-int8.mf"))
REFERENCE_PATH = os.getenv("REFERENCE_IMAGE", os.path.join(script_dir, "pe_unif.png"))
PANEL_H = int(os.getenv("COMPARE_HEIGHT", "512"))
PANEL_W = int(PANEL_H * 0.6)  # each panel is a tall, narrow box, fits a standing person
GAP = 16
ASK_FOR_REASON = os.getenv("ASK_FOR_REASON", "0") == "1"
DEBUG_SAVE_COMPARISON = os.getenv("DEBUG_SAVE_COMPARISON", "0") == "1"

PROMPT = (
    "This image has two panels separated by a white line. "
    "The LEFT panel is the official school uniform. "
    "The RIGHT panel is a student at the gate. "
    "Compare their clothing only: the shirt color, any print, logo or lettering on the shirt, "
    "and the pants. "
    "Is the student on the right wearing the same uniform as the one on the left? "
)
PROMPT += (
    "Reply YES or NO, then one short sentence explaining why."
    if ASK_FOR_REASON
    else "Reply with exactly one word: YES or NO."
)


def ensure_model_file(path):
    """Returns a usable .mf path. Decompresses a .mf.gz next to it once if needed."""
    if os.path.isfile(path):
        return path
    gz_path = path + ".gz"
    if os.path.isfile(gz_path):
        print(f"Decompressing {os.path.basename(gz_path)} (one time only)...")
        with gzip.open(gz_path, "rb") as src, open(path, "wb") as dst:
            shutil.copyfileobj(src, dst)
        return path
    raise FileNotFoundError(
        f"Moondream weights not found at:\n  {path}\n"
        "Download moondream-2b-int8.mf (or .mf.gz) from the model table at "
        "https://github.com/vikhyat/moondream and put it next to this script, "
        "or set MOONDREAM_MODEL in your .env."
    )


print("Loading Moondream (int8, CPU)...")
vlm_model = md.vl(model=ensure_model_file(MODEL_PATH))
vlm_lock = threading.Lock()  # one inference at a time, avoids CPU thrashing
print("Moondream loaded.")


# ---
# 4. IMAGE STITCHING LOGIC
# ---
def fit_panel(img_bgr, w, h, fill=127):
    """Letterbox an image into a fixed w x h panel without distorting it."""
    ih, iw = img_bgr.shape[:2]
    scale = min(w / iw, h / ih)
    nw, nh = max(1, int(iw * scale)), max(1, int(ih * scale))
    interp = cv2.INTER_AREA if scale < 1 else cv2.INTER_CUBIC
    resized = cv2.resize(img_bgr, (nw, nh), interpolation=interp)
    panel = np.full((h, w, 3), fill, dtype=np.uint8)
    y0, x0 = (h - nh) // 2, (w - nw) // 2
    panel[y0:y0 + nh, x0:x0 + nw] = resized
    return panel


reference_panel = None


def load_reference():
    global reference_panel
    ref_img = cv2.imread(REFERENCE_PATH)
    if ref_img is None:
        print(f"WARNING: could not read reference uniform image at {REFERENCE_PATH}")
        return
    reference_panel = fit_panel(ref_img, PANEL_W, PANEL_H)  # prepared once, reused every scan
    print(f"Reference uniform loaded: {os.path.basename(REFERENCE_PATH)}")


load_reference()


def make_comparison_image(live_crop_bgr):
    live_panel = fit_panel(live_crop_bgr, PANEL_W, PANEL_H)
    divider = np.full((PANEL_H, GAP, 3), 255, dtype=np.uint8)
    combined = cv2.hconcat([reference_panel, divider, live_panel])
    if DEBUG_SAVE_COMPARISON:
        cv2.imwrite(os.path.join(script_dir, "debug_comparison.jpg"), combined)
    return Image.fromarray(cv2.cvtColor(combined, cv2.COLOR_BGR2RGB))


def warm_up_vlm():
    """Runs one dummy inference so the first real student isn't slow."""
    with vlm_lock:
        try:
            print("Warming up Moondream...")
            t0 = time.time()
            dummy = Image.fromarray(np.full((PANEL_H, PANEL_W * 2 + GAP, 3), 127, dtype=np.uint8))
            enc = vlm_model.encode_image(dummy)
            vlm_model.query(enc, "Reply with one word: OK")
            print(f"Moondream ready (warm-up took {time.time() - t0:.1f}s).")
        except Exception as e:
            print(f"Warm-up failed: {e}")


# ---
# 5. SHARED STATE
# ---
running = True
cap = None
freeze_frame = None
frame_timestamp_ms = 0
latest_frame_bytes = None
student_crop_frame = None


# ---
# 6. CAMERA THREAD
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
    if reference_panel is None:
        return {"status": "ERROR", "detail": f"Reference uniform image not found at {REFERENCE_PATH}"}

    # If a check is already running, don't queue another one on top of it.
    if not vlm_lock.acquire(blocking=False):
        return {"status": "BUSY", "detail": "A uniform check is already in progress."}

    print("ID Scanned. Comparing uniform to reference...")
    try:
        t0 = time.time()
        comparison_img = make_comparison_image(crop.copy())
        enc_image = vlm_model.encode_image(comparison_img)
        t1 = time.time()
        answer = vlm_model.query(enc_image, PROMPT)["answer"].strip()
        t2 = time.time()

        match = re.match(r"\W*(YES|NO)\b", answer.upper())
        verdict = match.group(1) if match else None
        is_approved = verdict == "YES"

        print("\n--- VLM DECISION ---")
        print(f"Encode: {t1 - t0:.1f}s | Answer: {t2 - t1:.1f}s | Total: {t2 - t0:.1f}s")
        print(f"RAW ANSWER: {answer!r}")
        print(f"APPROVED: {is_approved}")
        print("--------------------\n")

        timing = {
            "encode_seconds": round(t1 - t0, 2),
            "answer_seconds": round(t2 - t1, 2),
            "processing_time_seconds": round(t2 - t0, 2),
        }

        if verdict is None:
            return {"status": "UNSURE", "reason": f"Unexpected VLM answer: {answer!r}", **timing}

        return {"status": "APPROVED" if is_approved else "DENIED", "reason": answer, **timing}

    except Exception as e:
        print(f"Error during VLM inference: {e}")
        return {"status": "ERROR", "detail": str(e)}
    finally:
        vlm_lock.release()


if __name__ == "__main__":
    uvicorn.run(app, host="127.0.0.1", port=8002)
