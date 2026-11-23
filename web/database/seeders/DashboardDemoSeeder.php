<?php

namespace Database\Seeders;

use App\Enums\Gate\DecidedBy;
use App\Enums\Gate\Direction;
use App\Enums\Gate\FlagReason;
use App\Enums\Gate\GateStatus;
use App\Enums\Gate\PersonType;
use App\Enums\Gate\VerificationMethod;
use App\Models\Department;
use App\Models\GateEvent;
use App\Models\Program;
use App\Models\SchoolYear;
use App\Models\Section;
use App\Models\Student;
use App\Models\User;
use App\Support\SchoolClock;
use Carbon\CarbonInterface;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\DB;

/**
 * Fake attendance history for the dashboards: five weeks of entries for every active student,
 * with uniform flags, visitors, registration-card entries and exits.
 * Safe to run again: it replaces only the events it created (id_type = DEMO).
 */
class DashboardDemoSeeder extends Seeder
{
    private const MARKER = 'DEMO';
    private const DAYS = 35;
    private const VISITORS = ['JANE REYES', 'MARIO SANTOS', 'LINA CORPUZ', 'PETER LIM', 'ANNA GOMEZ'];

    public function run(): void
    {
        abort_if(app()->environment('production'), 403, 'Demo data is for dev only');

        Model::unguarded(function () {
            DB::transaction(function () {
                mt_srand(2026);

                $year = SchoolYear::where('is_current', true)->first()
                    ?? SchoolYear::create([
                        'label' => '2026-2027 (DEMO)', 'starts_on' => '2026-06-01',
                        'ends_on' => '2027-03-31', 'is_current' => true,
                    ]);

                $this->clearPreviousDemoEvents();
                $this->createStudents($year);
                $this->createEvents($year);
            });
        });
    }

    /** Exits first: they point at their entries. Flags and SMS rows go with their events. */
    private function clearPreviousDemoEvents(): void
    {
        GateEvent::where('id_type', self::MARKER)->whereNotNull('paired_entry_id')->delete();
        GateEvent::where('id_type', self::MARKER)->delete();
    }

    /** All fake. BSIT year 1 is the faculty dashboard's mock scope. */
    private function roster(): array
    {
        return [
            'bsit1a' => [
                ['2024-00101', 'ALCANTARA', 'JOSHUA MIGUEL', 'P'],
                ['2024-00102', 'BAUTISTA', 'MARIA ANGELICA', 'S'],
                ['2024-00103', 'DIZON', 'PAOLO', 'R'],
                ['2024-00104', 'ESPIRITU', 'KATRINA', 'L'],
                ['2024-00105', 'FLORES', 'MARK ANTHONY', 'D'],
            ],
            'bsit1b' => [
                ['2024-00106', 'GONZALES', 'ALYSSA', 'M'],
                ['2024-00107', 'HERNANDEZ', 'JOHN CARLO', 'T'],
                ['2024-00108', 'IGNACIO', 'BEA CLARISSE', 'V'],
                ['2024-00109', 'JIMENEZ', 'RAFAEL', 'C'],
                ['2024-00110', 'LACSON', 'TRISHA MAE', 'B'],
            ],
            'bsit2a' => [
                ['2023-00201', 'MENDOZA', 'GABRIEL', 'A'],
                ['2023-00202', 'NAVARRO', 'ISABELLE', 'F'],
                ['2023-00203', 'OCAMPO', 'LUIS MIGUEL', 'G'],
                ['2023-00204', 'PASCUAL', 'DENISE', 'H'],
                ['2023-00205', 'QUIAMBAO', 'ANDREI', 'J'],
                ['2023-00206', 'RAMOS', 'CAMILLE', 'K'],
            ],
            'jhs10' => [
                ['J24-5001', 'SALAZAR', 'MATTHEW', 'L'],
                ['J24-5002', 'TOLENTINO', 'ANGELA', 'M'],
                ['J24-5003', 'URBANO', 'KURT', 'N'],
                ['J24-5004', 'VALDEZ', 'JOANNA', 'P'],
                ['J24-5005', 'YAMBAO', 'ETHAN', 'Q'],
                ['J24-5006', 'ZAMORA', 'HANNAH', 'R'],
            ],
            'shs11' => [
                ['S24-6001', 'AGUILAR', 'NICOLE', 'S'],
                ['S24-6002', 'BALTAZAR', 'DREW', 'T'],
                ['S24-6003', 'CASTILLO', 'MIKAELA', 'U'],
                ['S24-6004', 'DOMINGO', 'JARED', 'V'],
                ['S24-6005', 'ENRIQUEZ', 'LIA', 'W'],
                ['S24-6006', 'FRANCISCO', 'BRYAN', 'X'],
            ],
        ];
    }

