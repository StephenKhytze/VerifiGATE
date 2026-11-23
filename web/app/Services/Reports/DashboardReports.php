<?php

namespace App\Services\Reports;

use App\Enums\Reports\AttendanceMode;
use App\Models\Student;
use App\Support\SchoolClock;
use Illuminate\Database\Eloquent\Builder;

/** Builds the page data for both dashboards and for the print report. */
final class DashboardReports
{
    private const PREVIEW_ROWS = 3;
    private const VIOLATOR_ROWS = 10;
    private const ORGANIZATION = 'Laguna College';

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

    /**
     * The print report. It leaves out mock data (Absent) and the hard-coded panels.
     *
     * @param array{name: string, title: string} $viewer
     */
    public function printable(string $role, ReportPeriod $period, AttendanceMode $mode, array $viewer): array
    {
        $admin = $role === 'admin';
        $students = $admin ? $this->adminScope->students() : $this->facultyScope->students();
        $totals = $this->attendance->totals($students, $period, $mode);
        $incidents = $this->incidents->series($students, $period);
        $mock = config('verifigate.reports.mock.faculty');

        $report = [
            'organization' => self::ORGANIZATION,
            'title' => $admin ? 'Admin Dashboard Report' : 'Faculty Dashboard Report',
            'role' => $role,
            'scope' => $admin ? 'All students' : "{$mock['program']} Year {$mock['year']} students",
            'period' => $period->toArray(),
            'generated_at' => SchoolClock::now()->format('F j, Y g:ia'),
            'prepared_by' => ['name' => $viewer['name'], 'title' => $viewer['title']],
            'mode_note' => $mode === AttendanceMode::Late ? 'Test mode: every entry is counted as Late.' : null,
            'cards' => ['present' => $totals['present'], 'late' => $totals['late']],
            'chart' => ['legend' => 'Incidents', 'series' => $incidents['series'], 'total' => $incidents['total']],
            'violators' => $this->violators($students, $period, $mode),
        ];

        if ($admin) {
            $report['occupancy'] = $this->occupancy();
            $report['extras'] = [
                'violations' => $incidents['total'],
                'visitors' => $this->campus->visitors($period),
                'reg_card_scans' => $this->campus->registrationCardScans($period),
            ];
        }

        return $report;
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

    /**
     * The students with the most incident days, most first, ties alphabetical.
     *
     * @return array{rows: list<array<string, mixed>>, with_violations: int, limit: int}
     */
    private function violators(Builder $students, ReportPeriod $period, AttendanceMode $mode): array
    {
        $days = $this->incidents->perStudent($students, $period);

        $people = Student::query()->whereIn('id', array_keys($days))->get()->all();
        usort($people, fn (Student $a, Student $b) => [$days[$b->id], $a->last_name, $a->first_name]
            <=> [$days[$a->id], $b->last_name, $b->first_name]);

        $top = array_slice($people, 0, self::VIOLATOR_ROWS);
        $rows = $this->attendance->rowsFor(array_map(fn (Student $student) => $student->id, $top), $period, $mode);

        return [
            'rows' => array_map(fn (array $row) => $row + ['violations' => $days[$row['id']]], $rows),
            'with_violations' => count($days),
            'limit' => self::VIOLATOR_ROWS,
        ];
    }
}
