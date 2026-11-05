<?php

namespace App\Enums\Gate;

enum DecidedBy: string
{
    case System = 'system';
    case Guard = 'guard';
}
