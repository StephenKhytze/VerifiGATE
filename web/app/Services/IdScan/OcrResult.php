<?php

namespace App\Services\IdScan;

final class OcrResult
{
    /**
     * @param array<int, array{text: string, confidence: float, box: array}> $lines
     */
    public function __construct(
        public readonly array $lines,
        public readonly string $typeHint,
        public readonly float $meanConfidence,   // 0-1, as returned by the OCR service
    ) {
    }
}
