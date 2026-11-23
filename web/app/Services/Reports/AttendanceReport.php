<?php

namespace App\Services\Reports;

use App\Enums\Gate\Direction;
use App\Enums\Gate\GateStatus;
use App\Enums\Gate\PersonType;
use App\Enums\Reports\AttendanceMode;
use App\Support\SchoolClock;
use App\Models\Student;
use Illuminate\Database\Eloquent\Builder;
use Illuminate\Support\Facades\DB;

final class AttendanceReport
{
    private const APPROVED = [GateStatus::Approved->value, GateStatus::ApprovedFlaggedUniform->value];

    public function __construct(private AbsenceProvider $absence)
    {
    }

    /** @return array{present: int, late: int, absent: int} */
    public function totals(Builder $students, ReportPeriod $period, AttendanceMode $mode): array
    {
        $days = array_sum($this->attendedDays($students, $period));
        $ids = (clone $students)->pluck('students.id')->all();

        return [
            'present' => $mode === AttendanceMode::OnTime ? $days : 0,
            'late' => $mode === AttendanceMode::Late ? $days : 0,
            'absent' => array_sum($this->absence->forStudents($ids, $period)),
        ];
    }

    /**
     * The record list: students alphabetically with their own counts.
     *
     * @return array{rows: list<array<string, mixed>>, total: int}
     */
    public function records(Builder $students, ReportPeriod $period, AttendanceMode $mode, int $limit): array
    {
        $page = (clone $students)->orderBy('last_name')->orderBy('first_name')->limit($limit)->get();
        $ids = $page->pluck('id')->all();
        $attended = $this->attendedDays($students, $period, $ids);
        $absent = $this->absence->forStudents($ids, $period);

        $rows = $page->map(function ($student) use ($attended, $absent, $mode) {
            $days = $attended[$student->id] ?? 0;

            return [
                'id' => $student->id,
                'name' => $student->displayName(),
                'student_number' => $student->student_number,
                'present' => $mode === AttendanceMode::OnTime ? $days : 0,
                'absent' => $absent[$student->id] ?? 0,
                'late' => $mode === AttendanceMode::Late ? $days : 0,
            ];
        })->values()->all();

        return ['rows' => $rows, 'total' => (clone $students)->count()];
    }

    /**
     * Rows for exactly these students, in the order given (used by the print ranking).
     *
     * @param list<int> $ids
     * @return list<array<string, mixed>>
     */
    public function rowsFor(array $ids, ReportPeriod $period, AttendanceMode $mode): array
    {
        if ($ids === []) {
            return [];
        }

        $students = Student::query()->whereIn('id', $ids)->get()->keyBy('id');
        $attended = $this->attendedDays(Student::query()->whereIn('students.id', $ids), $period);

        return array_map(function (int $id) use ($students, $attended, $mode) {
            $days = $attended[$id] ?? 0;

            return [
                'id' => $id,
                'name' => $students[$id]->displayName(),
                'student_number' => $students[$id]->student_number,
                'present' => $mode === AttendanceMode::OnTime ? $days : 0,
                'late' => $mode === AttendanceMode::Late ? $days : 0,
            ];
        }, $ids);
    }

    /**
     * School days with at least one approved entry, per student id.
     *
     * @param list<int>|null $onlyIds
     * @return array<int, int>
     */
    private function attendedDays(Builder $students, ReportPeriod $period, ?array $onlyIds = null): array
    {
        $query = DB::table('gate_events')
            ->join('students', 'students.id', '=', 'gate_events.student_id')
            ->join('sections', 'sections.id', '=', 'students.section_id')
            ->where('gate_events.direction', Direction::In->value)
            ->where('gate_events.person_type', PersonType::Student->value)
            ->whereIn('gate_events.status', self::APPROVED)
            ->where('gate_events.scanned_at', '>=', $period->queryStart())
            ->where('gate_events.scanned_at', '<', $period->queryEnd())
            ->whereIn('gate_events.student_id', (clone $students)->select('students.id'));

        if ($onlyIds !== null) {
            $query->whereIn('gate_events.student_id', $onlyIds);
        }

        $seen = [];
        foreach ($query->get(['gate_events.student_id', 'gate_events.scanned_at', 'sections.level']) as $row) {
            $local = SchoolClock::fromDatabase($row->scanned_at);
            $schoolDays = config("verifigate.reports.school_days.{$row->level}", [1, 2, 3, 4, 5]);

            if (in_array($local->dayOfWeekIso, $schoolDays, true)) {
                $seen[$row->student_id][$local->format('Y-m-d')] = true;
            }
        }

        return array_map('count', $seen);
    }
}
