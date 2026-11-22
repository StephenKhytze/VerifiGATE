<?php

namespace App\Support;

use Carbon\CarbonInterface;
use Illuminate\Support\Facades\Date;

/** School days are Manila days. Stored times follow app.timezone, so convert before querying. */
final class SchoolClock
{
    public static function zone(): string
    {
        return config('verifigate.reports.timezone', 'Asia/Manila');
    }

    public static function now(): CarbonInterface
    {
        return now(self::zone());
    }

    /** The same instant in school time. */
    public static function local(CarbonInterface $time): CarbonInterface
    {
        return $time->copy()->setTimezone(self::zone());
    }

    /** The same instant in the timezone the database columns use, for query bindings. */
    public static function forQuery(CarbonInterface $time): CarbonInterface
    {
        return $time->copy()->setTimezone(config('app.timezone'));
    }

    public static function startOfDay(?CarbonInterface $at = null): CarbonInterface
    {
        return self::local($at ?? self::now())->startOfDay();
    }

    /** A raw datetime string read straight from the database, in school time. */
    public static function fromDatabase(string $value): CarbonInterface
    {
        return self::local(Date::parse($value, config('app.timezone')));
    }
}
