<?php

namespace App\Models;

use App\Enums\Gate\DecidedBy;
use App\Enums\Gate\Direction;
use App\Enums\Gate\GateStatus;
use App\Enums\Gate\PersonType;
use App\Enums\Gate\UniformStatus;
use App\Enums\Gate\VerificationMethod;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Relations\HasMany;
use Illuminate\Database\Eloquent\Relations\HasOne;

class GateEvent extends Model
{
    protected $guarded = [];

    protected function casts(): array
    {
        return [
            'person_type' => PersonType::class,
            'direction' => Direction::class,
            'status' => GateStatus::class,
            'decided_by' => DecidedBy::class,
            'verification_method' => VerificationMethod::class,
            'uniform_status' => UniformStatus::class,
            'scanned_at' => 'datetime',
            'decided_at' => 'datetime',
        ];
    }

    /** Which foreign key column holds this kind of person (null = none). */
    public static function personColumn(PersonType $type): ?string
    {
        return match ($type) {
            PersonType::Student => 'student_id',
            PersonType::Faculty => 'faculty_id',
            PersonType::Employee => 'employee_id',
            PersonType::Visitor => 'guardian_id',
            default => null,
        };
    }

    public function flags(): HasMany
    {
        return $this->hasMany(GateEventFlag::class);
    }

    /** The exit event that closes this entry (later stage). */
    public function exitEvent(): HasOne
    {
        return $this->hasOne(self::class, 'paired_entry_id');
    }

    public function student(): BelongsTo
    {
        return $this->belongsTo(Student::class);
    }

    public function faculty(): BelongsTo
    {
        return $this->belongsTo(Faculty::class);
    }

    public function employee(): BelongsTo
    {
        return $this->belongsTo(Employee::class);
    }

    public function guardian(): BelongsTo
    {
        return $this->belongsTo(Guardian::class);
    }
    public function exemption(): BelongsTo
    {
        return $this->belongsTo(Exemption::class);
    }
}
