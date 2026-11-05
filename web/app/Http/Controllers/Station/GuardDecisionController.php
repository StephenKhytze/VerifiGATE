<?php

namespace App\Http\Controllers\Station;

use App\Enums\Gate\DecidedBy;
use App\Enums\Gate\FlagReason;
use App\Enums\Gate\GateStatus;
use App\Enums\Gate\PersonType;
use App\Http\Controllers\Controller;
use App\Models\GateEvent;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;

class GuardDecisionController extends Controller
{
    public function __invoke(Request $request, GateEvent $event): JsonResponse
    {
        $decision = $request->validate(['decision' => ['required', 'in:approve,deny']])['decision'];

        return DB::transaction(function () use ($event, $decision, $request) {
            $e = GateEvent::lockForUpdate()->findOrFail($event->id);

            abort_unless($e->status === GateStatus::Pending, 409, 'Already decided');
            abort_if(
                $decision === 'approve' && $e->person_type === PersonType::Unknown,
                422,
                'Identify the person first'
            );

            $uniformValues = array_map(fn (FlagReason $r) => $r->value, FlagReason::uniformReasons());
            $uniformFlag = $e->flags()->whereIn('reason', $uniformValues)->exists();

            $e->update([
                'status' => $decision === 'deny'
                    ? GateStatus::Flagged
                    : ($uniformFlag ? GateStatus::ApprovedFlaggedUniform : GateStatus::Approved),
                'decided_by' => DecidedBy::Guard,
                'guard_user_id' => $request->user()->id,
                'decided_at' => now(),
            ]);

            return response()->json(['status' => $e->status->value]);
        });
    }
}
