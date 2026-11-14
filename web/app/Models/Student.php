<?php

namespace App\Models;

use App\Models\Concerns\HasPersonName;
use Illuminate\Database\Eloquent\Model;
use App\Enums\Sex;
use Illuminate\Database\Eloquent\Casts\Attribute;


class Student extends Model
{
    use HasPersonName;
    public function section() {
        return $this->belongsTo(Section::class);
    }
    
    protected function casts(): array
    {
        return ['sex' => Sex::class];
    }

    // Read-only values taken from the student's section
    protected function academicLevel(): Attribute
    {
        return Attribute::get(fn () => $this->section?->level);
    }

    protected function yearLevel(): Attribute
    {
        return Attribute::get(fn () => $this->section?->year_or_grade);
    }

    protected function course(): Attribute
    {
        return Attribute::get(fn () => $this->section?->program?->code);   // null for K-12
    }

    protected function sectionName(): Attribute
    {
        return Attribute::get(fn () => $this->section?->name);
    }
}
