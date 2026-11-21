<?php

namespace App\Jobs;

use App\Enums\Gate\SmsStatus;
use App\Models\SmsNotification;
use App\Services\Notifications\SmsGateway;
use App\Services\Notifications\SmsGatewayException;
use App\Services\Notifications\SmsMessage;
use Illuminate\Bus\Queueable;
use Illuminate\Contracts\Queue\ShouldQueue;
use Illuminate\Foundation\Bus\Dispatchable;
use Illuminate\Queue\InteractsWithQueue;
use Throwable;

class SendEntryNotification implements ShouldQueue
{
    use Dispatchable, InteractsWithQueue, Queueable;

    public int $tries = 3;   // first attempt plus two retries

    public function __construct(public int $notificationId)
    {
    }

    /** Wait 10 s after the first failure and 60 s after the second. */
    public function backoff(): array
    {
        return config('verifigate.notifications.backoff', [10, 60]);
    }

    public function handle(SmsGateway $gateway): void
    {
        $n = SmsNotification::with(['gateEvent.student', 'guardian'])->find($this->notificationId);

        // Idempotent: anything already handled (or deleted) is left alone.
        if (! $n || $n->status !== SmsStatus::Pending) {
            return;
        }

        $event = $n->gateEvent;
        $number = trim((string) $n->guardian?->mobile_number);

        if (! $event?->student) {
            $n->update(['status' => SmsStatus::Failed, 'error' => 'NO_STUDENT']);

            return;
        }
        if ($number === '') {
            $n->update(['status' => SmsStatus::Skipped, 'error' => 'NO_NUMBER']);

            return;
        }

        try {
            $result = $gateway->send($number, SmsMessage::entry($event, now()));
        } catch (SmsGatewayException $e) {
            $n->update(['error' => $e->errorCode]);   // visible while retries run
            throw $e;                                 // the queue applies the backoff
        }

        $n->update(['status' => $result->status, 'sent_at' => now(), 'error' => null]);
    }

    /** Runs once, after the last attempt has failed. */
    public function failed(Throwable $e): void
    {
        SmsNotification::where('id', $this->notificationId)
            ->where('status', SmsStatus::Pending->value)
            ->update([
                'status' => SmsStatus::Failed->value,
                'error' => $e instanceof SmsGatewayException ? $e->errorCode : 'JOB_ERROR',
            ]);
    }
}