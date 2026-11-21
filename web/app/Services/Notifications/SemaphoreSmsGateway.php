<?php

namespace App\Services\Notifications;

final class SemaphoreSmsGateway implements SmsGateway
{
    public function send(string $to, string $message): SmsResult
    {
        // Intentionally not implemented. Before writing this, read Semaphore's
        // current API documentation (endpoint, auth, number format, response fields).
        throw new SmsGatewayException('NOT_IMPLEMENTED');
    }
}