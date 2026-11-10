import argparse
import hmac
import os
import re
import sys
import threading
import time
from http.server import BaseHTTPRequestHandler, ThreadingHTTPServer

import cv2
import numpy as np
import requests

LARAVEL = os.environ.get("LARAVEL_URL", "http://127.0.0.1:8000")
TOKEN = os.environ["STATION_TOKEN"]
CAM = int(os.environ.get("CAMERA_INDEX", "0"))
CAM_W = int(os.environ.get("CAM_W", "1920"))
CAM_H = int(os.environ.get("CAM_H", "1080"))
CROP_PORT = int(os.environ.get("CROP_PORT", "8003"))

# ---- scan zone (fractions of the frame) ----
ZONE_X = float(os.environ.get("ZONE_X", "0.5"))          # zone center, across
ZONE_Y = float(os.environ.get("ZONE_Y", "0.5"))          # zone center, down
ZONE_SIZE = float(os.environ.get("ZONE_SIZE", "0.8"))    # zone height as a fraction of frame height
ZONE_RATIO = float(os.environ.get("ZONE_RATIO", "1.0"))  # width / height; 1.0 = square

# ---- "is there an ID in the zone" (starting values: tune with the debug line) ----
PRESENCE = os.environ.get("PRESENCE", "text")                       # "text" or "edges"
MIN_TEXT_LINES = int(os.environ.get("MIN_TEXT_LINES", "4"))
TEXT_COVERAGE = float(os.environ.get("TEXT_COVERAGE", "0.2"))       # text region / zone area
EDGE_MIN = float(os.environ.get("EDGE_MIN", "0.04"))                # edge density, for PRESENCE=edges
MOTION_MAX = float(os.environ.get("MOTION_MAX", "5.0"))             # 0-255 scale; camera noise is about 2
READY_FRAMES = 6
MIN_SHARPNESS = float(os.environ.get("MIN_SHARPNESS", "60"))
SOFT_SEND_AFTER = 3.0        # ready but never sharp: send anyway after this many seconds
CLEAR_SECONDS = 1.5          # the zone must be empty this long before re-arming
RETRY_TIMEOUT = 4.0          # after a "retry" answer, wait this long for a new steady frame
PROC_SIDE = 480              # the zone is shrunk to this size for the cheap analysis
MAX_CROP_SIDE = int(os.environ.get("MAX_CROP_SIDE", "1100"))
JPEG_QUALITY = 85
CROP_TTL = 600               # seconds a crop stays in memory
CROP_MAX_ITEMS = 50

# ---- crops kept in memory only, served to Laravel on 127.0.0.1 ----
CROPS = {}                   # event_id -> (expires_at, jpeg bytes)
CROPS_LOCK = threading.Lock()


def remember(event_id, jpeg):
    now = time.monotonic()
    with CROPS_LOCK:
        for k in [k for k, (t, _) in CROPS.items() if t < now]:
            del CROPS[k]
        CROPS[event_id] = (now + CROP_TTL, jpeg)
        while len(CROPS) > CROP_MAX_ITEMS:
            CROPS.pop(next(iter(CROPS)))


class CropHandler(BaseHTTPRequestHandler):
    def do_GET(self):
        given = self.headers.get("X-Station-Token", "")
        if not hmac.compare_digest(given.encode(), TOKEN.encode()):
            self.send_error(401)
            return
        m = re.fullmatch(r"/crops/(\d+)", self.path)
        if not m:
            self.send_error(404)
            return
        with CROPS_LOCK:
            item = CROPS.get(int(m.group(1)))
        if not item or item[0] < time.monotonic():
            self.send_error(404)
            return
        self.send_response(200)
        self.send_header("Content-Type", "image/jpeg")
        self.send_header("Content-Length", str(len(item[1])))
        self.send_header("Cache-Control", "no-store")
        self.end_headers()
        self.wfile.write(item[1])

    def log_message(self, *args):
        pass                 # no request logging


