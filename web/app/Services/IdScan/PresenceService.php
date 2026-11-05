<?php

namespace App\Services\IdScan;

use App\Enums\Gate\GateStatus;
use App\Enums\Gate\PersonType;
use App\Models\GateEvent;

/** "Inside" = an approved entry today with no paired exit. */
final class PresenceService
{
    public function isInside(PersonType $type, ?int $id): bool
    {
        $column = GateEvent::personColumn($type);
        if (!$column || !$id) {
            return false;
        }

        return GateEvent::where($column, $id)
            ->where('direction', 'in')
            ->whereIn('status', [GateStatus::Approved->value, GateStatus::ApprovedFlaggedUniform->value])
            ->whereBetween('scanned_at', [now()->startOfDay(), now()->endOfDay()])
            ->whereDoesntHave('exitEvent')
            ->exists();
    }
}
