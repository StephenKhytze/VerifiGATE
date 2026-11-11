import os
import cv2
import time
import threading
import asyncio
import numpy as np
import mediapipe as mp
import torch
from mediapipe.tasks import python
from mediapipe.tasks.python import vision
from PIL import Image
from transformers import AutoModelForCausalLM, AutoTokenizer
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
GATE_TOKEN = os.getenv("GATE_TOKEN", "verifigate_super_secret_2026")

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
# 3. VLM SETUP (Replacing CLIP)
# ---
print("Loading VLM Model... (This will take a minute on the first run)")
model_id = "vikhyatk/moondream2"

# Removed the pinned 'revision' so it fetches the newest code compatible with your transformers
tokenizer = AutoTokenizer.from_pretrained(model_id)
vlm_model = AutoModelForCausalLM.from_pretrained(
    model_id, 
    trust_remote_code=True
)
print("VLM Model Loaded Successfully!")

# ---
# 4. SHARED STATE (NO SYNCHRONOUS LOCKS!)
# ---
running = True
cap = None
freeze_frame = None
frame_timestamp_ms = 0
latest_frame_bytes = None
student_crop_frame = None

# ---
# 5. IMAGE STITCHING LOGIC
# ---
def create_comparison_image(reference_path: str, live_crop: np.ndarray) -> Image:
    ref_img = cv2.imread(reference_path)
    if ref_img is None:
        raise FileNotFoundError(f"Could not find reference image at {reference_path}")
        
    target_height = 400
    
    def resize_to_height(img, h):
        aspect_ratio = img.shape[1] / img.shape[0]
        return cv2.resize(img, (int(h * aspect_ratio), h))
        
    ref_resized = resize_to_height(ref_img, target_height)
    live_resized = resize_to_height(live_crop, target_height)
    
    combined_img = cv2.hconcat([ref_resized, live_resized])
    rgb_combined = cv2.cvtColor(combined_img, cv2.COLOR_BGR2RGB)
    return Image.fromarray(rgb_combined)

# ---
# 6. CAMERA THREAD
# ---
def capture_camera():
    global freeze_frame, frame_timestamp_ms, latest_frame_bytes, running, cap, student_crop_frame

    try:
        while running:
            display_frame = None
            
            if freeze_frame is not None:
                display_frame = freeze_frame
            else:
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
                        freeze_frame = frame.copy()

                        all_x_norm_coords = [landmark.x for landmark in landmarks]
                        all_y_norm_coords = [landmark.y for landmark in landmarks]

                        x_min, x_max = int(min(all_x_norm_coords) * width), int(max(all_x_norm_coords) * width)
                        y_min, y_max = int(min(all_y_norm_coords) * height), int(max(all_y_norm_coords) * height)

                        padding_ratio_x = 0.05
                        padding_ratio_y_bottom = 0.05
                        padding_ratio_y_head = 0.15 
                        padding_x, padding_y_bottom, padding_y_top = int(width * padding_ratio_x), int(width * padding_ratio_y_bottom), int(width * padding_ratio_y_head)

                        x_min = max(0, x_min - padding_x)
                        y_min = max(0, y_min - padding_y_top)
                        x_max = min(width, x_max + padding_x)
                        y_max = min(height, y_max + padding_y_bottom)

                        if x_max > x_min and y_max > y_min:
                            student_crop_frame = frame[y_min:y_max, x_min:x_max].copy()
                        else:
                            print("Bounding box invalid, skipping crop.")

                display_frame = frame    

            if display_frame is not None:
                ret, buffer = cv2.imencode(".jpg", display_frame)
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
# 9. STREAM GENERATOR (Disconnection Proof)
# ---
async def generate_frames():
    global running, latest_frame_bytes
    try:
        while running:
            frame_bytes = latest_frame_bytes

            if frame_bytes is not None:
                try:
                    yield(b'--frame\r\n'
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
    global freeze_frame
    freeze_frame = None
    return {"status": "Frame reset"}

@app.get("/id_scanned", dependencies=[Depends(verify_access)])
def scan_demo():
    global freeze_frame, student_crop_frame

    if freeze_frame is None or student_crop_frame is None:
        return {"status": "Error", "detail": "No student fully in frame yet."}
        
    print("ID Scanned. Comparing uniform to database...")
    inference_start = time.time()
    
    try:
        # Mocking the database fetch. 
        # Make sure "reference_uniform.jpg" is actually inside this folder!
        reference_path = os.path.join(script_dir, "pe_unif.png")
        
        # Stitch them together
        comparison_img = create_comparison_image(reference_path, student_crop_frame)
        
        # VLM Inference
        enc_image = vlm_model.encode_image(comparison_img)
        prompt = (
            "This is a side-by-side image. The left side is the official school uniform. "
            "The right side is a student at the gate. "
            "Is the student on the right wearing the exact same uniform as the left? "
            "Look at the shirt color, logos, and collar. "
            "Reply strictly with 'YES' or 'NO', followed by a one sentence explanation."
        )
        
        answer = vlm_model.answer_question(enc_image, prompt, tokenizer)

        inference_end = time.time()
        elapsed_time = inference_end - inference_start
        
        is_approved = answer.upper().strip().startswith("YES")
        
        print("\n--- VLM DECISION ---")
        print(f"Time Taken: {elapsed_time:.2f} seconds")
        print(f"APPROVED: {is_approved}")
        print(f"REASON: {answer}")
        print("--------------------\n")
        
        return {
            "status": "APPROVED" if is_approved else "DENIED",
            "reason": answer,
            "processing_time_seconds": round(elapsed_time, 2)
        }
        
    except Exception as e:
        print(f"Error during VLM inference: {e}")
        return {"status": "ERROR", "detail": str(e)}

if __name__ == "__main__":
    uvicorn.run(app, host="127.0.0.1", port=8002)