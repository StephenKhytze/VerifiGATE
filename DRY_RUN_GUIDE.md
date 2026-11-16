# VerifiGATE Dry-Run & Integration Guide (`teten-integrated`)

This guide explains how the integrated system works and provides step-by-step instructions for running an end-to-end dry run, including testing options if you only have one camera.

---

## 1. How the Integrated System Works

The system connects two AI services and a Laravel web application to form an automated school gate turnstile verification system:

```text
[Camera 1: Desk]                [Camera 2: Standing]
       │                                │
       ▼                                ▼
ID Capture Worker             Uniform Checker (Port 8002)
 (capture.py)                 (MediaPipe Pose + CLIP)
       │                                │
       │ (Cropped ID JPEG)              │ (MJPEG Stream + Freeze-Frame)
       ▼                                ▼
Laravel API (Port 8000) ───────> Student Screen (/gate/screen)
       │
       ├──── POST Image ───> OCR Service (Port 8001: PaddleOCR)
       │                         │ (Student ID number & Name)
       │ <── Returns Text ───────┘
       │
       ├──── Fetch Database ───> Student record & Sex from DB
       │
       ├──── GET /id_scanned ──> Uniform Checker (Port 8002)
       │                         │ (Evaluates frozen crop against CLIP prompts)
       │ <── Compliant/Flagged ──┘
       │
       ▼
Guard Monitor (/gate/guard)
(Shows combined Student Details, ID Photo, and Uniform Result)
```

---

## 2. The 2-Camera Setup & Dry-Run Options

Production requires two camera feeds:
* **Camera 1 (ID Scanner)**: Points down at the card scanning surface.
* **Camera 2 (Uniform / Face)**: Faces the student standing in front of the screen.

Because Windows does not allow two processes to open camera index `0` at the same time, choose one of these testing options:

### Option A: Use a Smartphone as Camera 2 (Recommended for Full Testing)
1. Install **DroidCam**, **Camo**, or **Iriun Webcam** on your phone and PC.
2. Connect your phone via USB cable or local Wi-Fi.
3. Your computer now has two separate camera devices:
   * Built-in webcam = Camera Index `0` (used for ID scanning).
   * Phone webcam = Camera Index `1` (used for Uniform checking).
4. Launch the services:
   ```bash
   # Terminal for ID Capture (defaults to index 0)
   python capture.py --debug

   # Terminal for Uniform Checker (set to index 1)
   set UNIF_CAMERA_INDEX=1
   uvicorn uniform_checker_module:app --host 127.0.0.1 --port 8002
   ```

### Option B: Use a Pre-recorded Video for Camera 2 (No Extra Hardware Needed)
You can record a 5-second video on your phone of yourself standing in uniform and save it as `test_student.mp4` inside `python/services/unif-scanning/`:
```bash
set UNIF_CAMERA_INDEX=test_student.mp4
uvicorn uniform_checker_module:app --host 127.0.0.1 --port 8002
```
OpenCV will treat the video file as a camera stream and loop through it automatically!

### Option C: Sequential Testing / Stub Mode (Single Laptop Webcam)
If you only want to test the ID Scanner first without the uniform camera running:
1. In `web/.env`, set:
   ```env
   UNIFORM_MODE=stub_compliant
   ```
2. Run `capture.py` on your webcam (`0`). When an ID is scanned, Laravel will simulate a compliant uniform check without calling port 8002.

---

## 3. Environment & Token Configuration

The React frontend and Python services authenticate using synchronized tokens:

### 1. Generate a secure token
In PowerShell or terminal:
```bash
python -c "import secrets; print(secrets.token_hex(32))"
```

### 2. Configure Python services
* Create `python/services/unif-scanning/.env`:
  ```env
  GATE_TOKEN=your_generated_token_here
  ```
* In `python/services/id-capture` (set via environment or script):
  ```env
  STATION_TOKEN=station_secret_token
  LARAVEL_URL=http://127.0.0.1:8000
  ```

### 3. Configure Laravel & React (`web/.env`)
Ensure your `web/.env` contains:
```env
# Synchronized with uniform_checker_module
VITE_GATE_TOKEN=your_generated_token_here

# Stations and OCR
STATION_TOKEN=station_secret_token
OCR_URL=http://127.0.0.1:8001
OCR_TOKEN=ocr_secret_token
CROP_URL=http://127.0.0.1:8003
```

---

## 4. Database Setup

Ensure the database schema includes Stephen's new `sex` column and test students:

```bash
cd web
php artisan migrate
```

*(Optional: If you want to populate sample student data, import `databases_backup.sql` into your database).*

---

## 5. Starting the 4 Processes

Open 4 separate terminal windows:

### Terminal 1: Laravel Web & Frontend
```bash
cd web
composer run dev
```
*(Starts the Laravel API at `http://127.0.0.1:8000` and Vite dev server).*

### Terminal 2: OCR Service
```bash
cd python/services/id-ocr
uvicorn app.main:app --host 127.0.0.1 --port 8001
```

### Terminal 3: Uniform Checker Service
```bash
cd python/services/unif-scanning
# If using smartphone as 2nd cam: set UNIF_CAMERA_INDEX=1
uvicorn uniform_checker_module:app --host 127.0.0.1 --port 8002
```

### Terminal 4: ID Capture Worker
```bash
cd python/services/id-capture
python capture.py --debug
```

---

## 6. End-to-End Verification in Browser

Open two browser windows side-by-side:

1. **Student-Facing Screen** (`http://127.0.0.1:8000/gate/screen`):
   * You should see the live camera feed streamed from the Uniform Checker (`http://localhost:8002/video_feed`).
   * When a full body is detected, it freezes the frame ready for evaluation.

2. **Guard Screen** (`http://127.0.0.1:8000/gate/guard`):
   * Place a test student ID in front of the ID capture camera.
   * The capture worker snaps the ID, sends it to Laravel, which calls the OCR service.
   * Laravel looks up the student in the database (including their `sex`), requests uniform evaluation from port 8002, and pushes the event to the guard screen.
   * The guard screen displays:
     * Student photo & ID crop
     * Name, Student Number, Section, Sex
     * Uniform evaluation status (`Compliant`, `NonCompliant`, etc.)
     * Action buttons (`Approve` / `Deny`).
