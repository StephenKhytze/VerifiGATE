<?php

use App\Http\Controllers\Station\StationScanController;
use App\Http\Controllers\Station\StationSignalController;
use Illuminate\Support\Facades\Route;

// Mounted under /api/station (see bootstrap/app.php)
Route::post('scans', StationScanController::class)->middleware('station');
Route::post('signal', StationSignalController::class)->middleware('station');
