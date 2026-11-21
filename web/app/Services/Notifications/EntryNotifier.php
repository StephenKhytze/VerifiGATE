<?php

namespace App\Services\Notifications;

use App\Enums\Gate\Direction;
use App\Enums\Gate\GateStatus;
use App\Enums\Gate\PersonType;
use App\Enums\Gate\SmsStatus;
use App\Jobs\SendEntryNotification;
use App\Models\GateEvent;
use App\Models\PickupAuthorization;
use App\Models\SmsNotification;
use Illuminate\Database\UniqueConstraintViolationException;
use Throwable;

final class EntryNotifier
{
    /** The hook the approval code calls: a notification problem can never escape. */
    public function queueSafely(GateEvent $event): void
    {
        try {
            $this->queueFor($event);
        } catch (Throwable $e) {
            report($e);
        }
    }

    public function queueFor(GateEvent $event): void
    {
        if (config('verifigate.notifications.driver') === 'off' || ! $this->qualifies($event)) {
            return;
        }

        try {
            $notification = $this->record($event);
        } catch (UniqueConstraintViolationException) {
            return;   // another trigger created the row first
        }

        // Only a newly created pending row is dispatched, so a repeat trigger sends nothing.
        if ($notification->wasRecentlyCreated && $notification->status === SmsStatus::Pending) {
            SendEntryNotification::dispatch($notification->id);
        }
    }

    private function qualifies(GateEvent $event): bool
    {
        return $event->direction === Direction::In
            && $event->person_type === PersonType::Student
            && $event->student_id !== null
            && in_array($event->status, [GateStatus::Approved, GateStatus::ApprovedFlaggedUniform], true);
    }

    private function record(GateEvent $event): SmsNotification
    {
        // One guardian per student at the school: take the first notify_on_entry row.
        $authorization = PickupAuthorization::with('guardian')
            ->where('student_id', $event->student_id)
            ->where('notify_on_entry', true)
            ->orderBy('id')
            ->first();

        if (! $authorization?->guardian) {
            return $this->skipped($event, null, 'NO_GUARDIAN');
        }

        $number = trim((string) $authorization->guardian->mobile_number);
        if ($number === '') {
            return $this->skipped($event, $authorization->guardian_id, 'NO_NUMBER');
        }

        return SmsNotification::firstOrCreate(
            ['gate_event_id' => $event->id, 'guardian_id' => $authorization->guardian_id],
            ['status' => SmsStatus::Pending, 'recipient_hint' => PhoneMask::hint($number)],
        );
    }

    /** Skipped rows are informational only. A null guardian_id needs firstOrCreate: the unique key ignores NULLs. */
    private function skipped(GateEvent $event, ?int $guardianId, string $code): SmsNotification
    {
        return SmsNotification::firstOrCreate(
            ['gate_event_id' => $event->id, 'guardian_id' => $guardianId],
            ['status' => SmsStatus::Skipped, 'error' => $code],
        );
    }
}