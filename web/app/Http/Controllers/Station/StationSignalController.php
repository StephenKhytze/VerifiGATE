<?php

namespace App\Http\Controllers\Station;

use App\Http\Controllers\Controller;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Cache;

class StationSignalController extends Controller
{
    /** The worker says "a card is steady" or "the frame is clear". No personal data. */
    public function __invoke(Request $request): JsonResponse
    {
        $state = $request->validate(['state' => ['required', 'in:card,clear']])['state'];
        Cache::put('gate.signal', ['state' => $state, 'at' => now()->timestamp], 30);

        return response()->json(['ok' => true]);
    }
}
