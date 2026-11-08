## ID Scanning Module: routes and pages

### Ports and processes (development)

| Process | Address | How to start |
|---|---|---|
| Laravel | http://127.0.0.1:8000 | `php artisan serve` (or `composer run dev`) |
| Vite (frontend) | started by `composer run dev` | `composer run dev` |
| OCR service (FastAPI, Python 3.12) | http://127.0.0.1:8001 | `uvicorn app.main:app --host 127.0.0.1 --port 8001 --workers 1` in `python/services/id-ocr` |
| Capture worker (Python) | none (crop server on 127.0.0.1:8003) | `python capture.py --debug` in `python/services/id-capture` |

All services run on the same PC and listen on `127.0.0.1` only.

### Pages (browser, login required)

| URL | File | Who uses it |
|---|---|---|
| `/gate/guard` | `web/resources/js/pages/gate/guard.tsx` | Guard monitor (landscape) |
| `/gate/screen` | `web/resources/js/pages/gate/screen.tsx` | Student-facing monitor (vertical) |

Shared components: `web/resources/js/components/gate/` (`log-card`, `history-modal`, `search-panel`).
Helpers: `web/resources/js/lib/gate-api.ts` (types and `api()`), `web/resources/js/hooks/use-poll.ts`.

### Guard endpoints (JSON, session login, prefix `/gate`)

Defined in `web/routes/gate_guard.php`.

| Method | URL | Purpose | Controller |
|---|---|---|---|
| GET | `/gate/state` | Guard screen data, polled every 500 ms | `GateStateController@guard` |
| GET | `/gate/screen-state` | Student screen data, polled every 500 ms (never includes flag reasons) | `GateStateController@screen` |
| GET | `/gate/events/{event}/id-image` | Scanned ID image, streamed from the worker's memory | `IdImageController` |
| GET | `/gate/events/{event}/history` | Today's entry/exit rows for the person on an event | `GateStateController@history` |
| GET | `/gate/people/search?q=` | Search students and staff by name or ID number | `GuardActionsController@search` |
| POST | `/gate/events/manual` | Start a manual entry (lost ID) | `GuardActionsController@manual` |
| POST | `/gate/events/{event}/identify` | Attach a person to an unidentified or wrong scan | `GuardActionsController@identify` |
| POST | `/gate/events/{event}/decision` | Guard approves or denies (`approve` / `deny`) | `GuardDecisionController` |

TODO: restrict these routes to guard accounts once the accounts module defines roles.

### Station endpoints (capture worker to Laravel, prefix `/api/station`)

Defined in `web/routes/gate_station.php`. They are protected by the `X-Station-Token` header, not by login.

| Method | URL | Purpose |
|---|---|---|
| POST | `/api/station/scans?attempt=1` or `2` | Send a cropped ID image (raw `image/jpeg` body, max 1 MB). Returns `approved`, `pending`, `retry`, or `duplicate` |
| POST | `/api/station/signal` | `{"state": "card" \| "clear"}`: tells the student screen a card is in view |

### OCR service endpoints (FastAPI, `X-OCR-Token` header)

| Method | URL | Purpose |
|---|---|---|
| GET | `http://127.0.0.1:8001/health` | Is the service up? |
| POST | `http://127.0.0.1:8001/ocr` | Raw JPEG body, returns text lines, confidences, type hint and quality metrics |

Only Laravel calls this service. Images are processed in memory and discarded.

### Capture worker crop server (`X-Station-Token` header)

| Method | URL | Purpose |
|---|---|---|
| GET | `http://127.0.0.1:8003/crops/{event_id}` | ID crop held in memory for up to 10 minutes. Only Laravel calls it |

### How a scan flows

```
Camera -> capture worker --POST /api/station/scans--> Laravel --POST /ocr--> OCR service
                                                         |
                       match database, apply routing, write gate_events
                                                         |
   guard screen <-- GET /gate/state --  Laravel  -- GET /gate/screen-state --> student screen
```

### Environment variables

| Where | Name | Meaning |
|---|---|---|
| Laravel `.env` | `OCR_URL`, `OCR_TOKEN`, `OCR_TIMEOUT` | OCR service address, shared token, timeout in seconds |
| Laravel `.env` | `STATION_TOKEN` | Shared token for the capture worker |
| Laravel `.env` | `CROP_URL` | Capture worker's crop server |
| Laravel `.env` | `UNIFORM_MODE` | `unavailable` or `stub_compliant` until the uniform module exists |
| OCR service shell | `OCR_TOKEN`, `OCR_DET_MODEL`, `OCR_REC_MODEL`, `OCR_CPU_THREADS` | Token, Paddle model names, thread count |
| Capture worker shell | `STATION_TOKEN`, `LARAVEL_URL`, `CAMERA_INDEX`, `MIN_SHARPNESS` | Token, Laravel address, camera number, blur threshold |

Never commit real token values. Use `.env.example` with placeholders.

### Not built yet

Exit scanning, registration-card parsing, the uniform checker connection, the live camera view, SMS "Important" cards, and the guard role check.
