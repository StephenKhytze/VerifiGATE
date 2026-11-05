<?php

namespace App\Enums\Gate;

enum VerificationMethod: string
{
    case OcrAuto = 'ocr_auto';
    case GuardManual = 'guard_manual';
    case RegistrationCard = 'registration_card';
}
