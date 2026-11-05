<?php

namespace App\Services\IdScan;

final class IdTextParser
{
    /** Common OCR confusions, applied only to the digit positions. */
    private const FIX = ['O' => '0', 'I' => '1', 'L' => '1', 'S' => '5', 'B' => '8'];

    /**
     * Look for ID numbers in the OCR lines.
     *
     * @param array<int, array{text: string, confidence: float}> $lines
     * @return array{student: ?array{value: string, conf: float}, faculty: ?array, employee: ?array}
     */
    public function numbers(array $lines): array
    {
        $found = ['student' => null, 'faculty' => null, 'employee' => null];

        foreach ($lines as $l) {
            $t = strtoupper(str_replace(['–', '—'], '-', $l['text']));

            // Student: letter + 2 digits + dash + 4 digits (H24-0137, C24-xxxx)
            if (preg_match('/\b([A-Z])\s?([0-9OILSB]{2})\s?-\s?([0-9OILSB]{4})\b/', $t, $m)) {
                $found['student'] = $this->best(
                    $found['student'],
                    $m[1] . strtr($m[2], self::FIX) . '-' . strtr($m[3], self::FIX),
                    $l['confidence']
                );
            }
            // Faculty / employee: PLACEHOLDER formats until real samples exist
            if (preg_match('/\bFAC\s?-\s?([0-9OILSB]{4})\b/', $t, $m)) {
                $found['faculty'] = $this->best($found['faculty'], 'FAC-' . strtr($m[1], self::FIX), $l['confidence']);
            }
            if (preg_match('/\bEMP\s?-\s?([0-9OILSB]{4})\b/', $t, $m)) {
                $found['employee'] = $this->best($found['employee'], 'EMP-' . strtr($m[1], self::FIX), $l['confidence']);
            }
        }

        return $found;
    }

    /**
     * Philippine National ID: each value sits on the line right below its label.
     *
     * @return ?array{last: array, given: array, middle?: array}  each ['value' => string, 'conf' => float]
     */
    public function nationalId(array $lines): ?array
    {
        usort($lines, fn ($a, $b) => $a['box'][0][1] <=> $b['box'][0][1]);   // top to bottom

        $labels = ['last' => 'LAST NAME', 'given' => 'GIVEN NAMES', 'middle' => 'MIDDLE NAME'];
        $out = [];

        foreach ($lines as $i => $l) {
            $t = Names::norm($l['text']);
            foreach ($labels as $key => $label) {
                if (!isset($out[$key]) && str_contains($t, $label) && isset($lines[$i + 1])) {
                    $out[$key] = [
                        'value' => Names::norm($lines[$i + 1]['text']),
                        'conf' => (float) $lines[$i + 1]['confidence'],
                    ];
                }
            }
        }

        return isset($out['last'], $out['given']) ? $out : null;
    }

    private function best(?array $current, string $value, float $conf): array
    {
        return (!$current || $conf > $current['conf']) ? ['value' => $value, 'conf' => $conf] : $current;
    }
}
