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


# def make_comparison_image(live_crop_bgr):
#     live_panel = fit_panel(live_crop_bgr, PANEL_W, PANEL_H)
#     divider = np.full((PANEL_H, GAP, 3), 255, dtype=np.uint8)
#     combined = cv2.hconcat([reference_panel, divider, live_panel])
#     if DEBUG_SAVE_COMPARISON:
#         cv2.imwrite(os.path.join(script_dir, "debug_comparison.jpg"), combined)
#     return combined


# ---
# 5. VLM CALL
# ---
# def ask_vlm(img_bgr, question):
#     ok, buf = cv2.imencode(".jpg", img_bgr, [cv2.IMWRITE_JPEG_QUALITY, 92])
#     if not ok:
#         raise RuntimeError("Could not encode image for the VLM.")

#     response = requests.post(
#         OLLAMA_URL,
#         json={
#             "model": VLM_MODEL,
#             "prompt": question,
#             "images": [base64.b64encode(buf.tobytes()).decode()],
#             "stream": False,
#             "keep_alive": "30m",  # keep the model loaded between students
#             "options": {"temperature": 0, "num_predict": 24},
#         },
#         timeout=180,
#     )
#     response.raise_for_status()
#     return response.json()["response"].strip()

# Pass the two images separately, don't stitch them
# def ask_vlm(reference_bgr, live_bgr, question):
#     ok1, buf1 = cv2.imencode(".jpg", reference_bgr, [cv2.IMWRITE_JPEG_QUALITY, 92])
#     ok2, buf2 = cv2.imencode(".jpg", live_bgr, [cv2.IMWRITE_JPEG_QUALITY, 92])
    
#     if not (ok1 and ok2):
#         raise RuntimeError("Could not encode images for the VLM.")

#     response = requests.post(
#         OLLAMA_URL,
#         json={
#             "model": VLM_MODEL,
#             "prompt": question,
#             # Send them as a list of two distinct images
#             "images": [
#                 base64.b64encode(buf1.tobytes()).decode(),
#                 base64.b64encode(buf2.tobytes()).decode()
#             ],
#             "stream": False,
#             "keep_alive": "30m",
#             "options": {"temperature": 0}, # Removed num_predict constraint to allow reasoning
#         },
#         timeout=180,
#     )
#     response.raise_for_status()
#     return response.json()["response"].strip()

def ask_vlm(reference_bgr, live_bgr, question):
    # --- OPTIMIZATION: Shrink images to a max dimension before sending ---
    max_dim = 504 # Multiples of 28 are highly optimized for Qwen2.5-VL
    
    def resize_for_vlm(img):
        h, w = img.shape[:2]
        if max(h, w) > max_dim:
            scale = max_dim / max(h, w)
            return cv2.resize(img, (int(w * scale), int(h * scale)), interpolation=cv2.INTER_AREA)
        return img

    ref_shrunk = resize_for_vlm(reference_bgr)
    live_shrunk = resize_for_vlm(live_bgr)
    # ---------------------------------------------------------------------

    ok1, buf1 = cv2.imencode(".jpg", ref_shrunk, [cv2.IMWRITE_JPEG_QUALITY, 92])
    ok2, buf2 = cv2.imencode(".jpg", live_shrunk, [cv2.IMWRITE_JPEG_QUALITY, 92])
    
    if not (ok1 and ok2):
        raise RuntimeError("Could not encode images for the VLM.")

    response = requests.post(
        OLLAMA_URL,
        json={
            "model": VLM_MODEL,
            "prompt": question,
            "images": [
                base64.b64encode(buf1.tobytes()).decode(),
                base64.b64encode(buf2.tobytes()).decode()
            ],
            "stream": False,
            "keep_alive": "30m",
            "options": {
                "temperature": 0,
                # Explicitly tell Ollama to offload all layers to the GPU
                "num_gpu": -1,
                "num_ctx": 4096
            },
        },
        timeout=180,
    )
    response.raise_for_status()
    return response.json()["response"].strip()

# Update your prompt to allow reasoning
# COMPARE_PROMPT = (
#     "I have provided two images. Image 1 is the official school uniform. Image 2 is a student at the gate. "
#     "Compare the clothing in both images. Look closely at the printed design on the shirt and the color of the pants. "
#     "First, briefly describe the shirt and pants in Image 2. "
#     "Then, on a new line, state exactly 'SHIRT: YES' or 'SHIRT: NO' indicating if they match Image 1. "
#     "Finally, on a new line, state exactly 'PANTS: YES' or 'PANTS: NO'."
# )
# COMPARE_PROMPT = (
#     "我提供了两张图片。图1是官方校服。图2是一名在门口的学生。"
#     "对比两张图片中的服装。仔细观察上衣的印花图案和裤子的颜色。"
#     "首先，简要描述图2中的上衣和裤子。"
#     "然后，另起一行，严格输出 'SHIRT: YES' 或 'SHIRT: NO'，以表明上衣是否与图1一致。"
#     "最后，再另起一行，严格输出 'PANTS: YES' 或 'PANTS: NO'。"
# )
# COMPARE_PROMPT = (
#     "图1是标准校服，图2是学生。对比两张图片中的上衣印花和裤子颜色。"
#     "不要输出任何解释或描述。严格按照以下格式输出两行："
#     "SHIRT: YES 或 NO"
#     "PANTS: YES 或 NO"
# )
# COMPARE_PROMPT = (
#     "对比图1（标准校服）和图2（学生）的上衣印花与裤子颜色。"
#     "严格按以下三行格式输出，不要添加多余内容："
#     "SHIRT: [YES 或 NO]"
#     "PANTS: [YES 或 NO]"
#     "DESC: [用一句话简要描述图2的上衣和裤子]"
# )
COMPARE_PROMPT = (
    "对比图1（标准校服）和图2（学生）的上衣印花与裤子颜色。"
    "严格按以下三行格式输出，不要添加多余内容："
    "SHIRT: [YES 或 NO]"
    "PANTS: [YES 或 NO]"
    "DESC: [用一句话简要描述图2的上衣和裤子]"
)



def parse_checklist(text):
    t = text.upper()
    shirt = re.search(r"SHIRT\W*(YES|NO)\b", t)
    pants = re.search(r"PANTS\W*(YES|NO)\b", t)
    return (shirt.group(1) if shirt else None, pants.group(1) if pants else None)


def warm_up_vlm():
    """Loads the model into memory so the first real student isn't slow."""
    try:
        print(f"Warming up VLM ({VLM_MODEL})...")
        t0 = time.time()
        blank = np.full((PANEL_H, PANEL_W * 2 + GAP, 3), 127, dtype=np.uint8)
        ask_vlm(blank, blank, "Answer with one word: OK")
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
    if reference_panel is None:
        return {"status": "ERROR", "detail": f"Reference uniform image not found at {REFERENCE_PATH}"}

    # If a check is already running, don't stack another one on top of it.
    if not scan_lock.acquire(blocking=False):
        return {"status": "BUSY", "detail": "A uniform check is already in progress."}

    print("ID Scanned. Comparing outfit to reference...")
    try:
        t0 = time.time()
        
        # You can keep this line ONLY if you still want it to save the debug image to your folder
        # if DEBUG_SAVE_COMPARISON:
        #     make_comparison_image(cv2.flip(crop.copy(), 1))
            
        # --- NEW VLM CALL ---
        # Pass the pre-loaded reference_panel and the flipped crop as two separate images
        answer = ask_vlm(reference_panel, cv2.flip(crop.copy(), 1), COMPARE_PROMPT)
        
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