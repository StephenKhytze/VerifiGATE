<?php

namespace App\Http\Controllers\Station;

use App\Http\Controllers\Controller;
use App\Services\IdScan\ScanProcessor;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

class StationScanController extends Controller
{
    public function __invoke(Request $request, ScanProcessor $processor): JsonResponse
    {
        $jpeg = $request->getContent();   // raw body: PHP doesn't write it to a temp file
        abort_if($jpeg === '' || strlen($jpeg) > 1_000_000, 422, 'Missing or oversized image');

        $attempt = min(max((int) $request->query('attempt', 1), 1), 2);

        return response()->json($processor->process($jpeg, $attempt));
    }
}
