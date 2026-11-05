<?php

namespace App\Services\IdScan;

use App\Enums\Gate\UniformStatus;

final class ConfigUniformProvider implements UniformProvider
{
    public function current(): UniformResult
    {
        return match (config('verifigate.uniform_mode')) {
            'stub_compliant' => new UniformResult(UniformStatus::Compliant, 99.0),
            default => new UniformResult(UniformStatus::Unavailable),
        };
    }
}
