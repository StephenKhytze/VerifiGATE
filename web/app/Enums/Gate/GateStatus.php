<?php

namespace App\Enums\Gate;

enum GateStatus: string
{
    case Pending = 'pending';
    case Approved = 'approved';
    case ApprovedFlaggedUniform = 'approved_flagged_uniform';
    case Flagged = 'flagged';
}
