<?php

namespace App\Services\Notifications;

use App\Models\GateEvent;
use Carbon\CarbonInterface;
use Illuminate\Support\Str;

final class SmsMessage
{
    /** The entry message for a guardian. Expects $event->student to be loadable. */
    public static function entry(GateEvent $event, CarbonInterface $sentAt): string
    {
        $zone = config('verifigate.notifications.timezone', 'Asia/Manila');
        $student = $event->student;

        $name = Str::upper(trim(
            "{$student->last_name}, {$student->first_name}" . ($student->suffix ? " {$student->suffix}" : '')
        ));
        $entered = ($event->decided_at ?? $event->scanned_at)->copy()->timezone($zone)->format('g:ia');
        $sent = $sentAt->copy()->timezone($zone)->format('g:ia');

        $lines = [
            "{$name} has entered the school",
            "Time entered: {$entered}",
            '',
            "Time sent: {$sent}",
            'Sent by: System',
            '',
            '*** THIS IS AN AUTOMATICALLY GENERATED MESSAGE ***',
            '',
            'NOTE: This message may arrive later than logged time.',
            'PAALALA: Maaaring mahuli ang pagdating ng mensaheng ito.',
        ];

        // Fold each line on its own: Str::ascii() would turn newlines into spaces.
        return implode("\n", array_map(fn (string $line) => Str::ascii($line), $lines));
        return Str::ascii($body);   // ASCII only, e.g. NUÑEZ becomes NUNEZ
    }
}