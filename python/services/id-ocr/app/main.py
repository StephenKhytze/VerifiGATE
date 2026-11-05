import logging
import os
import re
import secrets
import threading
import time
from contextlib import asynccontextmanager

import cv2
import numpy as np
from fastapi import FastAPI, Header, HTTPException, Request
from fastapi.concurrency import run_in_threadpool
from paddleocr import PaddleOCR
from pydantic import BaseModel
from rapidfuzz import fuzz

logging.basicConfig(level=logging.INFO)
log = logging.getLogger("ocr")

TOKEN = os.environ.get("OCR_TOKEN")
if not TOKEN:
    raise RuntimeError("Set the OCR_TOKEN environment variable before starting")

MAX_BYTES = 5 * 1024 * 1024
MAX_SIDE = int(os.getenv("OCR_MAX_SIDE", "1280"))
TRY_ROTATIONS = os.getenv("OCR_TRY_ROTATIONS", "1") == "1"

engine = None
lock = threading.Lock()   # one OCR job at a time; thread-safety of the engine is unverified

# Hint rules. The faculty/employee/registration keywords are PLACEHOLDERS (no real samples yet).
RULES = {
    "national_id": ["PAMBANSANG PAGKAKAKILANLAN", "PHILIPPINE IDENTIFICATION CARD"],
    "lc_card": ["LAGUNA COLLEGE"],
    "faculty_placeholder": ["FACULTY"],
    "employee_placeholder": ["EMPLOYEE"],
    "registration_placeholder": ["REGISTRATION"],
}
HINT_PRIORITY = ["national_id", "registration_placeholder", "faculty_placeholder",
                 "employee_placeholder", "lc_card"]

# Shape only (letter + 2 digits + dash + 4 digits), tolerant of common OCR confusions.
# ASSUMPTION: elementary numbers may share this shape; verify with a real elementary ID.
STUDENT_NO_SHAPE = re.compile(r"[A-Z][0-9OIL]{2}\s?[-–—]\s?[0-9OILSB]{4}")


class Line(BaseModel):
    text: str
    confidence: float
    box: list[list[int]]          # polygon, in the (possibly rotated) image frame


class Quality(BaseModel):
    width: int
    height: int
    sharpness: float              # Laplacian variance; higher = sharper
    glare_ratio: float            # share of near-white pixels


class OcrResponse(BaseModel):
    lines: list[Line]
    mean_confidence: float
    type_hint: str
    hint_signals: list[str]
    rotation: int                 # 0, 90 or 270: which rotation produced the lines
    quality: Quality
    ms: int


def decode(data: bytes) -> np.ndarray:
    img = cv2.imdecode(np.frombuffer(data, np.uint8), cv2.IMREAD_COLOR)
    if img is None:
        raise HTTPException(415, "unreadable image")
    scale = MAX_SIDE / max(img.shape[:2])
    if scale < 1:
        img = cv2.resize(img, None, fx=scale, fy=scale, interpolation=cv2.INTER_AREA)
    return img


def quality(img: np.ndarray) -> Quality:
    gray = cv2.cvtColor(img, cv2.COLOR_BGR2GRAY)
    return Quality(
        width=img.shape[1],
        height=img.shape[0],
        sharpness=float(cv2.Laplacian(gray, cv2.CV_64F).var()),
        glare_ratio=float((gray >= 250).mean()),
    )


def read(img: np.ndarray) -> list[Line]:
    out = engine.predict(img)                 # PaddleOCR 3.x API
    if not out:
        return []
    r = out[0]
    return [
        Line(text=t, confidence=float(s), box=np.asarray(p).astype(int).tolist())
        for t, s, p in zip(r["rec_texts"], r["rec_scores"], r["rec_polys"])
        if t.strip()
    ]


def best_read(img: np.ndarray):
    def score(lines):
        return sum(l.confidence for l in lines)

    best = (0, read(img))
    if TRY_ROTATIONS and len(best[1]) < 3:
        for deg, code in ((90, cv2.ROTATE_90_CLOCKWISE), (270, cv2.ROTATE_90_COUNTERCLOCKWISE)):
            lines = read(cv2.rotate(img, code))
            if score(lines) > score(best[1]):
                best = (deg, lines)
    return best


def hint(lines: list[Line]):
    blob = " ".join(l.text.upper() for l in lines)
    signals = [
        name for name, keys in RULES.items()
        if any(fuzz.partial_ratio(k, blob) >= 85 for k in keys)
    ]
    if STUDENT_NO_SHAPE.search(blob):
        signals.append("student_no_shape")
    for name in HINT_PRIORITY:
        if name in signals:
            return name, signals
    if "student_no_shape" in signals:
        return "lc_card", signals
    return "unknown", signals


@asynccontextmanager
async def lifespan(app: FastAPI):
    global engine
    opts = dict(
        lang="en",
        use_doc_orientation_classify=False,
        use_doc_unwarping=False,
        use_textline_orientation=os.getenv("OCR_TEXTLINE_ORIENT", "0") == "1",
        enable_mkldnn=os.getenv("OCR_ENABLE_MKLDNN", "0") == "1",
        text_det_limit_type="max",
        text_det_limit_side_len=int(os.getenv("OCR_DET_SIDE", "960")),
        cpu_threads=int(os.getenv("OCR_CPU_THREADS", "4")),
    )
    if os.getenv("OCR_DET_MODEL"):
        opts["text_detection_model_name"] = os.environ["OCR_DET_MODEL"]
    if os.getenv("OCR_REC_MODEL"):
        opts["text_recognition_model_name"] = os.environ["OCR_REC_MODEL"]
    engine = PaddleOCR(**opts)
    engine.predict(np.full((200, 320, 3), 255, np.uint8))   # warm-up
    yield


app = FastAPI(lifespan=lifespan, docs_url=None, redoc_url=None, openapi_url=None)


def auth(token: str | None):
    if not token or not secrets.compare_digest(token, TOKEN):
        raise HTTPException(401, "unauthorized")


@app.get("/health")
def health(x_ocr_token: str | None = Header(None)):
    auth(x_ocr_token)
    return {"ok": engine is not None}


@app.post("/ocr", response_model=OcrResponse)
async def ocr(request: Request, x_ocr_token: str | None = Header(None)):
    auth(x_ocr_token)
    t0 = time.perf_counter()

    data = await request.body()          # raw JPEG bytes, kept in memory
    if not data:
        raise HTTPException(422, "empty body")
    if len(data) > MAX_BYTES:
        raise HTTPException(413, "image too large")

    img = decode(data)
    q = quality(img)

    def work():
        with lock:
            return best_read(img)

    rotation, lines = await run_in_threadpool(work)
    type_hint, signals = hint(lines)
    ms = int((time.perf_counter() - t0) * 1000)

    log.info("ocr lines=%d hint=%s rot=%d ms=%d", len(lines), type_hint, rotation, ms)  # never log text
    return OcrResponse(
        lines=lines,
        mean_confidence=sum(l.confidence for l in lines) / len(lines) if lines else 0.0,
        type_hint=type_hint,
        hint_signals=signals,
        rotation=rotation,
        quality=q,
        ms=ms,
    )