def start_crop_server():
    server = ThreadingHTTPServer(("127.0.0.1", CROP_PORT), CropHandler)
    threading.Thread(target=server.serve_forever, daemon=True).start()


# ---- the scan zone ----
def zone_rect(shape, z):
    """Pixel rectangle (x0, y0, x1, y1) of the scan zone inside a frame."""
    h, w = shape[:2]
    zh = min(z["size"] * h, h)
    zw = min(zh * ZONE_RATIO, w)
    zh = min(zh, zw / ZONE_RATIO)
    x0 = int(np.clip(z["x"] * w - zw / 2, 0, w - zw))
    y0 = int(np.clip(z["y"] * h - zh / 2, 0, h - zh))
    return x0, y0, x0 + int(zw), y0 + int(zh)


def text_cluster(gray):
    """Cheap text finder (no OCR): wide, short, dense blobs. Returns (x, y, w, h, line_count) or None."""
    kernel = cv2.getStructuringElement(cv2.MORPH_ELLIPSE, (3, 3))
    grad = cv2.morphologyEx(gray, cv2.MORPH_GRADIENT, kernel)
    _, binary = cv2.threshold(grad, 0, 255, cv2.THRESH_BINARY | cv2.THRESH_OTSU)
    joined = cv2.morphologyEx(binary, cv2.MORPH_CLOSE, cv2.getStructuringElement(cv2.MORPH_RECT, (13, 1)))
    contours, _ = cv2.findContours(joined, cv2.RETR_EXTERNAL, cv2.CHAIN_APPROX_SIMPLE)

    boxes = []
    for c in contours:
        x, y, w, h = cv2.boundingRect(c)
        if 5 <= h <= 40 and w >= 25 and w / h >= 2.0 and cv2.countNonZero(binary[y:y + h, x:x + w]) / (w * h) >= 0.2:
            boxes.append((x, y, w, h))
    if len(boxes) < MIN_TEXT_LINES:
        return None
    x0 = min(b[0] for b in boxes)
    y0 = min(b[1] for b in boxes)
    x1 = max(b[0] + b[2] for b in boxes)
    y1 = max(b[1] + b[3] for b in boxes)
    return x0, y0, x1 - x0, y1 - y0, len(boxes)


def analyse(small):
    """small = the zone, grayscale, shrunk. Returns (present, text_lines, text_coverage, edge_density)."""
    t = text_cluster(small)
    sh, sw = small.shape
    lines = t[4] if t else 0
    coverage = (t[2] * t[3]) / (sw * sh) if t else 0.0
    edges = cv2.Canny(cv2.GaussianBlur(small, (5, 5), 0), 50, 150)
    density = float(np.count_nonzero(edges)) / edges.size
    if PRESENCE == "edges":
        present = density >= EDGE_MIN
    else:
        present = t is not None and coverage >= TEXT_COVERAGE
    return present, lines, coverage, density


def sharpness(img):
    gray = img if img.ndim == 2 else cv2.cvtColor(img, cv2.COLOR_BGR2GRAY)
    return float(cv2.Laplacian(gray, cv2.CV_64F).var())


def make_crop(roi):
    s = MAX_CROP_SIDE / max(roi.shape[:2])
    if s < 1:
        return cv2.resize(roi, None, fx=s, fy=s, interpolation=cv2.INTER_AREA)
    return roi.copy()


# ---- cameras ----
def open_camera(index):
    cap = cv2.VideoCapture(index, cv2.CAP_DSHOW)      # DirectShow backend (Windows)
    if not cap.isOpened():
        cap.release()
        return None
    cap.set(cv2.CAP_PROP_FOURCC, cv2.VideoWriter_fourcc(*"MJPG"))
    cap.set(cv2.CAP_PROP_FRAME_WIDTH, CAM_W)
    cap.set(cv2.CAP_PROP_FRAME_HEIGHT, CAM_H)
    return cap


