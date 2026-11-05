import argparse
import hmac
import os
import re
import sys
import threading
import time
from collections import deque
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

# All of these are starting values: calibrate on your camera and mounting.
STEADY_FRAMES = 5
MOVE_TOL = 0.02
MIN_AREA, MAX_AREA = 0.05, 0.80
ASPECT = (1.35, 1.80)
MIN_SHARPNESS = float(os.environ.get("MIN_SHARPNESS", "60"))
SOFT_SEND_AFTER = 3.0
CLEAR_SECONDS = 1.5
RETRY_TIMEOUT = 4.0
MAX_CROP_SIDE = 1400
JPEG_QUALITY = 85
CROP_TTL = 600               # seconds a crop stays in memory (matches the guard's pending window)
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


# ---- card detection ----
def order_points(pts):
    s = pts.sum(axis=1)
    d = np.diff(pts, axis=1).ravel()
    return np.array([pts[s.argmin()], pts[d.argmin()], pts[s.argmax()], pts[d.argmax()]], np.float32)


def aspect_of(quad):
    tl, tr, br, bl = quad
    a = (np.linalg.norm(tr - tl) + np.linalg.norm(br - bl)) / 2
    b = (np.linalg.norm(bl - tl) + np.linalg.norm(br - tr)) / 2
    return max(a, b) / max(min(a, b), 1e-6)


def find_card(frame):
    h, w = frame.shape[:2]
    scale = 640 / max(h, w)
    small = cv2.resize(frame, None, fx=scale, fy=scale, interpolation=cv2.INTER_AREA)
    gray = cv2.GaussianBlur(cv2.cvtColor(small, cv2.COLOR_BGR2GRAY), (5, 5), 0)
    edges = cv2.dilate(cv2.Canny(gray, 50, 150), None, iterations=1)
    contours, _ = cv2.findContours(edges, cv2.RETR_LIST, cv2.CHAIN_APPROX_SIMPLE)
    total = small.shape[0] * small.shape[1]

    for c in sorted(contours, key=cv2.contourArea, reverse=True)[:8]:
        area = cv2.contourArea(c) / total
        if area < MIN_AREA:
            break
        if area > MAX_AREA:
            continue
        approx = cv2.approxPolyDP(c, 0.02 * cv2.arcLength(c, True), True)
        if len(approx) != 4 or not cv2.isContourConvex(approx):
            continue
        quad = order_points(approx.reshape(4, 2).astype(np.float32) / scale)
        if ASPECT[0] <= aspect_of(quad) <= ASPECT[1]:
            return quad
    return None


def warp(frame, quad):
    tl, tr, br, bl = quad
    w = int(max(np.linalg.norm(tr - tl), np.linalg.norm(br - bl)))
    h = int(max(np.linalg.norm(bl - tl), np.linalg.norm(br - tr)))
    dst = np.array([[0, 0], [w - 1, 0], [w - 1, h - 1], [0, h - 1]], np.float32)
    crop = cv2.warpPerspective(frame, cv2.getPerspectiveTransform(quad, dst), (w, h))
    s = MAX_CROP_SIDE / max(crop.shape[:2])
    if s < 1:
        crop = cv2.resize(crop, None, fx=s, fy=s, interpolation=cv2.INTER_AREA)
    return crop


def sharpness(img):
    return float(cv2.Laplacian(cv2.cvtColor(img, cv2.COLOR_BGR2GRAY), cv2.CV_64F).var())


def is_steady(history, diag):
    if len(history) < STEADY_FRAMES:
        return False
    return float(np.ptp(np.array(history), axis=0).max()) < MOVE_TOL * diag


# ---- talking to Laravel ----
def fire_signal(state):
    """Tell Laravel a card is steady / the frame is clear. Runs in a thread so it never stalls capture."""
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
        print(f"[{time.strftime('%H:%M:%S')}] attempt {attempt} -> {body.get('result')}")
        return body.get("result")
    except requests.RequestException as e:
        print(f"[{time.strftime('%H:%M:%S')}] send failed: {e.__class__.__name__}")
        return None


def main(debug):
    cap = cv2.VideoCapture(CAM, cv2.CAP_DSHOW)   # DirectShow backend (Windows)
    cap.set(cv2.CAP_PROP_FOURCC, cv2.VideoWriter_fourcc(*"MJPG"))
    cap.set(cv2.CAP_PROP_FRAME_WIDTH, CAM_W)
    cap.set(cv2.CAP_PROP_FRAME_HEIGHT, CAM_H)
    if not cap.isOpened():
        sys.exit("Camera not available. Check CAMERA_INDEX.")

    start_crop_server()

    history = deque(maxlen=STEADY_FRAMES)
    state, attempt = "armed", 1
    last_crop, first_try_at = None, 0.0
    last_seen, steady_since = 0.0, None
    signaled = False

    while True:
        ok, frame = cap.read()
        if not ok:
            time.sleep(0.1)
            continue
        now = time.monotonic()
        diag = float(np.hypot(*frame.shape[:2]))

        quad = find_card(frame)
        if quad is not None:
            last_seen = now
            history.append(quad.mean(axis=0))
        else:
            history.clear()
            steady_since = None

        if state == "wait_clear":
            if quad is None and now - last_seen >= CLEAR_SECONDS:
                state, attempt, last_crop, steady_since = "armed", 1, None, None
                if signaled:
                    fire_signal("clear")
                    signaled = False
        else:
            if quad is None and signaled and attempt == 1 and now - last_seen >= CLEAR_SECONDS:
                fire_signal("clear")                  # card left before a scan was sent
                signaled = False

            if attempt == 2 and last_crop is not None and now - first_try_at > RETRY_TIMEOUT:
                submit(last_crop, 2)                  # last chance with the previous frame
                state = "wait_clear"
            elif quad is not None and is_steady(history, diag):
                if not signaled:
                    fire_signal("card")
                    signaled = True
                steady_since = steady_since or now
                crop = warp(frame, quad)
                soft = (now - steady_since) > SOFT_SEND_AFTER
                if sharpness(crop) >= MIN_SHARPNESS or soft:
                    last_crop = crop
                    result = submit(crop, attempt)
                    if result == "retry":
                        attempt, first_try_at = 2, now
                        history.clear()
                        steady_since = None
                    else:
                        state = "wait_clear"

        if debug:
            view = frame.copy()
            if quad is not None:
                cv2.polylines(view, [quad.astype(np.int32)], True, (0, 255, 0), 3)
            cv2.putText(view, f"{state} attempt={attempt}", (20, 40),
                        cv2.FONT_HERSHEY_SIMPLEX, 1, (0, 255, 255), 2)
            cv2.imshow("capture (q to quit)", cv2.resize(view, None, fx=0.5, fy=0.5))
            if cv2.waitKey(1) & 0xFF == ord("q"):
                break

    cap.release()
    cv2.destroyAllWindows()


if __name__ == "__main__":
    p = argparse.ArgumentParser()
    p.add_argument("--debug", action="store_true", help="show a preview window")
    main(p.parse_args().debug)