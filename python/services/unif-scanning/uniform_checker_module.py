# import time
import os
from dotenv import load_dotenv

import cv2
import time
import threading
import asyncio
import mediapipe as mp

from mediapipe.tasks import python
from mediapipe.tasks.python import vision
from PIL import Image
from transformers import CLIPProcessor, CLIPModel

from db_utils import get_student_attire_condition

import uvicorn
from fastapi import FastAPI, Depends, HTTPException, Query
from fastapi.responses import StreamingResponse
from fastapi.middleware.cors import CORSMiddleware
from contextlib import asynccontextmanager

# ---
# secure access via token
# ---

# load token from .env file
load_dotenv()
GATE_TOKEN = os.getenv("GATE_TOKEN", "default_fallback_token")

def verify_access(token: str = Query(None)):
  # if token is wrong or does not exist
  if token != GATE_TOKEN:
    # raise exception code 401
    raise HTTPException(status_code=401, detail="Unauthorized Access: Missing or Invalid Token")

# ---
# create pose detector
# ---
script_dir = os.path.dirname(os.path.abspath(__file__))
task_path = os.path.join(script_dir, "pose_landmarker_full.task")
# base_options = python.BaseOptions(model_asset_path="pose_landmarker_full.task")
base_options = python.BaseOptions(model_asset_path=task_path)

# confidence threshold is 0.5
options = vision.PoseLandmarkerOptions(
  base_options=base_options, 
  running_mode = vision.RunningMode.VIDEO,
  num_poses = 1,
  min_pose_detection_confidence=0.5,
  min_pose_presence_confidence=0.7,
  min_tracking_confidence=0.5
  )
pose_landmarker = vision.PoseLandmarker.create_from_options(options)

# ---
# initialize CLIP
# ---
model_id = "openai/clip-vit-base-patch32"
processor = CLIPProcessor.from_pretrained(model_id)
model = CLIPModel.from_pretrained(model_id)

# mock prompts (for testing)
# attire_prompts = [
#   # inappropriate attire (visitor/civilian)
#   "A photo of a person wearing ripped jeans",
#   "A photo of a person wearing a sleeveless tank top",
#   "A photo of a person wearing a midriff-baring crop top",
#   "A photo of a person wearing a skirt higher than the knees",

#   # appropriate attire
#   "A photo of a person wearing a standard t-shirt and neat jeans",
#   "A photo of a person wearing a modest polo shirt and trousers",
#   "A photo of a person wearing appropriate, modest casual clothing"
# ]

piercing_prompts = [
  "A close-up photo of a man's head wearing a metal earring",
  "A close-up photo of a man's head with facial piercings",
  
  # COMPLIANT ANCHORS (Indices 2, 3)
  "A close-up photo of a man's head with clean, bare ears and no jewelry",
  "A close-up photo of a man's head with no earrings"
]

