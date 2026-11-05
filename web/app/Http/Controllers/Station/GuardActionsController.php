<?php

namespace App\Http\Controllers\Station;

use App\Enums\Gate\Direction;
use App\Enums\Gate\FlagReason;
use App\Enums\Gate\GateStatus;
use App\Enums\Gate\PersonType;
use App\Enums\Gate\VerificationMethod;
use App\Http\Controllers\Controller;
use App\Models\Employee;
use App\Models\Faculty;
use App\Models\GateEvent;
use App\Models\SchoolYear;
use App\Models\Student;
use App\Services\IdScan\GatePresenter;
use App\Services\IdScan\Identity;
use App\Services\IdScan\ScanProcessor;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;

class GuardActionsController extends Controller
{
    /** Find a person by name or ID number (lost-ID and unreadable-ID cases). */
    public function search(Request $request): JsonResponse
    {
        $q = trim($request->validate(['q' => ['required', 'string', 'min:2', 'max:60']])['q']);
        $like = '%' . addcslashes($q, '%_\\') . '%';
        $match = fn ($col) => fn ($w) => $w->where($col, 'like', $like)
            ->orWhere('last_name', 'like', $like)->orWhere('first_name', 'like', $like);

        $out = [];
        foreach (Student::with('section.program')->where($match('student_number'))->limit(8)->get() as $s) {
            $out[] = ['person_type' => 'student', 'person_id' => $s->id, 'name' => $s->displayName(),
                'identifier' => $s->student_number, 'section' => GatePresenter::sectionLabel($s->section),
                'active' => $s->enrollment_status === 'active'];
        }
        foreach (Faculty::where($match('employee_no'))->limit(4)->get() as $f) {
            $out[] = ['person_type' => 'faculty', 'person_id' => $f->id, 'name' => $f->displayName(),
                'identifier' => $f->employee_no, 'section' => null, 'active' => $f->status === 'active'];
        }
        foreach (Employee::where($match('employee_no'))->limit(4)->get() as $e) {
            $out[] = ['person_type' => 'employee', 'person_id' => $e->id, 'name' => $e->displayName(),
                'identifier' => $e->employee_no, 'section' => null, 'active' => $e->status === 'active'];
        }

        return response()->json($out);
    }

    /** Start an entry by hand (lost ID, registration card). Identify the person next. */
    public function manual(Request $request): JsonResponse
    {
        $event = DB::transaction(function () use ($request) {
            $e = GateEvent::create([
                'school_year_id' => SchoolYear::where('is_current', true)->firstOrFail()->id,
                'direction' => Direction::In,
                'person_type' => PersonType::Unknown,
                'status' => GateStatus::Pending,
                'verification_method' => VerificationMethod::RegistrationCard,
                'guard_user_id' => $request->user()->id,
                'scan_attempts' => 0,
                'scanned_at' => now(),
            ]);
            $e->flags()->create(['reason' => FlagReason::GuardManualFlag]);

            return $e;
        });

        return response()->json(['event_id' => $event->id]);
    }

    /** The guard says who this is. Uniform and already-inside checks run again. */
    public function identify(
        Request $request,
        GateEvent $event,
        ScanProcessor $processor,
        GatePresenter $presenter,
    ): JsonResponse {
        $data = $request->validate([
            'person_type' => ['required', 'in:student,faculty,employee'],
            'person_id' => ['required', 'integer'],
        ]);

        $type = PersonType::from($data['person_type']);
        $model = match ($type) {
            PersonType::Student => Student::findOrFail($data['person_id']),
            PersonType::Faculty => Faculty::findOrFail($data['person_id']),
            default => Employee::findOrFail($data['person_id']),
        };

        DB::transaction(function () use ($event, $type, $model, $processor) {
            $e = GateEvent::lockForUpdate()->findOrFail($event->id);
            abort_unless($e->status === GateStatus::Pending, 409, 'Already decided');
            abort_if($e->person_type === PersonType::Visitor, 422, 'Visitors are not identified this way');

            $active = ($model->enrollment_status ?? $model->status) === 'active';
            $identity = new Identity(
                type: $type, model: $model, active: $active,
                nameScore: 100.0, ocrConfidence: 100.0,   // guard-verified, so those checks pass
                flags: $active ? [] : [FlagReason::InactiveStudent],
            );
            [$decision, $uniform] = $processor->evaluate($identity);

            // Drop flags that described the failed identification, then add the new ones
            $obsolete = [FlagReason::NoMatch, FlagReason::AmbiguousMatch, FlagReason::NameMismatch,
                FlagReason::LowOcrConfidence, FlagReason::MatchedByNameOnly];
            $e->flags()->whereIn('reason', array_map(fn ($r) => $r->value, $obsolete))->delete();
            $have = $e->flags()->get()->map(fn ($f) => $f->reason->value)->all();
            foreach ($decision->flags as $flag) {
                if (!in_array($flag->value, $have, true)) {
                    $e->flags()->create(['reason' => $flag]);
                }
            }

            $isStudent = $type === PersonType::Student;
            $e->update([
                'student_id' => null, 'faculty_id' => null, 'employee_id' => null, 'guardian_id' => null,
            ]);
            $e->update([
                GateEvent::personColumn($type) => $model->getKey(),
                'person_type' => $type,
                'visitor_name' => null,
                'verification_method' => $e->verification_method === VerificationMethod::RegistrationCard
                    ? VerificationMethod::RegistrationCard : VerificationMethod::GuardManual,
                'match_score' => null,
                'uniform_status' => $isStudent ? $uniform->status : null,
                'uniform_confidence' => $isStudent ? $uniform->confidence : null,
                'exemption_id' => $decision->exemptionId,
            ]);
        });

        $fresh = GateEvent::with(GatePresenter::with())->findOrFail($event->id);

        return response()->json(['event' => $presenter->guardCard($fresh)]);
    }
}
