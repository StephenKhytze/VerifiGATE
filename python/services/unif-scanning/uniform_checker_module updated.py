# import time
import os
import cv2
import mediapipe as mp
from mediapipe.tasks import python
from mediapipe.tasks.python import vision
from PIL import Image
from transformers import CLIPProcessor, CLIPModel
from db_utils import get_student_attire_condition


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
  ]
}


# means that anything past 3 is appropriate attire
# allows confidence distribution to be "anchored", meaning that no two prompts can have a high confidence score
# can also dynamically change, for example becoming 0 if student needs to be wearing uniform
INAPPROPRIATE_MAX_INDEX = 3
PIERCING_MAX_INDEX = 1

# webcam setup
cap = cv2.VideoCapture(0)

if not cap.isOpened():
  raise RuntimeError("Cannot open webcam.")

# prev_time = 0 # for fps
frame_timestamp_ms = 0 # for motion smoothing and so it works with RunningMode.VIDEO

# processing loop
freeze_frame = None
clip_frame = None
head_crop_frame = None

try:
  while True:
    success, frame = cap.read()
    if not success:
      break

    if freeze_frame is not None:
      cv2.imshow("Student-facing Monitor Testing", freeze_frame)

      # close by clicking "q" and "r" to reset freeze frame (debugging)
      key = cv2.waitKey(1) & 0xFF
      if key == ord("r"):
        freeze_frame = None
        head_crop_frame = None
      elif key == ord("s"): # fake scan (debugging)
        print("\n--- SIMULATED ID SCAN AND CLIP PROCESSING ---")

        # demo student no.
        scanned_student_no = "H24-9003"
        attire_condition = get_student_attire_condition(scanned_student_no)

        print(f"Attire condition: {attire_condition}")

        # convert image from cv's bgr array to rgb pli image for clip
        rgb_clip_image = cv2.cvtColor(clip_frame, cv2.COLOR_BGR2RGB)
        pli_image = Image.fromarray(rgb_clip_image)

        attire_prompts = standard_unif_prompts[attire_condition]

        # process the images + prompts
        inputs = processor(text=attire_prompts, images=pli_image, return_tensors="pt", padding=True)
        outputs = model(**inputs)

        # get confidence scores
        logits_per_image = outputs.logits_per_image
        probabilities = logits_per_image.softmax(dim=1).detach().numpy()[0]

        # display results
        for prompt, probability in zip(attire_prompts, probabilities):
          print(f"{prompt}: {probability * 100:.2f}%")

        # determine highest confidence match
        best_match_idx = probabilities.argmax()
        best_match_probability = probabilities[best_match_idx]

        # ---
        # confidence-based routing
        # ---

        # change threshold if necessary
        confidence_threshold = 0.65

        # 1. low confidence scan (send to guard)
        if best_match_probability < confidence_threshold:
          print(f"FLAGGED FOR REVIEW: Low confidence scan ({best_match_probability * 100:.2f}%). Guard must manually verify.")
        # 2. attire is deemed inappropriate
        elif best_match_idx <= INAPPROPRIATE_MAX_INDEX:
          print(f"DENIED: Inappropriate attire detected ({attire_prompts[best_match_idx]} at {best_match_probability * 100:.2f}%).")
        # 3. attire is compliant with high confidence
        else:
          print(f"APPROVED: Compliant civilian attire ({attire_prompts[best_match_idx]} at {best_match_probability * 100:.2f}%).")

        # print(f"\nResult: Best match is '{attire_prompts[best_match_idx]}' with {probabilities[best_match_idx] * 100:.2f}% confidence")

        if head_crop_frame is not None:
          print("\n--- SIMULATED PIERCING SCAN ---")

          # convert image from cv's bgr array to rgb pli image for clip
          rgb_head_clip_image = cv2.cvtColor(head_crop_frame, cv2.COLOR_BGR2RGB)
          pli_head_image = Image.fromarray(rgb_head_clip_image)
  
          # process the images + prompts
          inputs_head = processor(text=piercing_prompts, images=pli_head_image, return_tensors="pt", padding=True)
          outputs_head = model(**inputs_head)
  
          # get confidence scores
          logits_per_head_image = outputs_head.logits_per_image
          probabilities_head = logits_per_head_image.softmax(dim=1).detach().numpy()[0]
  
          # display results
          for prompt, probability in zip(piercing_prompts, probabilities_head):
            print(f"{prompt}: {probability * 100:.2f}%")
  
          # determine highest confidence match
          head_best_match_idx = probabilities_head.argmax()
          head_best_match_probability = probabilities_head[head_best_match_idx]

          if head_best_match_idx <= PIERCING_MAX_INDEX:
            print(f"DENIED: Earrings/piercings detected ({piercing_prompts[head_best_match_idx]} at {head_best_match_probability * 100:.2f}%).")
          else:
            print(f"No piercings/earrings detected ({piercing_prompts[head_best_match_idx]} at {head_best_match_probability * 100:.2f}%).")

          
          
      elif key == ord("q"):
        break
      continue

    # mirror frame
    frame = cv2.flip(frame, 1)
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

      # ---
      # earrings/piercings checking (male students)
      # ---
      # get landmarks of ears and shoulders

      l_ear_norm_coords, r_ear_norm_coords = landmarks[7], landmarks[8]
      l_shoulder_norm_coords, r_shoulder_norm_coords = landmarks[11], landmarks[12]

      # calculate space taken up by head in frame
      head_x_norm_coords = [l_ear_norm_coords.x, r_ear_norm_coords.x, nose_norm_coords.x]
      head_y_min = min(l_ear_norm_coords.y, r_ear_norm_coords.y)
      head_y_max = min(l_shoulder_norm_coords.y, r_shoulder_norm_coords.y)

      # draw circles over landmarks (debugging)
      # landmarks_norm_coords_array = (nose_norm_coords, l_foot_norm_coords, r_foot_norm_coords)
      # for landmark in landmarks_norm_coords_array:
      #   landmark_x = int(landmark.x * width)
      #   landmark_y = int(landmark.y * height)
      #   cv2.circle(frame, (landmark_x, landmark_y), 20, (0, 255, 0), -1) 

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
        y_min, y_max = int(min(all_y_norm_coords) * width), int(max(all_y_norm_coords) * height)

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

          #show cropped frame (debugging)
          cv2.imshow("Student Cropped Image", clip_frame)
        else:
          print("Bounding box invalid, skipping crop.")

        # ---
        # earrings/piercings checking (male students)
        # ---
        # convert to pixel coords
        hd_x_min, hd_x_max = int(min(head_x_norm_coords) * width), int(min(head_x_norm_coords) * width)
        hd_y_min, hd_y_max = int(head_y_min * height), int(head_y_max * height)
  
        # add padding
        hd_padding_ratio_x = 0.08
        hd_padding_ratio_top = 0.10
        hd_padding_x = int(width * hd_padding_ratio_x)
        hd_padding_top = int(height * hd_padding_ratio_top)
  
        hd_x_min = max(0, hd_x_min - hd_padding_x)
        hd_y_min = max(0, hd_y_min - hd_padding_top)
        hd_x_max = min(width, hd_x_max + hd_padding_top)
        hd_y_max = min(height, hd_y_max)
  
        if hd_x_max > hd_x_min and hd_y_max > hd_y_min:
          head_crop_frame = frame[hd_y_min:hd_y_max, hd_x_min:hd_x_max].copy()
          #show cropped frame (debugging)
          cv2.imshow("Head Cropped Image", head_crop_frame)
        else:
          print("Bounding box invalid, skipping crop.")


      # # draw points on landmarks (debugging)
      # for pose in result.pose_landmarks:
      #   for landmark in pose:
      #     x = int(landmark.x * width)
      #     y = int(landmark.y * height)
      #     cv2.circle(frame, (x, y), 5, (0, 255, 0), -1)

      cv2.imshow("Student-facing Monitor Testing", frame)

    # close by clicking "q" (debugging)
    if cv2.waitKey(1) & 0xFF == ord("q"):
      break

finally:
  cap.release()
  cv2.destroyAllWindows()
