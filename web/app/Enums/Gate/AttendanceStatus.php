<?php

namespace App\Enums\Gate;

enum AttendanceStatus: string
{
    case OnTime = 'on_time';
    case Late = 'late';
}
