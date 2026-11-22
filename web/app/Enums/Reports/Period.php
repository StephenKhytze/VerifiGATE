<?php

namespace App\Enums\Reports;

enum Period: string
{
    case Daily = 'daily';
    case Weekly = 'weekly';
    case Monthly = 'monthly';

    public function label(): string
    {
        return ucfirst($this->value);
    }

    /** Unknown or missing input falls back to Weekly, the dropdown's default in the mockups. */
    public static function fromInput(?string $value): self
    {
        return self::tryFrom((string) $value) ?? self::Weekly;
    }
}
