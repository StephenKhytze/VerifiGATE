# VerifiGATE Dry-Run & Integration Guide (`teten-integrated`)

This guide explains how the integrated system works and provides step-by-step instructions for running an end-to-end dry run, including testing options if you only have one camera.

> For a detailed technical changelog of the integration fixes between Nick's and Kitz's branches, see [change.md](file:///c:/Users/TennyWoop/.gemini/antigravity/scratch/VerifiGATE/change.md).

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
       ├──── GET /id_scanned?student_number=...&sex=... ──> Uniform Checker (Port 8002)
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
   # Terminal for ID Capture (defaults to index 0, preview window opens automatically)
   python capture.py

   # Terminal for Uniform Checker (set to index 1 or direct phone Wi-Fi URL)
   set UNIF_CAMERA_INDEX=1
   # Or for direct DroidCam Wi-Fi stream:
   # set UNIF_CAMERA_INDEX=http://192.168.1.X:4747/video
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
If you want to test the ID Scanner first without running the uniform checker service:
1. In `web/.env`, set:
   ```env
   UNIFORM_MODE=stub_compliant
   ```
2. Run `capture.py` on your webcam (`0`). When an ID is scanned, Laravel will simulate a compliant uniform check (`99.0%` confidence) without calling port 8002.

---

## 3. Environment & Token Configuration

All services are pre-configured with default development tokens matching `web/.env.example`:

| Variable | Default Value | Used By |
| :--- | :--- | :--- |
| `VITE_GATE_TOKEN` / `GATE_TOKEN` | `a9e7aa90f9de0a3d04c7e5b46d5923a7fe5ed65813fa131d05a2a40d64511845` | React screen, Uniform Checker (8002), Laravel |
| `STATION_TOKEN` | `35a3ac2aa19d749dba6489e3a22ec9e7a6a012a0f1ef4c6913b7d7646fa2dbf0` | ID Capture (8003) & Laravel Station API |
| `OCR_TOKEN` | `a9e7aa90f9de0a3d04c7e5b46d5923a7fe5ed65813fa131d05a2a40d64511845` | OCR Service (8001) & Laravel |
| `OCR_TIMEOUT` | `15` | Laravel OCR client timeout in seconds |
| `CROP_URL` | `http://127.0.0.1:8003` | ID Capture crop streaming endpoint |

*(If you generate custom tokens, ensure they are placed in `web/.env` and the corresponding service `.env` files).*

---

## 4. Database Setup

Ensure the database schema includes the `sex` column and test students:

```bash
cd web
php artisan migrate
php artisan db:seed --class=GateDemoSeeder
```

*(Populates sample students including `H24-9001`, `H24-0137`, `H24-9002`, `H24-9003`, `C24-9001`, `C23-0270` with valid sexes and sections).*

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
# If using smartphone as 2nd cam:
set UNIF_CAMERA_INDEX=1
uvicorn uniform_checker_module:app --host 127.0.0.1 --port 8002
```

### Terminal 4: ID Capture Worker
```bash
cd python/services/id-capture
python capture.py
```
*(A preview window opens automatically showing the camera feed and detection zone).*

---

## 6. End-to-End Verification in Browser

Open two browser windows side-by-side:

1. **Student-Facing Screen** (`http://127.0.0.1:8000/gate/screen`):
   * You should see the live camera feed streamed from the Uniform Checker (`http://localhost:8002/video_feed`).
   * When a full body is detected, it freezes the frame ready for evaluation.

2. **Guard Screen** (`http://127.0.0.1:8000/gate/guard`):
   * Place a test student ID in front of the ID capture camera.
   * The capture worker snaps the ID, sends it to Laravel, which calls the OCR service.
   * Laravel looks up the student in the database (including their `sex`), requests uniform evaluation from port 8002 with `student_number` and `sex`, and pushes the event to the guard screen.
   * The guard screen displays:
     * Student photo & ID crop
     * Name, Student Number, Section, Sex
     * Uniform evaluation status (`Compliant`, `Non-compliant`, `Low Confidence`, or `Unavailable`)
     * Action buttons (`Approve` / `Deny`).
