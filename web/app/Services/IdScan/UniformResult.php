<?php

namespace App\Services\IdScan;

use App\Enums\Gate\UniformStatus;

final class UniformResult
{
    public function __construct(
        public UniformStatus $status,
        public ?float $confidence = null,      // 0-100
        public ?string $detectedLabel = null,  // e.g. "P.E. Uniform"; contract to agree with the uniform teammate
    ) {
    }
}
