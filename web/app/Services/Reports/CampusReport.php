<?php

namespace App\Services\Reports;

use App\Enums\Gate\Direction;
use App\Enums\Gate\GateStatus;
use App\Enums\Gate\PersonType;
use App\Enums\Gate\VerificationMethod;
use App\Models\GateEvent;
use App\Support\SchoolClock;
use Carbon\CarbonInterface;

final class CampusReport
{
    private const APPROVED = [GateStatus::Approved->value, GateStatus::ApprovedFlaggedUniform->value];

    /**
     * "Currently Inside": students with an approved entry today (school time) and no exit.
     *
     * @return array{total: int, jhs: int, shs: int, college: int}
     */
    public function currentlyInside(?CarbonInterface $at = null): array
    {
        $day = SchoolClock::startOfDay($at);

        $byLevel = GateEvent::query()
            ->join('students', 'students.id', '=', 'gate_events.student_id')
            ->join('sections', 'sections.id', '=', 'students.section_id')
            ->where('gate_events.direction', Direction::In->value)
            ->where('gate_events.person_type', PersonType::Student->value)
            ->whereIn('gate_events.status', self::APPROVED)
            ->where('gate_events.scanned_at', '>=', SchoolClock::forQuery($day))
            ->where('gate_events.scanned_at', '<', SchoolClock::forQuery($day->copy()->addDay()))
            ->whereDoesntHave('exitEvent')
            ->selectRaw('sections.level as level, count(distinct gate_events.student_id) as total')
            ->groupBy('sections.level')
            ->get()
            ->pluck('total', 'level');

        return [
            'total' => (int) $byLevel->sum(),
            'jhs' => (int) ($byLevel['junior_high'] ?? 0),
            'shs' => (int) ($byLevel['senior_high'] ?? 0),
            'college' => (int) ($byLevel['college'] ?? 0),
        ];
    }

    /** Approved visitor entries in the period. */
    public function visitors(ReportPeriod $period): int
    {
        return GateEvent::query()
            ->where('direction', Direction::In->value)
            ->where('person_type', PersonType::Visitor->value)
            ->whereIn('status', self::APPROVED)
            ->where('scanned_at', '>=', $period->queryStart())
            ->where('scanned_at', '<', $period->queryEnd())
            ->count();
    }

    /** Student-days with an approved registration-card entry in the period. */
    public function registrationCardScans(ReportPeriod $period): int
    {
        $seen = [];

        $entries = GateEvent::query()
            ->where('direction', Direction::In->value)
            ->where('person_type', PersonType::Student->value)
            ->where('verification_method', VerificationMethod::RegistrationCard->value)
            ->whereIn('status', self::APPROVED)
            ->where('scanned_at', '>=', $period->queryStart())
            ->where('scanned_at', '<', $period->queryEnd())
            ->get(['student_id', 'scanned_at']);

        foreach ($entries as $entry) {
            $seen[$entry->student_id . '|' . SchoolClock::local($entry->scanned_at)->format('Y-m-d')] = true;
        }

        return count($seen);
    }
}
