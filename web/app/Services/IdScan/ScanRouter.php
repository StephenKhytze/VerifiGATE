<?php

namespace App\Services\IdScan;

use App\Enums\Gate\FlagReason;
use App\Enums\Gate\GateStatus;
use App\Enums\Gate\PersonType;
use App\Enums\Gate\UniformStatus;
use App\Models\Exemption;
use Illuminate\Support\Collection;

/** Pure decision logic: no database writes, easy to test. */
final class ScanRouter
{
    /** @param Collection<int, Exemption> $exemptions today's exemptions for this student */
    public function route(Identity $id, UniformResult $uniform, bool $inside, Collection $exemptions): Decision
    {
        $t = config('verifigate.thresholds');
        $flags = $id->flags;

        if ($id->type === PersonType::Unknown) {
            return new Decision(GateStatus::Pending, $flags);
        }
        if ($id->type === PersonType::Visitor) {
            $flags[] = FlagReason::VisitorReview;
            return new Decision(GateStatus::Pending, $this->unique($flags));
        }

        if (($id->ocrConfidence ?? 0) < $t['ocr_high']) {
            $flags[] = FlagReason::LowOcrConfidence;
        }
        if (($id->nameScore ?? 0) < $t['name_min']) {
            $flags[] = FlagReason::NameMismatch;
        }
        if ($inside) {
            $flags[] = FlagReason::AlreadyInside;
        }

        $exemptionId = null;
        if ($id->type === PersonType::Student) {
            switch ($uniform->status) {
                case UniformStatus::Compliant:
                    break;
                case UniformStatus::NonCompliant:
                    $explained = $this->explaining($exemptions, $uniform->detectedLabel);
                    if ($explained) {
                        $exemptionId = $explained->id;
                    } else {
                        $flags[] = FlagReason::UniformNonCompliant;
                    }
                    break;
                case UniformStatus::LowConfidence:
                    $flags[] = FlagReason::UniformLowConfidence;
                    break;
                case UniformStatus::Unavailable:
                    $flags[] = FlagReason::UniformUnavailable;
                    break;
            }
        }

        $flags = $this->unique($flags);

        return new Decision($flags ? GateStatus::Pending : GateStatus::Approved, $flags, $exemptionId);
    }

    /** @param list<FlagReason> $flags @return list<FlagReason> */
    private function unique(array $flags): array
    {
        return collect($flags)->unique(fn (FlagReason $f) => $f->value)->values()->all();
    }

    private function explaining(Collection $exemptions, ?string $label): ?Exemption
    {
        $label = $label ? Names::norm($label) : null;

        return $exemptions->first(function (Exemption $e) use ($label) {
            $name = Names::norm($e->type->name);

            return in_array($name, config('verifigate.any_clothes_exemptions'), true)
                || ($label !== null && $name === $label);
        });
    }
}
