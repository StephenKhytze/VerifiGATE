<?php

namespace App\Services\Reports;

use App\Enums\Gate\Direction;
use App\Enums\Gate\PersonType;
use App\Support\SchoolClock;
use Illuminate\Database\Eloquent\Builder;
use Illuminate\Support\Facades\DB;

final class IncidentReport
{
    /**
     * Chart data: one incident per student per day, bucketed by the earliest flagged entry.
     *
     * @return array{series: list<array{key: string, label: string, value: int}>, total: int}
     */
    public function series(Builder $students, ReportPeriod $period): array
    {
        $perBucket = [];
        foreach ($this->incidents($students, $period) as $incident) {
            $perBucket[$incident['bucket']] = ($perBucket[$incident['bucket']] ?? 0) + 1;
        }

        return [
            'series' => array_map(
                fn (array $bucket) => $bucket + ['value' => $perBucket[$bucket['key']] ?? 0],
                $period->buckets(),
            ),
            'total' => array_sum($perBucket),
        ];
    }

    /**
     * Incident days per student id. Same rule as the chart, so the totals always agree.
     *
     * @return array<int, int>
     */
    public function perStudent(Builder $students, ReportPeriod $period): array
    {
        $perStudent = [];
        foreach ($this->incidents($students, $period) as $incident) {
            $perStudent[$incident['student_id']] = ($perStudent[$incident['student_id']] ?? 0) + 1;
        }

        return $perStudent;
    }

    /** One entry per student per day: the earliest flagged entry decides the bucket. */
    private function incidents(Builder $students, ReportPeriod $period): array
    {
        $rows = DB::table('gate_event_flags')
            ->join('gate_events', 'gate_events.id', '=', 'gate_event_flags.gate_event_id')
            ->where('gate_events.direction', Direction::In->value)
            ->where('gate_events.person_type', PersonType::Student->value)
            ->whereIn('gate_event_flags.reason', config('verifigate.reports.incident_flags', []))
            ->where('gate_events.scanned_at', '>=', $period->queryStart())
            ->where('gate_events.scanned_at', '<', $period->queryEnd())
            ->whereIn('gate_events.student_id', (clone $students)->select('students.id'))
            ->orderBy('gate_events.scanned_at')
            ->get(['gate_events.student_id', 'gate_events.scanned_at']);

        $counted = [];
        $incidents = [];
        foreach ($rows as $row) {
            $local = SchoolClock::fromDatabase($row->scanned_at);
            $bucket = $period->bucketKey($local);
            $once = $row->student_id . '|' . $local->format('Y-m-d');

            if ($bucket === null || isset($counted[$once])) {
                continue;
            }

            $counted[$once] = true;
            $incidents[] = ['student_id' => (int) $row->student_id, 'bucket' => $bucket];
        }

        return $incidents;
    }
}
