<?php

namespace App\Models;

use App\Enums\Gate\FlagReason;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class GateEventFlag extends Model
{
    public $timestamps = false;   // created_at is filled by a DB default

    protected $guarded = [];

    protected function casts(): array
    {
        return ['reason' => FlagReason::class];
    }

    public function event(): BelongsTo
    {
        return $this->belongsTo(GateEvent::class, 'gate_event_id');
    }
}
