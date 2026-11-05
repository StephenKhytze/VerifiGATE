<?php

namespace App\Services\IdScan;

use App\Enums\Gate\GateStatus;
use App\Enums\Gate\PersonType;
use App\Models\GateEvent;
use Illuminate\Support\Facades\Cache;

final class GateState
{
    private const RESULT_SECONDS = 6;       // how long a finished result stays on screen
    private const GUARD_PENDING_MINUTES = 10;
    private const STUDENT_PENDING_MINUTES = 2;
    private const SIGNAL_SECONDS = 15;

    public function __construct(private GatePresenter $presenter)
    {
    }

    /** Data for the guard's screen. */
    public function guard(): array
    {
        $decided = GateEvent::with(GatePresenter::with())
            ->where('status', '!=', GateStatus::Pending->value)
            ->where('decided_at', '>=', now()->subSeconds(self::RESULT_SECONDS))
            ->latest('decided_at')->first();

        $pendingQuery = GateEvent::with(GatePresenter::with())
            ->where('status', GateStatus::Pending->value)
            ->where('scanned_at', '>=', now()->subMinutes(self::GUARD_PENDING_MINUTES));

        $current = $decided ?? (clone $pendingQuery)->oldest('scanned_at')->first();

        return [
            'mode' => $decided ? 'result' : ($current ? 'review' : 'idle'),
            'current' => $current ? $this->presenter->guardCard($current) : null,
            'pending_count' => (clone $pendingQuery)->count(),
            'important' => [],   // SMS unsent/unconfirmed: filled when the SMS module exists
            'recent' => GateEvent::with(GatePresenter::with())
                ->latest('scanned_at')->limit(30)->get()
                ->map(fn ($e) => $this->presenter->logCard($e))->values()->all(),
        ];
    }

    /** Data for the student-facing screen. Never includes flag reasons. */
    public function screen(): array
    {
        $e = $this->screenEvent();

        if ($e) {
            $kind = match (true) {
                $e->status === GateStatus::Pending => 'scanning',
                $e->status === GateStatus::Flagged => 'flagged',
                $e->person_type === PersonType::Visitor => 'visitor_welcome',
                default => 'welcome',
            };
            $shown = in_array($kind, ['welcome', 'visitor_welcome'], true);
            $person = $e->student ?? $e->faculty ?? $e->employee;

            return [
                'screen' => $kind,
                'given_names' => $kind === 'welcome' ? $person?->first_name : null,
                'time' => $shown ? ($e->decided_at ?? $e->scanned_at)->format('g:ia') : null,
            ];
        }

        $signal = Cache::get('gate.signal');
        if ($signal && $signal['state'] === 'card' && now()->timestamp - $signal['at'] <= self::SIGNAL_SECONDS) {
            return ['screen' => 'scanning', 'given_names' => null, 'time' => null];
        }

        return ['screen' => 'idle', 'given_names' => null, 'time' => null];
    }

    private function screenEvent(): ?GateEvent
    {
        $decided = GateEvent::with(['student', 'faculty', 'employee'])
            ->where('status', '!=', GateStatus::Pending->value)
            ->where('decided_at', '>=', now()->subSeconds(self::RESULT_SECONDS))
            ->latest('decided_at')->first();

        $pending = GateEvent::with(['student', 'faculty', 'employee'])
            ->where('status', GateStatus::Pending->value)
            ->where('scanned_at', '>=', now()->subMinutes(self::STUDENT_PENDING_MINUTES))
            ->latest('scanned_at')->first();

        if ($decided && $pending) {
            return $decided->decided_at->gte($pending->scanned_at) ? $decided : $pending;
        }

        return $decided ?? $pending;
    }
}
