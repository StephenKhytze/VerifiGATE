<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Guardian extends Model
{
    /** @use HasFactory<\Database\Factories\GuardianFactory> */
    use HasFactory;
    public function students()
    {
        return $this->belongsToMany(Student::class, 'pickup_authorizations')
            ->wherePivot('is_active', true);
    }
}
