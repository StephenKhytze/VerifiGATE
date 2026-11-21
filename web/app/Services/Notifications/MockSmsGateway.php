<?php

namespace App\Services\Notifications;

use App\Enums\Gate\SmsStatus;
use Illuminate\Support\Facades\Log;

final class MockSmsGateway implements SmsGateway
{
    public function send(string $to, string $message): SmsResult
    {
        $hint = PhoneMask::hint($to);
        $outcome = strtolower((string) config('verifigate.notifications.mock_result', 'delivered'));

        if ($outcome === 'fail') {
            Log::warning("[MOCK SMS] simulated failure for {$hint}");

            throw new SmsGatewayException('MOCK_FAIL');
        }

        Log::info("[MOCK SMS] to {$hint}\n{$message}");

        return new SmsResult($outcome === 'sent' ? SmsStatus::Sent : SmsStatus::Delivered);
    }
}