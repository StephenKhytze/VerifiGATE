<?php

namespace App\Http\Controllers\Station;

use App\Http\Controllers\Controller;
use App\Services\IdScan\GateState;
use App\Models\GateEvent;
use App\Services\IdScan\GatePresenter;
use Illuminate\Http\JsonResponse;

class GateStateController extends Controller
{
    public function guard(GateState $state): JsonResponse
    {
        return response()->json($state->guard())->header('Cache-Control', 'no-store');
    }

    public function screen(GateState $state): JsonResponse
    {
        return response()->json($state->screen())->header('Cache-Control', 'no-store');
    }

    public function history(GateEvent $event, GatePresenter $presenter): JsonResponse
    {
        $column = GateEvent::personColumn($event->person_type);
        $personId = $column ? $event->{$column} : null;

        $query = GateEvent::with('exitEvent')
            ->where('direction', 'in')
            ->whereBetween('scanned_at', [now()->startOfDay(), now()->endOfDay()]);
        $query = $personId ? $query->where($column, $personId) : $query->where('id', $event->id);

        $event->loadMissing(GatePresenter::with());

        return response()->json([
            'name' => $presenter->name($event),
            'identifier' => $presenter->identifier($event),
            'rows' => $query->oldest('scanned_at')->get()->map(fn ($e) => [
                'entered' => $e->scanned_at->format('g:i A'),
                'exited' => $e->exitEvent?->scanned_at->format('g:i A'),
                'status' => $e->status->value,
            ])->values()->all(),
        ])->header('Cache-Control', 'no-store');
    }
}
