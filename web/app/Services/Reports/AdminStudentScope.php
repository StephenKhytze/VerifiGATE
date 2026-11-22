<?php

namespace App\Services\Reports;

use App\Models\SchoolYear;
use App\Models\Student;
use Illuminate\Database\Eloquent\Builder;

/** Everyone the admin dashboard covers: active students of the current school year. */
final class AdminStudentScope
{
    public function students(): Builder
    {
        $schoolYearId = SchoolYear::where('is_current', true)->value('id');

        return Student::query()
            ->where('enrollment_status', 'active')
            ->whereHas('section', fn (Builder $section) => $section->where('school_year_id', $schoolYearId));
    }
}
