<?php

namespace App\Services\Reports;

use App\Enums\Reports\AttendanceMode;
use App\Support\SchoolClock;
use Illuminate\Database\Eloquent\Builder;

/** Builds the page data for both dashboards. */
final class DashboardReports
{
    private const PREVIEW_ROWS = 3;

    public function __construct(
        private AttendanceReport $attendance,
        private IncidentReport $incidents,
        private CampusReport $campus,
        private PlaceholderPanels $placeholders,
        private FacultyStudentScope $facultyScope,
        private AdminStudentScope $adminScope,
    ) {
    }

    public function faculty(ReportPeriod $period, AttendanceMode $mode): array
    {
        return $this->shared($this->facultyScope->students(), $period, $mode);
    }

    public function admin(ReportPeriod $period, AttendanceMode $mode): array
    {
        $data = $this->shared($this->adminScope->students(), $period, $mode);

        return $data + [
            'occupancy' => $this->occupancy(),
            'extras' => [
                'violations' => $data['chart']['total'],
                'visitors' => $this->campus->visitors($period),
                'reg_card_scans' => $this->campus->registrationCardScans($period),
            ],
            'event' => $this->placeholders->eventStatus(),
            'exceptions' => [
                'date' => SchoolClock::now()->format('F j, Y'),
                'rows' => $this->placeholders->uniformExceptions(),
            ],
        ];
    }

    /** Refreshed on its own by the page, so it has its own method. */
    public function occupancy(): array
    {
        return $this->campus->currentlyInside();
    }

    private function shared(Builder $students, ReportPeriod $period, AttendanceMode $mode): array
    {
        $incidents = $this->incidents->series($students, $period);

        return [
            'period' => $period->toArray(),
            'mode' => $mode->value,
            'cards' => $this->attendance->totals($students, $period, $mode),
            'absent_is_mock' => true,
            'chart' => ['legend' => 'Incidents', 'series' => $incidents['series'], 'total' => $incidents['total']],
            'records' => $this->attendance->records($students, $period, $mode, self::PREVIEW_ROWS),
        ];
    }
}