    private function createStudents(SchoolYear $year): void
    {
        $program = Program::firstOrCreate(
            ['code' => 'BSIT'],
            ['department_id' => Department::firstOrCreate(['name' => 'DEMO Information Technology'])->id],
        );

        $sections = [
            'bsit1a' => ['level' => 'college', 'program_id' => $program->id, 'year_or_grade' => 1, 'name' => '1A'],
            'bsit1b' => ['level' => 'college', 'program_id' => $program->id, 'year_or_grade' => 1, 'name' => '1B'],
            'bsit2a' => ['level' => 'college', 'program_id' => $program->id, 'year_or_grade' => 2, 'name' => '2A'],
            'jhs10' => ['level' => 'junior_high', 'program_id' => null, 'year_or_grade' => 10, 'name' => 'Venus'],
            'shs11' => ['level' => 'senior_high', 'program_id' => null, 'year_or_grade' => 11, 'name' => 'Moon'],
        ];

        foreach ($this->roster() as $key => $students) {
            $section = Section::firstOrCreate(['school_year_id' => $year->id] + $sections[$key]);

            foreach ($students as [$number, $last, $first, $middle]) {
                Student::firstOrCreate(
                    ['student_number' => $number],
                    ['last_name' => $last, 'first_name' => $first, 'middle_name' => $middle, 'section_id' => $section->id],
                );
            }
        }
    }

    private function createEvents(SchoolYear $year): void
    {
        $students = Student::query()
            ->where('enrollment_status', 'active')
            ->whereHas('section', fn ($section) => $section->where('school_year_id', $year->id))
            ->with('section')
            ->get();

        $guardUserId = User::query()->value('id');
        $now = SchoolClock::now();
        $today = SchoolClock::startOfDay();

        for ($back = self::DAYS - 1; $back >= 0; $back--) {
            $day = $today->copy()->subDays($back);

            foreach ($students as $student) {
                $schoolDays = config("verifigate.reports.school_days.{$student->section->level}", [1, 2, 3, 4, 5]);

                if (! in_array($day->dayOfWeekIso, $schoolDays, true) || mt_rand(1, 100) > 92) {
                    continue;
                }

                $arrival = $day->copy()->addMinutes(mt_rand(390, 510));   // 6:30am to 8:30am
                if ($arrival->gt($now)) {
                    continue;
                }

                $this->studentEntry($year, $student, $arrival, $day, $now, $guardUserId);
            }

            $this->visitorEntries($year, $day, $now, $guardUserId);
        }
    }

