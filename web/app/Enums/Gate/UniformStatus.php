<?php

namespace App\Enums\Gate;

enum UniformStatus: string
{
    case Compliant = 'compliant';
    case NonCompliant = 'non_compliant';
    case LowConfidence = 'low_confidence';
    case Unavailable = 'unavailable';
}
