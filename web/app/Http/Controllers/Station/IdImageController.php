<?php

namespace App\Http\Controllers\Station;

use App\Http\Controllers\Controller;
use App\Models\GateEvent;
use Illuminate\Http\Client\ConnectionException;
use Illuminate\Support\Facades\Http;
use Symfony\Component\HttpFoundation\Response;

class IdImageController extends Controller
{
    /** Streams the crop from the worker's memory. Nothing is stored here. */
    public function __invoke(GateEvent $event): Response
    {
        try {
            $r = Http::withHeaders(['X-Station-Token' => (string) config('verifigate.station_token')])
                ->timeout(2)
                ->get(config('verifigate.crop_url') . "/crops/{$event->id}");
        } catch (ConnectionException) {
            abort(404);
        }
        abort_if($r->failed(), 404);

        return response($r->body(), 200, [
            'Content-Type' => 'image/jpeg',
            'Cache-Control' => 'no-store',
        ]);
    }
}
