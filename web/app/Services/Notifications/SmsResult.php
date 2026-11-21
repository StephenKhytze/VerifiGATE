<?php

namespace App\Services\Notifications;

use App\Enums\Gate\SmsStatus;

final readonly class SmsResult
{
    /** @param SmsStatus $status Sent (accepted, not confirmed) or Delivered (confirmed) */
    public function __construct(public SmsStatus $status)
    {
    }
}