<?php

namespace App\Services\Reports;

interface AbsenceProvider
{
    /**
     * @param list<int> $studentIds
     * @return array<int, int> absent days per student id
     */
    public function forStudents(array $studentIds, ReportPeriod $period): array;
}
