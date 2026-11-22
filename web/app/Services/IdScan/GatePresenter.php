<?php

namespace App\Services\IdScan;

use App\Enums\Gate\Direction;
use App\Enums\Gate\GateStatus;
use App\Enums\Gate\PersonType;
use App\Models\GateEvent;
use App\Models\Section;
use App\Enums\Gate\SmsStatus;

/** Turns events into the arrays the screens use. */
final class GatePresenter
{
    /** Relations to eager-load before presenting. */
    public static function with(): array
    {
        return ['student.section.program', 'faculty', 'employee', 'guardian.students', 'flags', 'exemption.type'];
    }

    public static function sectionLabel(?Section $s): ?string
    {
        if (!$s) {
            return null;
        }

        return $s->program ? "{$s->program->code} - {$s->name}" : "Grade {$s->year_or_grade} - {$s->name}";
    }

    public function name(GateEvent $e): string
    {
        $p = $e->student ?? $e->faculty ?? $e->employee ?? $e->guardian;

        return $p ? $p->displayName() : ($e->visitor_name ?? 'UNIDENTIFIED');
    }

    public function identifier(GateEvent $e): ?string
    {
        return $e->student?->student_number ?? $e->faculty?->employee_no ?? $e->employee?->employee_no;
    }

    /** Plain-text SMS state for the guard card. Never contains a phone number. */
    private function smsLabel(GateEvent $e): string
    {
        if ($e->person_type !== PersonType::Student || $e->direction === Direction::Out) {
            return 'N/A';
        }

        if ($e->status === GateStatus::Pending) {
            return 'Waiting for approval';
        }

        if ($e->status === GateStatus::Flagged) {
            return 'Not sent';
        }

        if (config('verifigate.notifications.driver') === 'off') {
            return 'Off';
        }

        $notification = $e->smsNotifications->sortByDesc('id')->first();

        return match ($notification?->status) {
            SmsStatus::Sent => 'Sent (unconfirmed)',
            SmsStatus::Delivered => 'Delivered',
            SmsStatus::Failed => 'Failed',
            SmsStatus::Skipped => 'No contact on file',
            default => 'Pending',
        };
    }

    /** Full card for the guard's main panel. */
    public function guardCard(GateEvent $e): array
    {
        $e->loadMissing('smsNotifications');
        $visitor = $e->person_type === PersonType::Visitor;

        return [
            'id' => $e->id,
            'status' => $e->status->value,
            'person_type' => $e->person_type->value,
            'name' => $this->name($e),
            'identifier' => $this->identifier($e),
            'section' => self::sectionLabel($e->student?->section),
            'id_type' => $e->id_type,
            'time' => $e->scanned_at->format('g:ia'),
            'scan_attempts' => $e->scan_attempts,
            'uniform' => $e->uniform_status
                ? ['status' => $e->uniform_status->value, 'confidence' => $e->uniform_confidence]
                : null,
            'exceptions' => $e->exemption?->type?->name ?? 'None',
            'flags' => $e->flags->map(fn ($f) => [
                'code' => $f->reason->value,
                'label' => $f->reason->label(),
            ])->values()->all(),
            'sms' => $this->smsLabel($e),
            // null = not a visitor; [] = visitor not on any pickup list
            'pickup' => $visitor ? ($e->guardian?->students->map->displayName()->values()->all() ?? []) : null,
            'needs_decision' => $e->status === GateStatus::Pending,
            'can_approve' => $e->person_type !== PersonType::Unknown,
            'image_url' => "/gate/events/{$e->id}/id-image",
        ];
    }

    /** Small card for the side panel. */
    public function logCard(GateEvent $e): array
    {
        [$label, $tone, $icon] = match (true) {
            $e->direction === Direction::Out => ['Exit', 'orange', 'exit'],
            $e->status === GateStatus::Pending => ['Waiting for guard', 'amber', 'clock'],
            $e->status === GateStatus::Approved => ['Approved Entry', 'green', 'check'],
            $e->status === GateStatus::ApprovedFlaggedUniform => ['Approved (flagged uniform)', 'orange', 'shirt'],
            default => ['Flagged Entry', 'gray', 'x'],
        };

        return [
            'id' => $e->id,
            'label' => $label,
            'tone' => $tone,
            'icon' => $icon,
            'name' => $this->name($e),
            'identifier' => $this->identifier($e),
            'time' => $e->scanned_at->format('g:ia'),
        ];
    }

    /** Red alert for the Important panel. The id is the gate event id, so clicking opens that student's history. */
    public function smsAlertCard(GateEvent $e, string $label, string $icon): array
    {
        return [
            'id' => $e->id,
            'label' => $label,
            'tone' => 'red',
            'icon' => $icon,
            'name' => $this->name($e),
            'identifier' => $this->identifier($e),
            'time' => $e->scanned_at->format('g:ia'),
        ];
    }
}
