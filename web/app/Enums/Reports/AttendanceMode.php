<?php

namespace App\Enums\Reports;

enum AttendanceMode: string
{
    case OnTime = 'on_time';
    case Late = 'late';

    public static function fromConfig(): self
    {
        return self::tryFrom((string) config('verifigate.reports.attendance_mode')) ?? self::OnTime;
    }

    /** Bad or missing input falls back to the configured mode. */
    public static function fromInput(?string $value): self
    {
        return self::tryFrom((string) $value) ?? self::fromConfig();
    }
}
