<?php

namespace App\Enums\Gate;

enum PersonType: string
{
    case Student = 'student';
    case Faculty = 'faculty';
    case Employee = 'employee';
    case Visitor = 'visitor';
    case Unknown = 'unknown';
}
