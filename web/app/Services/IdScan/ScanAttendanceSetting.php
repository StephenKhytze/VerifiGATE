<?php

namespace App\Services\IdScan;

use App\Enums\Gate\AttendanceStatus;
use Illuminate\Support\Facades\Cache;

/**
 * TEMPORARY: the guard's on-time/late switch, until class schedules can decide lateness.
 * Every scan station and guard screen shares it, so it lives in the cache.
 */
final class ScanAttendanceSetting
{
    private const KEY = 'gate.attendance_status';

    /** The switch exists outside production only; production always stamps on time. */
    public function enabled(): bool
    {
        return ! app()->isProduction();
    }

    public function current(): AttendanceStatus
    {
        if (! $this->enabled()) {
            return AttendanceStatus::OnTime;
        }

        return AttendanceStatus::tryFrom((string) Cache::get(self::KEY)) ?? AttendanceStatus::OnTime;
    }

    public function set(AttendanceStatus $status): void
    {
        Cache::forever(self::KEY, $status->value);
    }
}
