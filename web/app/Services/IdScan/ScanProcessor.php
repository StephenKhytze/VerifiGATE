<?php

namespace App\Services\IdScan;

use App\Enums\Gate\DecidedBy;
use App\Enums\Gate\Direction;
use App\Enums\Gate\FlagReason;
use App\Enums\Gate\GateStatus;
use App\Enums\Gate\PersonType;
use App\Enums\Gate\UniformStatus;
use App\Enums\Gate\VerificationMethod;
use App\Models\Exemption;
use App\Models\GateEvent;
use App\Models\SchoolYear;
use Illuminate\Support\Facades\DB;

final class ScanProcessor
{
    public function __construct(
        private OcrClient $ocr,
        private IdentityMatcher $matcher,
        private ScanRouter $router,
        private UniformProvider $uniform,
        private PresenceService $presence,
    ) {
    }

    /**
     * @param int $attempt 1 = first try, 2 = automatic retry
     * @return array{result: string, event_id?: int}
     */
    public function process(string $jpeg, int $attempt): array
    {
        $started = hrtime(true);

        try {
            $ocr = $this->ocr->read($jpeg);
        } catch (OcrUnavailable) {
            return $this->finish(Identity::unknown([FlagReason::OcrUnavailable]), $attempt, $started);
        }

        $identity = $this->matcher->identify($ocr);

        if ($identity->type === PersonType::Unknown) {
            if ($attempt < 2) {
                return ['result' => 'retry'];   // nothing is logged for the first failed read
            }
            $identity->flags[] = FlagReason::UnreadableAfterRetry;
        }

        return $this->finish($identity, $attempt, $started);
    }

    private function finish(Identity $id, int $attempt, int $started): array
    {
        $column = GateEvent::personColumn($id->type);
        $personId = $id->model?->getKey();

        // Same person already waiting for the guard: don't create a second event
        if ($column && $personId) {
            $duplicate = GateEvent::where($column, $personId)
                ->where('status', GateStatus::Pending->value)
                ->where('scanned_at', '>=', now()->subSeconds(config('verifigate.duplicate_window_seconds')))
                ->first();
            if ($duplicate) {
                return ['result' => 'duplicate', 'event_id' => $duplicate->id];
            }
        }

        $isStudent = $id->type === PersonType::Student;
        [$decision, $uniform] = $this->evaluate($id);
        $uniform = $isStudent ? $this->uniform->current() : new UniformResult(UniformStatus::Unavailable);
        $exemptions = $isStudent
            ? Exemption::with('type')->where('student_id', $personId)->whereDate('date', today())->get()
            : collect();

        $decision = $this->router->route(
            $id,
            $uniform,
            $this->presence->isInside($id->type, $personId),
            $exemptions
        );

        $event = DB::transaction(function () use ($id, $decision, $uniform, $isStudent, $column, $personId, $attempt, $started) {
            $auto = $decision->status === GateStatus::Approved;

            $attrs = [
                'school_year_id' => SchoolYear::where('is_current', true)->firstOrFail()->id,
                'direction' => Direction::In,
                'person_type' => $id->type,
                'status' => $decision->status,
                'visitor_name' => ($id->type === PersonType::Visitor && !$personId) ? $id->visitorName : null,
                'id_type' => $id->idType,
                'verification_method' => VerificationMethod::OcrAuto,
                'decided_by' => $auto ? DecidedBy::System : null,
                'decided_at' => $auto ? now() : null,
                'scan_attempts' => $attempt,
                'ocr_confidence' => $id->ocrConfidence,
                'match_score' => $id->nameScore,
                'uniform_status' => $isStudent ? $uniform->status : null,
                'uniform_confidence' => $isStudent ? $uniform->confidence : null,
                'exemption_id' => $decision->exemptionId,
                'scanned_at' => now(),
                'verify_ms' => (int) ((hrtime(true) - $started) / 1_000_000),
            ];
            if ($column && $personId) {
                $attrs[$column] = $personId;
            }

            $event = GateEvent::create($attrs);
            foreach ($decision->flags as $flag) {
                $event->flags()->create(['reason' => $flag]);
            }

            return $event;
        });

        return ['result' => $event->status->value, 'event_id' => $event->id];
    }

    /** @return array{0: Decision, 1: UniformResult} */
    public function evaluate(Identity $id): array
    {
        $personId = $id->model?->getKey();
        $isStudent = $id->type === PersonType::Student;

        $uniform = $isStudent ? $this->uniform->current() : new UniformResult(UniformStatus::Unavailable);
        $exemptions = $isStudent
            ? Exemption::with('type')->where('student_id', $personId)->whereDate('date', today())->get()
            : collect();

        $decision = $this->router->route(
            $id,
            $uniform,
            $this->presence->isInside($id->type, $personId),
            $exemptions
        );

        return [$decision, $uniform];
    }
}
