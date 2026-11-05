<?php

use App\Http\Controllers\Station\GateStateController;
use App\Http\Controllers\Station\GuardActionsController;
use App\Http\Controllers\Station\GuardDecisionController;
use App\Http\Controllers\Station\IdImageController;
use Illuminate\Support\Facades\Route;
use Inertia\Inertia;

// Mounted under /gate with web + auth middleware.
// TODO: add the guard role check once the accounts module defines how roles work.
Route::get('guard', fn () => Inertia::render('gate/guard'))->name('gate.guard');
Route::get('screen', fn () => Inertia::render('gate/screen'))->name('gate.screen');

Route::get('state', [GateStateController::class, 'guard']);
Route::get('screen-state', [GateStateController::class, 'screen']);
Route::get('events/{event}/id-image', IdImageController::class);
Route::get('events/{event}/history', [GateStateController::class, 'history']);
Route::get('people/search', [GuardActionsController::class, 'search']);
Route::post('events/manual', [GuardActionsController::class, 'manual']);
Route::post('events/{event}/identify', [GuardActionsController::class, 'identify']);
Route::post('events/{event}/decision', GuardDecisionController::class)->name('gate.events.decision');
