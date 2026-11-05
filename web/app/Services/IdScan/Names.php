<?php

namespace App\Services\IdScan;

use Illuminate\Support\Str;

final class Names
{
    /** NUÑEZ -> NUNEZ, "C." -> "C", collapses spaces. */
    public static function norm(string $s): string
    {
        $s = Str::upper(Str::ascii($s));
        $s = preg_replace('/[^A-Z ]+/', ' ', $s);

        return trim(preg_replace('/\s+/', ' ', $s));
    }

    /** Similarity 0-100 between two names after normalization. */
    public static function ratio(string $a, string $b): float
    {
        $a = self::norm($a);
        $b = self::norm($b);
        $max = max(strlen($a), strlen($b));

        return $max === 0 ? 0.0 : round(100 * (1 - levenshtein($a, $b) / $max), 2);
    }
}