def switch_camera(cap, index, tries=5):
    cap.release()
    for step in range(1, tries + 1):
        candidate = (index + step) % tries
        new = open_camera(candidate)
        if new is not None:
            return new, candidate
    return open_camera(index), index


# ---- talking to Laravel ----
def fire_signal(state):
    """Tell Laravel a card is steady / the zone is clear. Runs in a thread so capture never stalls."""
    def run():
        try:
            requests.post(f"{LARAVEL}/api/station/signal", json={"state": state},
                          headers={"X-Station-Token": TOKEN}, timeout=2)
        except requests.RequestException:
            pass
    threading.Thread(target=run, daemon=True).start()


def submit(crop, attempt):
    """Send one crop. Returns the result string, or None on a network/server error."""
    ok, buf = cv2.imencode(".jpg", crop, [cv2.IMWRITE_JPEG_QUALITY, JPEG_QUALITY])
    if not ok:
        return None
    jpeg = buf.tobytes()
    try:
        r = requests.post(
            f"{LARAVEL}/api/station/scans",
            params={"attempt": attempt},
            data=jpeg,
            headers={"X-Station-Token": TOKEN, "Content-Type": "image/jpeg"},
            timeout=8,
        )
        r.raise_for_status()
        body = r.json()
        if body.get("event_id"):
            remember(int(body["event_id"]), jpeg)    # memory only, for the guard's screen
        print(f"[{time.strftime('%H:%M:%S')}] attempt {attempt} -> {body.get('result')}")   # never print card contents
        return body.get("result")
    except requests.RequestException as e:
        print(f"[{time.strftime('%H:%M:%S')}] send failed: {e.__class__.__name__}")
        return None


