<?php

namespace App\Services\IdScan;

use App\Enums\Gate\FlagReason;
use App\Enums\Gate\PersonType;
use Illuminate\Database\Eloquent\Model;

final class Identity
{
    /**
     * @param list<FlagReason> $flags
     */
    public function __construct(
        public PersonType $type,
        public ?Model $model = null,
        public bool $active = true,
        public ?float $nameScore = null,       // 0-100
        public ?float $ocrConfidence = null,   // 0-100
        public ?string $visitorName = null,
        public ?string $idType = null,
        public array $flags = [],
    ) {
    }

    /** @param list<FlagReason> $flags */
    public static function unknown(array $flags, ?float $ocrConfidence = null): self
    {
        return new self(PersonType::Unknown, ocrConfidence: $ocrConfidence, flags: $flags);
    }
}
