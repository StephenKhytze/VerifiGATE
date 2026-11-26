# Integration Fixes and System Alignment (`change.md`)

This document records the modifications made to bridge and integrate the branches of **Nick** (`origin/nick`) and **Kitz** (`origin/kitz`) into `teten-integrated`, ensuring all services communicate reliably and work as intended during live testing.

---

## 1. Summary of Issues Resolved

| Area | Problem | Resolution |
| :--- | :--- | :--- |
| **Status Mapping** | `uniform_checker_module.py` returned `approved`, `denied`, and `low-confidence`, while Laravel's `PythonUniformProvider.php` expected `compliant`, `non_compliant`, and `low_confidence`. Scans were defaulting to `unavailable`. | Standardized Python output to `compliant`, `non_compliant`, `low_confidence`. Added multi-format matching in Laravel to accept both conventions. |
| **Attire Condition Casing** | `db_utils.py` returned `Standard_male` / `Standard_female` (lowercase from DB), causing `KeyError: 'Standard_male'` in `uniform_checker_module.py` (which defines `Standard_MALE` / `Standard_FEMALE`). | Standardized `db_utils.py` to `.upper()` student sex, and added case-insensitive dictionary fallback in `uniform_checker_module.py`. |
| **Hardcoded Student ID** | `uniform_checker_module.py` had a hardcoded student number (`H24-9001`) and did not accept dynamic parameters from Laravel. | Extended `/id_scanned` to accept `student_number` and `sex` query params. Updated `UniformProvider` interface and `PythonUniformProvider` to pass student details dynamically. |
| **Redundant Evaluation** | `ScanProcessor.php` evaluated the uniform status twice per scan (once in `evaluate()` and again in `finish()`). | Removed duplicate evaluation in `finish()`, routing the result directly from `evaluate($id)` with `$student` details attached. |
| **Service Crash on Startup** | `capture.py` and `id-ocr/app/main.py` directly indexed environment variables without `.env` loading, crashing immediately if tokens weren't exported in the active shell. | Added `.env` loading and aligned default fallback tokens matching `web/.env.example`. |
| **Stub Mode Compatibility** | Setting `UNIFORM_MODE=stub_compliant` in `web/.env` was ignored because `AppServiceProvider` strictly bound `PythonUniformProvider`. | Added immediate stub handling in `PythonUniformProvider` so developers can mock compliant checks without starting Python services. |

---

## 2. File-by-File Changes

### `web/app/Services/IdScan/PythonUniformProvider.php`
* Updated method signature to accept `?Student $student = null` to satisfy `UniformProvider`.
* Added dynamic query parameter forwarding: `token`, `student_number`, and `sex`.
* Added support for `UNIFORM_MODE=stub_compliant` from config.
* Normalized status strings (`strtolower(str_replace('-', '_', ...))`) and mapped:
  * `"compliant"`, `"approved"` &rarr; `UniformStatus::Compliant`
  * `"non_compliant"`, `"non-compliant"`, `"denied"` &rarr; `UniformStatus::NonCompliant`
  * `"low_confidence"` &rarr; `UniformStatus::LowConfidence`
  * Default fallback &rarr; `UniformStatus::Unavailable`
* Removed unused import `use function Pest\Laravel\json;`.

### `web/app/Services/IdScan/UniformProvider.php`
* Updated interface: `public function current(?Student $student = null): UniformResult;`.

### `web/app/Services/IdScan/ConfigUniformProvider.php`
* Updated signature to `current(?Student $student = null): UniformResult` to match the interface contract.

### `web/app/Services/IdScan/ScanProcessor.php`
* In `evaluate(Identity $id)`: extracted `$student = ($isStudent && $id->model instanceof Student) ? $id->model : null;` and passed to `$this->uniform->current($student)`.
* In `finish(...)`: eliminated duplicate calls to `$this->uniform->current()` and `$this->router->route(...)`.

### `python/services/unif-scanning/uniform_checker_module.py`
* Added `from typing import Optional`.
* Updated `GATE_TOKEN` lookup to support `GATE_TOKEN`, `VITE_GATE_TOKEN`, and default fallback token from `.env.example`.
* Updated `/id_scanned` endpoint:
  * Added query parameters: `token: Optional[str]`, `student_number: Optional[str]`, `sex: Optional[str]`.
  * Added token verification against `GATE_TOKEN`.
  * Added fallback to `freeze_frame` if `clip_frame` is None.
  * Dynamically queried `get_student_attire_condition(student_number)` with fallback to `sex` standard (`Standard_MALE` / `Standard_FEMALE`).
  * Added case-insensitive prompt lookup to prevent any `KeyError`.
  * Updated status outputs to `compliant`, `non_compliant`, `low_confidence`.

### `python/services/unif-scanning/db_utils.py`
* Changed line 44 to: `sex = str(student.get("sex") or "male").upper(); return f"Standard_{sex}"` to guarantee key alignment.

### `python/services/id-capture/capture.py`
* Added `load_dotenv()` import and fallback for `STATION_TOKEN` (`35a3ac2aa19d749dba6489e3a22ec9e7a6a012a0f1ef4c6913b7d7646fa2dbf0`).

### `python/services/id-ocr/app/main.py`
* Added `load_dotenv()` import and fallback for `OCR_TOKEN` (`a9e7aa90f9de0a3d04c7e5b46d5923a7fe5ed65813fa131d05a2a40d64511845`).

---

## 3. Reliability & Hardware Conflict Fixes

| Area | Problem | Resolution |
| :--- | :--- | :--- |
| **OCR Timeout** | PaddleOCR on CPU takes 4–8s, exceeding Laravel's previous 3s default (`OCR_TIMEOUT=3`), triggering timeouts and unreadable/retry scans. | Increased default `OCR_TIMEOUT` to 15s in `config/verifigate.php` and `web/.env.example`. |
| **OCR Processing Speed** | `id-ocr` tested 3 rotations (0°, 90°, 270°) by default, taking 3x longer. | Defaulted `OCR_TRY_ROTATIONS` to `0` in `main.py`, cutting OCR execution time down to ~1.5–2s per scan. |
| **Single-Webcam Collision** | On Windows, both `capture.py` and `uniform_checker_module.py` attempted to lock Camera `0`. The second process failed silently, leaving `/gate/screen` black. | Added automatic fallback to Camera `1` in `uniform_checker_module.py`. If no camera is available, it streams an on-screen visual placeholder guiding the user. |
| **ID Capture Preview** | `capture.py` ran headlessly unless `--debug` was explicitly passed. | Enabled preview window by default (`--no-preview` now available for headless mode). Added clear camera-busy diagnostics. |
| **MySQL Credentials** | `db_utils.py` hardcoded `user="root"` and `password=""`, failing on machines where MySQL has a password. | Updated `db_utils.py` to dynamically load credentials (`DB_HOST`, `DB_PORT`, `DB_USERNAME`, `DB_PASSWORD`, `DB_DATABASE`) from environment and `web/.env`. |
| **Database Seed Alignment** | `GateDemoSeeder.php` was missing test ID `H24-9001` and did not populate the `sex` column. | Added `H24-9001` and explicit `sex` (`male`/`female`) attributes for all seeded students. |

