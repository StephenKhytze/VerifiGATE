<?php

use App\Http\Controllers\Reports\DashboardController;
use Illuminate\Support\Facades\Route;

// Mounted under /dashboard with web + auth middleware (see bootstrap/app.php).
// TODO: add the faculty/admin role checks once the accounts module defines how roles work.
Route::get('faculty', [DashboardController::class, 'faculty'])->name('reports.faculty');
