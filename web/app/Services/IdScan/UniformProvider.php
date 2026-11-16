<?php

namespace App\Services\IdScan;

use App\Models\Student;

/** The uniform checker module implements this. */
interface UniformProvider
{
    public function current(?Student $student = null): UniformResult;
}

