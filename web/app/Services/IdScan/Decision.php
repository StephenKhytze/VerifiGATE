<?php

namespace App\Services\IdScan;

use App\Enums\Gate\FlagReason;
use App\Enums\Gate\GateStatus;

final class Decision
{
    /** @param list<FlagReason> $flags */
    public function __construct(
        public GateStatus $status,
        public array $flags,
        public ?int $exemptionId = null,
    ) {
    }
}
