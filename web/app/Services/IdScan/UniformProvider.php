<?php

namespace App\Services\IdScan;

/** The uniform checker module will implement this when it exists. */
interface UniformProvider
{
    public function current(): UniformResult;
}