standard_unif_prompts = {
  "Standard_MALE": [
    "A photo of a person wearing jeans",
    "A photo of a person wearing casual attire",
    "A photo of a person wearing informal attire",
    "A photo of a person not wearing an ID lace",

    "A photo of a person wearing a light blue polo, an ID lace, navy slacks and black shoes"
  ],
  "Standard_FEMALE": [
    "A photo of a person wearing a skirt above the knee",
    "A photo of a person wearing casual attire",
    "A photo of a person wearing informal attire",
    "A photo of a person not wearing an ID lace",

    "A photo of a person wearing a black blazer with a white undershirt, an ID lace, a black skirt, and black shoes"
  ],
  "Civilian": [
    # inappropriate attire (visitor/civilian)
    "A photo of a person wearing ripped jeans",
    "A photo of a person wearing a sleeveless tank top",
    "A photo of a person wearing a midriff-baring crop top",
    "A photo of a person wearing a skirt higher than the knees",

    # appropriate attire
    "A photo of a person wearing a standard t-shirt and neat jeans",
    "A photo of a person wearing a modest polo shirt and trousers",
    "A photo of a person wearing appropriate, modest casual clothing"
  ],
  # "P.E. Uniform": [
  #   # inappropriate (change index to 1)
  #   "A photo of a person wearing a dark colored shirt",
  #   "A photo of a person wearing pants that are not dark blue",
  #   "A photo of a person wearing denim jeans",

  #   "A photo of a person wearing a white shirt and dark blue pants"
  # ]
#   "P.E. Uniform": [
#     # inappropriate (index 1)
#     "a photo of a person wearing a white t-shirt and light blue denim jeans",
#     "a photo of a person wearing a white t-shirt and faded blue wide-leg jeans",
#     "a photo of a person wearing a white t-shirt and dark blue denim jeans",
#     "a photo of a person wearing a white t-shirt and black jeans",
#     "a photo of a person wearing a white t-shirt and khaki cargo pants",
#     "a photo of a person wearing a dark colored shirt and jeans",

#     # appropriate (index 0)
#     "a photo of a person wearing a white t-shirt with a blue '100' and royal blue track pants with a white stripe down the side",
#     "a photo of a person wearing a white t-shirt with the words 'LAGUNA COLLEGE' and shiny blue polyester athletic pants",
#     "a photo of a person wearing a white t-shirt and blue sports jogging pants",
#     "a photo of a person in a white shirt and blue school PE pants",
# ]
#   "P.E. Uniform": [
#     "A photo of a person wearing a dark colored shirt",
#     "A photo of a person wearing pants that are not dark blue",
#     "A photo of a person wearing denim jeans",

#     "a photo of a person wearing a white t-shirt with the words 'LAGUNA COLLEGE' and '100' a and royal blue track pants with a white stripe down the side",
#     "a photo of a person wearing a white t-shirt with the words 'LAGUNA COLLEGE' and shiny blue polyester athletic pants",
#     "a photo of a person wearing a white t-shirt and blue sports jogging pants",
#     "a photo of a person in a white shirt and blue school PE pants",
# ]
  "P.E._Uniform": [
    # --- INAPPROPRIATE / CIVILIAN (Indices 0 to 3) ---
    "A photo of a person wearing a plain white t-shirt with no logo and light blue denim jeans", # Directly catches Image 2
    "A photo of a person wearing casual streetwear and baggy jeans",
    "A photo of a person wearing a dark or colored shirt",
    "A photo of a person wearing a standard school uniform polo shirt and slacks",

    # --- APPROPRIATE P.E. UNIFORM (Indices 4 to 5) ---
    "A photo of a student wearing a white t-shirt with a large circular blue graphic on the chest and royal blue athletic track pants with white side stripes",
    "A photo of a person wearing a physical education uniform consisting of a printed white shirt and shiny blue jogging pants"
  ]
}


# means that anything past 3 is appropriate attire
# allows confidence distribution to be "anchored", meaning that no two prompts can have a high confidence score
# can also dynamically change, for example becoming 0 if student needs to be wearing uniform
INAPPROPRIATE_MAX_INDEX = 2
PIERCING_MAX_INDEX = 1

# ---
# shared state
# ---
running = True
cap = None
# lock = threading.Lock()
freeze_frame = None
# prev_time = 0 # for fps
frame_timestamp_ms = 0 # for motion smoothing and so it works with RunningMode.VIDEO
latest_frame_bytes = None

# processing loop
freeze_frame = None
clip_frame = None
head_crop_frame = None

