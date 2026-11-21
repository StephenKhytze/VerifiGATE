<?php

namespace App\Services\Notifications;

interface SmsGateway
{
    /**
     * Send one message.
     *
     * @throws SmsGatewayException when sending fails (the queued job retries).
     */
    public function send(string $to, string $message): SmsResult;
}