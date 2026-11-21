<?php

namespace App\Models;

use App\Enums\Gate\SmsStatus;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class SmsNotification extends Model
{
    protected $guarded = [];

    protected function casts(): array
    {
        return [
            'status' => SmsStatus::class,
            'sent_at' => 'datetime',
        ];
    }

    public function gateEvent(): BelongsTo
    {
        return $this->belongsTo(GateEvent::class);
    }

    public function guardian(): BelongsTo
    {
        return $this->belongsTo(Guardian::class);
    }
}