def capture_camera():
  global freeze_frame, frame_timestamp_ms, latest_frame_bytes, running, cap, clip_frame

  try:
    display_frame = None
    while running:
      # if freeze frame exists, display it
      if freeze_frame is not None:
        display_frame = freeze_frame
      else:
        success, frame = cap.read()
        if not success:
          time.sleep(0.01)
          continue

        # flip frame
        frame = cv2.flip(frame, 1)

        # mediapipe/pose estimation
        rgb = cv2.cvtColor(frame, cv2.COLOR_BGR2RGB)
        mp_image = mp.Image(image_format=mp.ImageFormat.SRGB, data=rgb)
        frame_timestamp_ms += 33

        result = pose_landmarker.detect_for_video(mp_image, frame_timestamp_ms)
        height, width = frame.shape[:2]

        if result.pose_landmarks:
          landmarks = result.pose_landmarks[0]

          # ---
          # uniform/attire checking
          # ---
          # get landmarks of nose, left and right ankles
          # nose = 0, left ankle = 27, right ankle = 28
          # alt: left and right feet indexes = 31, 32

          nose_norm_coords = landmarks[0]
          l_foot_norm_coords, r_foot_norm_coords = landmarks[31], landmarks[32]

          # # ---
          # # earrings/piercings checking (male students)
          # # ---
          # # get landmarks of ears and shoulders

          # l_ear_norm_coords, r_ear_norm_coords = landmarks[7], landmarks[8]
          # l_shoulder_norm_coords, r_shoulder_norm_coords = landmarks[11], landmarks[12]

          # # calculate space taken up by head in frame
          # head_x_norm_coords = [l_ear_norm_coords.x, r_ear_norm_coords.x, nose_norm_coords.x]
          # head_y_min = min(l_ear_norm_coords.y, r_ear_norm_coords.y)
          # head_y_max = min(l_shoulder_norm_coords.y, r_shoulder_norm_coords.y)

          # # draw circles over landmarks (debugging)
          # # landmarks_norm_coords_array = (nose_norm_coords, l_foot_norm_coords, r_foot_norm_coords)
          # # for landmark in landmarks_norm_coords_array:
          # #   landmark_x = int(landmark.x * width)
          # #   landmark_y = int(landmark.y * height)
          # #   cv2.circle(frame, (landmark_x, landmark_y), 20, (0, 255, 0), -1) 

          # calculate space taken up by body in frame
          highest_foot_landmark = max(l_foot_norm_coords.y, r_foot_norm_coords.y)
          body_ratio = highest_foot_landmark - nose_norm_coords.y
          # show percentage of frame taken up by body (debugging)
          # cv2.putText(frame, "Body takes up " + f"{body_ratio:.2f}" + "% of frame", (50, 50), cv2.FONT_HERSHEY_SIMPLEX, 2, (255, 0, 0), 2)

          # freeze frame once full body is in frame
          low_threshold = 0.70
          high_threshold = 0.80
          if low_threshold < body_ratio < high_threshold:
            # cv2.putText(frame, "VALID", (50, 50), cv2.FONT_HERSHEY_SIMPLEX, 2, (0, 255, 0), 2)
            freeze_frame = frame.copy()

            # ---
            # crop image to student before sending to CLIP
            # ---

            # get all normalized coordinates
            all_x_norm_coords = [landmark.x for landmark in landmarks]
            all_y_norm_coords = [landmark.y for landmark in landmarks]

            # convert to pixel coordinates
            x_min, x_max = int(min(all_x_norm_coords) * width), int(max(all_x_norm_coords) * width)
            y_min, y_max = int(min(all_y_norm_coords) * height), int(max(all_y_norm_coords) * height)

            # add padding
            padding_ratio_x = 0.05
            padding_ratio_y_bottom = 0.05
            padding_ratio_y_head = 0.15 # so head/face is included
            padding_x, padding_y_bottom, padding_y_top = int(width * padding_ratio_x), int(width * padding_ratio_y_bottom), int(width * padding_ratio_y_head)

            # constrain crop to be within bounds of frame (prevents slicing errors)
            x_min = max(0, x_min - padding_x)
            y_min = max(0, y_min - padding_y_top)
            x_max = min(width, x_max + padding_x)
            y_max = min(height, y_max + padding_y_bottom)

            # slice the frame array [x-range, y-range] for CLIP
            if x_max > x_min and y_max > y_min:
              clip_frame = frame[y_min:y_max, x_min:x_max].copy()

              # #show cropped frame (debugging)
              # cv2.imshow("Student Cropped Image", clip_frame)
            else:
              print("Bounding box invalid, skipping crop.")

            # # ---
            # # earrings/piercings checking (male students)
            # # ---
            # # convert to pixel coords
            # hd_x_min, hd_x_max = int(min(head_x_norm_coords) * width), int(min(head_x_norm_coords) * width)
            # hd_y_min, hd_y_max = int(head_y_min * height), int(head_y_max * height)
      
            # # add padding
            # hd_padding_ratio_x = 0.08
            # hd_padding_ratio_top = 0.10
            # hd_padding_x = int(width * hd_padding_ratio_x)
            # hd_padding_top = int(height * hd_padding_ratio_top)
      
            # hd_x_min = max(0, hd_x_min - hd_padding_x)
            # hd_y_min = max(0, hd_y_min - hd_padding_top)
            # hd_x_max = min(width, hd_x_max + hd_padding_top)
            # hd_y_max = min(height, hd_y_max)
      
            # if hd_x_max > hd_x_min and hd_y_max > hd_y_min:
            #   head_crop_frame = frame[hd_y_min:hd_y_max, hd_x_min:hd_x_max].copy()
            #   #show cropped frame (debugging)
            #   cv2.imshow("Head Cropped Image", head_crop_frame)
            # else:
            #   print("Bounding box invalid, skipping crop.")


          # # draw points on landmarks (debugging)
          # for pose in result.pose_landmarks:
          #   for landmark in pose:
          #     x = int(landmark.x * width)
          #     y = int(landmark.y * height)
          #     cv2.circle(frame, (x, y), 5, (0, 255, 0), -1)
        display_frame = frame    

      # ---
      # convert to jpg
      # ---
      ret, buffer = cv2.imencode(".jpg", display_frame)
      # frame_bytes = buffer.tobytes()
      if ret:
        latest_frame_bytes = buffer.tobytes()

      time.sleep(0.01)
  except Exception as e:
    print(f"\nCritical error in camera thread: {e}\n")
    running = False


