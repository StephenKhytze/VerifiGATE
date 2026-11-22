<?php

namespace App\Services\Reports;

use App\Enums\Reports\Period;

/** Stand-in numbers: stable for the same student and period, so a page reload does not change them. */
final class MockAbsenceProvider implements AbsenceProvider
{
    public function forStudents(array $studentIds, ReportPeriod $period): array
    {
        $max = match ($period->period) {
            Period::Daily => 1,
            Period::Weekly => 2,
            Period::Monthly => 4,
        };

        $absent = [];
        foreach ($studentIds as $id) {
            $seed = crc32($id . '|' . $period->period->value . '|' . $period->start->toDateString());
            $absent[$id] = $seed % 10 < 2 ? 1 + (($seed >> 4) % $max) : 0;
        }

        return $absent;
    }
}
