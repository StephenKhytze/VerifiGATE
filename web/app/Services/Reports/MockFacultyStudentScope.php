<?php

namespace App\Services\Reports;

use App\Models\SchoolYear;
use App\Models\Student;
use Illuminate\Database\Eloquent\Builder;

/** Stand-in: the "faculty" handles every active student of one program and year (config). */
final class MockFacultyStudentScope implements FacultyStudentScope
{
    public function students(): Builder
    {
        $mock = config('verifigate.reports.mock.faculty');
        $schoolYearId = SchoolYear::where('is_current', true)->value('id');

        return Student::query()
            ->where('enrollment_status', 'active')
            ->whereHas('section', fn (Builder $section) => $section
                ->where('school_year_id', $schoolYearId)
                ->where('year_or_grade', $mock['year'])
                ->whereHas('program', fn (Builder $program) => $program->where('code', $mock['program'])));
    }
}
