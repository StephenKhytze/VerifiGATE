<?php

namespace App\Services\Reports;

use Illuminate\Database\Eloquent\Builder;

interface FacultyStudentScope
{
    /** Students the logged-in faculty member handles. */
    public function students(): Builder;
}