    private function studentEntry(
        SchoolYear $year,
        Student $student,
        CarbonInterface $arrival,
        CarbonInterface $day,
        CarbonInterface $now,
        ?int $guardUserId,
    ): void {
        $registrationCard = mt_rand(1, 100) <= 6;
        $roll = mt_rand(1, 100);

        $flags = $registrationCard ? [FlagReason::GuardManualFlag] : [];
        $uniform = 'compliant';
        $status = GateStatus::Approved;
        $byGuard = $registrationCard;

        if ($roll <= 9) {
            $flags[] = FlagReason::UniformNonCompliant;
            $uniform = 'non_compliant';
            $status = mt_rand(1, 100) <= 70 ? GateStatus::ApprovedFlaggedUniform : GateStatus::Flagged;
            $byGuard = true;
        } elseif ($roll <= 13) {
            $flags[] = FlagReason::UniformUnavailable;
            $uniform = 'unavailable';
            $status = GateStatus::ApprovedFlaggedUniform;
            $byGuard = true;
        }

        $decidedAt = $arrival->copy()->addSeconds($byGuard ? mt_rand(20, 90) : 2);

        $event = GateEvent::create([
            'school_year_id' => $year->id,
            'direction' => Direction::In,
            'person_type' => PersonType::Student,
            'student_id' => $student->id,
            'id_type' => self::MARKER,
            'status' => $status,
            'decided_by' => $byGuard ? DecidedBy::Guard : DecidedBy::System,
            'guard_user_id' => $byGuard ? $guardUserId : null,
            'verification_method' => $registrationCard ? VerificationMethod::RegistrationCard : VerificationMethod::OcrAuto,
            'scan_attempts' => 1,
            'ocr_confidence' => $registrationCard ? null : mt_rand(9200, 9900) / 100,
            'match_score' => $registrationCard ? null : mt_rand(9000, 10000) / 100,
            'uniform_status' => $uniform,
            'uniform_confidence' => $uniform === 'unavailable' ? null : mt_rand(8500, 9900) / 100,
            'scanned_at' => SchoolClock::forQuery($arrival),
            'decided_at' => SchoolClock::forQuery($decidedAt),
            'verify_ms' => mt_rand(600, 2400),
        ]);

        foreach ($flags as $flag) {
            $event->flags()->create(['reason' => $flag]);
        }

        if ($status === GateStatus::Flagged) {
            return;
        }

        // Most students leave in the afternoon; today's exits only if that time has passed
        $exit = $day->copy()->addMinutes(mt_rand(900, 1050));
        if ($exit->lte($now) && mt_rand(1, 100) <= 90) {
            GateEvent::create([
                'school_year_id' => $year->id,
                'direction' => Direction::Out,
                'person_type' => PersonType::Student,
                'student_id' => $student->id,
                'id_type' => self::MARKER,
                'status' => GateStatus::Approved,
                'decided_by' => DecidedBy::System,
                'paired_entry_id' => $event->id,
                'scanned_at' => SchoolClock::forQuery($exit),
                'decided_at' => SchoolClock::forQuery($exit),
            ]);
        }
    }

    private function visitorEntries(SchoolYear $year, CarbonInterface $day, CarbonInterface $now, ?int $guardUserId): void
    {
        if ($day->dayOfWeekIso === 7) {
            return;
        }

        $count = mt_rand(0, 3);
        for ($i = 0; $i < $count; $i++) {
            $time = $day->copy()->addMinutes(mt_rand(480, 900));   // 8:00am to 3:00pm
            if ($time->gt($now)) {
                continue;
            }

            $event = GateEvent::create([
                'school_year_id' => $year->id,
                'direction' => Direction::In,
                'person_type' => PersonType::Visitor,
                'visitor_name' => self::VISITORS[mt_rand(0, count(self::VISITORS) - 1)],
                'id_type' => self::MARKER,
                'status' => mt_rand(1, 100) <= 85 ? GateStatus::Approved : GateStatus::Flagged,
                'decided_by' => DecidedBy::Guard,
                'guard_user_id' => $guardUserId,
                'verification_method' => VerificationMethod::OcrAuto,
                'scan_attempts' => 1,
                'scanned_at' => SchoolClock::forQuery($time),
                'decided_at' => SchoolClock::forQuery($time->copy()->addSeconds(mt_rand(20, 90))),
            ]);
            $event->flags()->create(['reason' => FlagReason::VisitorReview]);
        }
    }
}
