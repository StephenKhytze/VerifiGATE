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
        $perBucket = [];
        foreach ($rows as $row) {
            $local = SchoolClock::fromDatabase($row->scanned_at);
            $bucket = $period->bucketKey($local);
            $once = $row->student_id . '|' . $local->format('Y-m-d');

            if ($bucket === null || isset($counted[$once])) {
                continue;
            }

            $counted[$once] = true;
            $perBucket[$bucket] = ($perBucket[$bucket] ?? 0) + 1;
        }

        return [
            'series' => array_map(
                fn (array $bucket) => $bucket + ['value' => $perBucket[$bucket['key']] ?? 0],
                $period->buckets(),
            ),
            'total' => array_sum($perBucket),
        ];
    }
}
