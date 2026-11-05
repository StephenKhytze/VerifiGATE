<?php

namespace App\Http\Middleware;

use Closure;
use Illuminate\Http\Request;
use Symfony\Component\HttpFoundation\Response;

class EnsureStationToken
{
    public function handle(Request $request, Closure $next): Response
    {
        $expected = (string) config('verifigate.station_token');
        $given = (string) $request->header('X-Station-Token');

        abort_unless($expected !== '' && hash_equals($expected, $given), 401);

        return $next($request);
    }
}