# ---
# async lifespan manager
# ---
@asynccontextmanager
async def lifespan(app: FastAPI):
  global cap, running
  # start cam
  cap = cv2.VideoCapture(0)
  cam_thread = threading.Thread(target=capture_camera, daemon=True)
  cam_thread.start()
  yield
  # shutdown
  running = False
  cam_thread.join(timeout=2.0)

  if cap is not None and cap.isOpened():
    cap.release()

# ---
# fastapi setup
# ---
app = FastAPI(lifespan=lifespan)
app.add_middleware(
  CORSMiddleware,
  allow_origins=["http://localhost:8000", "http://localhost:5173", "http://127.0.0.1:8000"],
  allow_methods=["*"],
  allow_headers=["*"]
)

# ---
# streamer
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
  finally:
    print("A client stream disconnected")

# ---
# fast api endpoints
# ---
@app.get("/video_feed", dependencies=[Depends(verify_access)])
async def video_feed():
  return StreamingResponse(generate_frames(), media_type="multipart/x-mixed-replace; boundary=frame")

# reset frame (debugging; need way to do this automatically obv in actual)
@app.get("/reset_frame", dependencies=[Depends(verify_access)])
def reset_frame():
  global freeze_frame
  freeze_frame = None
  return {"status": "Frame reset"}

@app.get("/id_scanned")
def scan_demo():
  if freeze_frame is not None:
    # replace no. with scan from id here
    scanned_student_no = "H24-9001"
    attire_condition = get_student_attire_condition(scanned_student_no)

    rgb_clip_image = cv2.cvtColor(cv2.flip(clip_frame, 1), cv2.COLOR_BGR2RGB)
    pli_image = Image.fromarray(rgb_clip_image)

    attire_prompts = standard_unif_prompts[attire_condition]

    inputs = processor(text=attire_prompts, images=pli_image, return_tensors="pt", padding=True)
    outputs = model(**inputs)

    logits_per_image = outputs.logits_per_image
    probabilities = logits_per_image.softmax(dim=1).detach().numpy()[0]

    for prompt, probability in zip(attire_prompts, probabilities):
      print(f"{prompt}: {probability * 100:2f}%")

    best_match_idx = probabilities.argmax()
    best_match_probability = probabilities[best_match_idx]

    # ---
    # confidence-based routing
    # ---    
    confidence_threshold = 0.65

    # 1. low confidence scan (send to guard)
    if best_match_probability < confidence_threshold:
      print(f"FLAGGED FOR REVIEW: Low confidence scan ({best_match_probability * 100:.2f}%). Guard must manually verify.")
    # 2. attire is deemed inappropriate
    elif best_match_idx <= INAPPROPRIATE_MAX_INDEX:
      print(f"DENIED: Inappropriate attire detected ({attire_prompts[best_match_idx]} at {best_match_probability * 100:.2f}%).")
    # 3. attire is compliant with high confidence
    else:
      print(f"APPROVED: Compliant attire ({attire_prompts[best_match_idx]} at {best_match_probability * 100:.2f}%).")

    return {"status": "ID scanned"}

# run fastapi server
if __name__ == "__main__":
  uvicorn.run(app, host="127.0.0.1", port=8002)