def main(debug):
    cam_index = CAM
    cap = open_camera(cam_index)
    if cap is None:
        sys.exit("Camera not available. Check CAMERA_INDEX.")
    print(f"camera {cam_index} running at {int(cap.get(cv2.CAP_PROP_FRAME_WIDTH))}x{int(cap.get(cv2.CAP_PROP_FRAME_HEIGHT))}")

    start_crop_server()

    zone = {"x": ZONE_X, "y": ZONE_Y, "size": ZONE_SIZE}
    state, attempt = "armed", 1
    last_crop, first_try_at = None, 0.0
    last_seen, steady_since = 0.0, None
    signaled = False
    ready, prev_tiny = 0, None
    frames, last_report = 0, 0.0

    while True:
        ok, frame = cap.read()
        if not ok:
            time.sleep(0.1)
            continue
        now = time.monotonic()

        x0, y0, x1, y1 = zone_rect(frame.shape, zone)
        roi = frame[y0:y1, x0:x1]
        gray = cv2.cvtColor(roi, cv2.COLOR_BGR2GRAY)
        scale = PROC_SIDE / max(gray.shape)
        small = cv2.resize(gray, None, fx=scale, fy=scale, interpolation=cv2.INTER_AREA)

        present, lines, coverage, density = analyse(small)
        tiny = cv2.resize(small, (48, 48), interpolation=cv2.INTER_AREA)
        motion = 255.0 if prev_tiny is None else float(np.mean(cv2.absdiff(tiny, prev_tiny)))
        prev_tiny = tiny

        if present:
            last_seen = now
        else:
            steady_since = None
        # "ready" counts up while the card is present and still, and decays by 1 otherwise,
        # so one bad frame (a finger, a blink of light) does not reset it
        ready = min(ready + 1, READY_FRAMES) if (present and motion <= MOTION_MAX) else max(ready - 1, 0)

        if state == "wait_clear":
            if not present and now - last_seen >= CLEAR_SECONDS:
                state, attempt, last_crop, steady_since, ready = "armed", 1, None, None, 0
                if signaled:
                    fire_signal("clear")
                    signaled = False
        else:
            if not present and signaled and attempt == 1 and now - last_seen >= CLEAR_SECONDS:
                fire_signal("clear")                  # the card left before a scan was sent
                signaled = False

            if attempt == 2 and last_crop is not None and now - first_try_at > RETRY_TIMEOUT:
                submit(last_crop, 2)                  # last chance with the previous crop
                state = "wait_clear"
            elif ready >= READY_FRAMES:
                if not signaled:
                    fire_signal("card")
                    signaled = True
                steady_since = steady_since or now
                crop = make_crop(roi)
                if sharpness(crop) >= MIN_SHARPNESS or (now - steady_since) > SOFT_SEND_AFTER:
                    last_crop = crop
                    if debug:
                        print(f"crop {crop.shape[1]}x{crop.shape[0]}  sharpness={sharpness(crop):.0f}")
                        cv2.imshow("last crop sent", crop)        # shown from memory only, never saved
                    result = submit(crop, attempt)
                    if result == "retry":
                        attempt, first_try_at = 2, now
                        steady_since, ready = None, 0
                    else:
                        state = "wait_clear"

        if debug:
            frames += 1
            if now - last_report > 2:
                print(f"cam={cam_index} fps~{frames / 2:.0f} present={'yes' if present else 'no'} "
                      f"lines={lines} coverage={coverage:.2f} edges={density:.3f} motion={motion:.1f} "
                      f"sharp={sharpness(gray):.0f} ready={ready}/{READY_FRAMES} state={state}")
                frames, last_report = 0, now

            view = (frame * 0.35).astype(np.uint8)             # darken everything outside the zone
            view[y0:y1, x0:x1] = roi
            color = (0, 255, 0) if ready >= READY_FRAMES else ((0, 255, 255) if present else (255, 255, 255))
            cv2.rectangle(view, (x0, y0), (x1, y1), color, 4)     # green ready / yellow present / white empty
            cv2.putText(view, f"cam {cam_index} | {state} attempt={attempt} ready={ready}/{READY_FRAMES}",
                        (20, 40), cv2.FONT_HERSHEY_SIMPLEX, 1, (0, 255, 255), 2)
            cv2.putText(view, "C camera | WASD move zone | +/- resize | Q quit", (20, view.shape[0] - 20),
                        cv2.FONT_HERSHEY_SIMPLEX, 0.8, (255, 255, 255), 2)
            cv2.imshow("capture", cv2.resize(view, None, fx=0.5, fy=0.5))

            key = cv2.waitKey(1) & 0xFF
            if key == ord("q"):
                break
            if key in (ord("w"), ord("a"), ord("s"), ord("d"), ord("+"), ord("="), ord("-")):
                if key == ord("w"): zone["y"] -= 0.02
                if key == ord("s"): zone["y"] += 0.02
                if key == ord("a"): zone["x"] -= 0.02
                if key == ord("d"): zone["x"] += 0.02
                if key in (ord("+"), ord("=")): zone["size"] += 0.02
                if key == ord("-"): zone["size"] -= 0.02
                zone["x"], zone["y"] = float(np.clip(zone["x"], 0, 1)), float(np.clip(zone["y"], 0, 1))
                zone["size"] = float(np.clip(zone["size"], 0.2, 1.0))
                print(f"ZONE_X={zone['x']:.2f}  ZONE_Y={zone['y']:.2f}  ZONE_SIZE={zone['size']:.2f}   (copy into .env)")
                ready, prev_tiny = 0, None
            if key == ord("c"):
                cap, cam_index = switch_camera(cap, cam_index)
                if cap is None:
                    sys.exit("No camera could be opened.")
                print(f"camera {cam_index} running at {int(cap.get(cv2.CAP_PROP_FRAME_WIDTH))}x{int(cap.get(cv2.CAP_PROP_FRAME_HEIGHT))}")
                state, attempt, last_crop, steady_since, ready, prev_tiny = "armed", 1, None, None, 0, None
                if signaled:
                    fire_signal("clear")
                    signaled = False

    cap.release()
    cv2.destroyAllWindows()


if __name__ == "__main__":
    p = argparse.ArgumentParser()
    p.add_argument("--debug", action="store_true", help="show a preview window")
    main(p.parse_args().debug)