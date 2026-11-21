<?php

namespace App\Models;

use App\Models\Concerns\HasPersonName;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsToMany;
use Illuminate\Database\Eloquent\Relations\HasMany;

class Guardian extends Model
{
    /** @use HasFactory<\Database\Factories\GuardianFactory> */
    use HasFactory, HasPersonName;

    /** Keep phone numbers out of any JSON or array output of this model. */
    protected $hidden = ['mobile_number'];

    /** Students this guardian may pick up (active authorizations only). */
    public function students(): BelongsToMany
    {
        return $this->belongsToMany(Student::class, 'pickup_authorizations')
            ->wherePivot('is_active', true);
    }

    public function pickupAuthorizations(): HasMany
    {
        return $this->hasMany(PickupAuthorization::class);
    }
}