<?php

namespace App\Services\IdScan;

use Illuminate\Http\Client\ConnectionException;
use Illuminate\Http\Client\RequestException;
use Illuminate\Support\Facades\Http;

/** The only class that talks to the FastAPI OCR service. */
final class OcrClient
{
    public function read(string $jpeg): OcrResult
    {
        try {
            $json = Http::withHeaders(['X-OCR-Token' => (string) config('verifigate.ocr.token')])
                ->connectTimeout(1)
                ->timeout((float) config('verifigate.ocr.timeout'))
                ->withBody($jpeg, 'image/jpeg')
                ->post(config('verifigate.ocr.url') . '/ocr')
                ->throw()
                ->json();
        } catch (ConnectionException|RequestException $e) {
            report($e);   // the image/body is never logged
            throw new OcrUnavailable('OCR service unavailable', 0, $e);
        }

        return new OcrResult(
            $json['lines'] ?? [],
            (string) ($json['type_hint'] ?? 'unknown'),
            (float) ($json['mean_confidence'] ?? 0),
        );
    }
}
