<?php

namespace App\Services\Notifications;

final class PhoneMask
{
    /** 09000000001 becomes 09*****0001: first 2 and last 4 digits only. */
    public static function hint(string $number): string
    {
        $digits = preg_replace('/\D+/', '', $number) ?? '';
        $length = strlen($digits);

        if ($length < 7) {
            return str_repeat('*', max($length, 1));
        }

        return substr($digits, 0, 2) . str_repeat('*', $length - 6) . substr($digits, -4);
    }
}