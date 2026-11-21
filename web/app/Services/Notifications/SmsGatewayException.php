<?php

namespace App\Services\Notifications;

use RuntimeException;

final class SmsGatewayException extends RuntimeException
{
    /** @param string $errorCode short code such as MOCK_FAIL; never personal data */
    public function __construct(public readonly string $errorCode)
    {
        parent::__construct($errorCode);
    }
}