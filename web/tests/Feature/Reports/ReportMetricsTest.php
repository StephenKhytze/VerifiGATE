<?php

use App\Enums\Gate\DecidedBy;
use App\Enums\Gate\Direction;
use App\Enums\Gate\FlagReason;
use App\Enums\Gate\GateStatus;
use App\Enums\Gate\PersonType;
use App\Enums\Gate\VerificationMethod;
use App\Enums\Reports\AttendanceMode;
use App\Enums\Reports\Period;
use App\Models\Department;
use App\Models\GateEvent;
use App\Models\Program;
use App\Models\SchoolYear;
use App\Models\Section;
use App\Models\Student;
use App\Services\Reports\AdminStudentScope;
use App\Services\Reports\AttendanceReport;
use App\Services\Reports\CampusReport;
use App\Services\Reports\DashboardReports;
use App\Services\Reports\IncidentReport;
use App\Services\Reports\PlaceholderPanels;
use App\Services\Reports\ReportPeriod;
use Carbon\CarbonImmutable;
use Illuminate\Database\Eloquent\Model;

beforeEach(function () {
    config([
        'app.timezone' => 'UTC',
        'verifigate.reports.timezone' => 'Asia/Manila',
        'verifigate.reports.incident_flags' => ['uniform_non_compliant'],
        'verifigate.reports.mock.faculty' => ['name' => 'Sir Kyle', 'title' => 'Faculty', 'program' => 'BSIT', 'year' => 1],
    ]);
});

/* ---------- helpers (prefixed rpt* to avoid clashes with other test files) ---------- */

function rptTime(string $manila): CarbonImmutable
{
    return CarbonImmutable::parse($manila, 'Asia/Manila');
}

/** The instant in the timezone the database columns use. */
function rptDb(string $manila): CarbonImmutable
{
    return rptTime($manila)->setTimezone(config('app.timezone'));
}

function rptWeek(): ReportPeriod
{
    return ReportPeriod::for(Period::Weekly, rptTime('2026-11-25 09:00'));   // Mon Nov 23 to Sun Nov 29
}

function rptEveryone()
{
    return (new AdminStudentScope)->students();
}

function rptWorld(): array
{
    return Model::unguarded(function () {
        $year = SchoolYear::create([
            'label' => '2026-2027 (TEST)', 'starts_on' => '2026-06-01',
            'ends_on' => '2027-03-31', 'is_current' => true,
        ]);
        $program = Program::create([
            'department_id' => Department::create(['name' => 'TEST DEPARTMENT'])->id, 'code' => 'BSIT',
        ]);

        return [
            'sy' => $year,
            'jhs' => Section::create(['school_year_id' => $year->id, 'level' => 'junior_high', 'year_or_grade' => 10, 'name' => 'Mercury']),
            'shs' => Section::create(['school_year_id' => $year->id, 'level' => 'senior_high', 'year_or_grade' => 11, 'name' => 'Sun']),
            'college' => Section::create(['school_year_id' => $year->id, 'level' => 'college', 'program_id' => $program->id, 'year_or_grade' => 1, 'name' => '1A']),
        ];
    });
}

function rptStudent(Section $section, string $last = 'TEST', ?string $first = null): Student
{
    static $n = 0;
    $n++;

    return Model::unguarded(fn () => Student::create([
        'student_number' => sprintf('R24-%04d', $n),
        'last_name' => $last, 'first_name' => $first ?? "STUDENT{$n}",
        'section_id' => $section->id, 'enrollment_status' => 'active',
    ]));
}

/** An approved student entry by default; override any attribute. */
function rptEvent(array $world, string $manilaTime, array $attrs = []): GateEvent
{
    return GateEvent::create(array_merge([
        'school_year_id' => $world['sy']->id,
        'direction' => Direction::In,
        'person_type' => PersonType::Student,
        'status' => GateStatus::Approved,
        'decided_by' => DecidedBy::System,
        'decided_at' => rptDb($manilaTime),
        'scanned_at' => rptDb($manilaTime),
    ], $attrs));
}

function rptEntry(array $world, Student $student, string $manilaTime, array $attrs = []): GateEvent
{
    return rptEvent($world, $manilaTime, array_merge(['student_id' => $student->id], $attrs));
}

function rptPending(): array
{
    return ['status' => GateStatus::Pending, 'decided_by' => null, 'decided_at' => null];
}

function rptFlag(GateEvent $event, FlagReason $reason = FlagReason::UniformNonCompliant): GateEvent
{
    $event->flags()->create(['reason' => $reason]);

    return $event;
}

function rptVisitor(array $world, string $manilaTime, array $attrs = []): GateEvent
{
    return rptEvent($world, $manilaTime, array_merge(
        ['person_type' => PersonType::Visitor, 'visitor_name' => 'JANE VISITOR'], $attrs
    ));
}

/** BSIT year 1: ALCANTARA and BAUTISTA. Grade 10: CRUZ. */
function rptSeedWeek(array $world): array
{
    $a = rptStudent($world['college'], 'ALCANTARA', 'JOSHUA');
    $b = rptStudent($world['college'], 'BAUTISTA', 'MARIA');
    $c = rptStudent($world['jhs'], 'CRUZ', 'DANIEL');

    $aMonday = rptEntry($world, $a, '2026-11-23 07:00');
    rptEntry($world, $a, '2026-11-24 07:00');
    rptEntry($world, $b, '2026-11-23 07:00');
    $cMonday = rptEntry($world, $c, '2026-11-23 07:00', ['verification_method' => VerificationMethod::RegistrationCard]);
    rptFlag($aMonday);
    rptFlag($cMonday);
    rptVisitor($world, '2026-11-24 10:00');

    return compact('a', 'b', 'c');
}

/* ---------- attendance ---------- */

it('counts each school day once as Present, however many entries there are', function () {
    $w = rptWorld();
    $student = rptStudent($w['college']);
    rptEntry($w, $student, '2026-11-23 07:00');
    rptEntry($w, $student, '2026-11-23 13:00');
    rptEntry($w, $student, '2026-11-24 07:05');

    $totals = app(AttendanceReport::class)->totals(rptEveryone(), rptWeek(), AttendanceMode::OnTime);

    expect($totals['present'])->toBe(2)->and($totals['late'])->toBe(0);
});

it('moves every entry to Late when the toggle says late', function () {
    $w = rptWorld();
    $student = rptStudent($w['college']);
    rptEntry($w, $student, '2026-11-23 07:00');
    rptEntry($w, $student, '2026-11-24 07:05');

    $totals = app(AttendanceReport::class)->totals(rptEveryone(), rptWeek(), AttendanceMode::Late);

    expect($totals['present'])->toBe(0)->and($totals['late'])->toBe(2);
});

it('counts only approved student entries', function () {
    $w = rptWorld();
    $student = rptStudent($w['college']);
    rptEntry($w, $student, '2026-11-23 07:00', rptPending());
    rptEntry($w, $student, '2026-11-24 07:00', ['status' => GateStatus::Flagged]);
    rptEntry($w, $student, '2026-11-26 15:00', ['direction' => Direction::Out]);
    rptVisitor($w, '2026-11-25 07:00');
    rptEntry($w, $student, '2026-11-27 07:00', ['status' => GateStatus::ApprovedFlaggedUniform]);

    $totals = app(AttendanceReport::class)->totals(rptEveryone(), rptWeek(), AttendanceMode::OnTime);

    expect($totals['present'])->toBe(1);
});

it('counts only the school days of each level', function () {
    $w = rptWorld();
    $jhs = rptStudent($w['jhs']);
    $college = rptStudent($w['college']);
    rptEntry($w, $jhs, '2026-11-27 07:00');
    rptEntry($w, $jhs, '2026-11-28 07:00');
    rptEntry($w, $college, '2026-11-28 07:00');
    rptEntry($w, $college, '2026-11-29 07:00');

    $totals = app(AttendanceReport::class)->totals(rptEveryone(), rptWeek(), AttendanceMode::OnTime);

    expect($totals['present'])->toBe(2);
});

it('uses Manila day boundaries, not UTC ones', function () {
    $w = rptWorld();
    $period = ReportPeriod::for(Period::Daily, rptTime('2026-11-24 12:00'));
    rptEntry($w, rptStudent($w['college']), '2026-11-24 00:10');
    rptEntry($w, rptStudent($w['college']), '2026-11-24 23:59');
    rptEntry($w, rptStudent($w['college']), '2026-11-23 23:50');
    rptEntry($w, rptStudent($w['college']), '2026-11-25 00:01');

    $totals = app(AttendanceReport::class)->totals(rptEveryone(), $period, AttendanceMode::OnTime);

    expect($totals['present'])->toBe(2);
});

it('counts only the students in the scope it is given', function () {
    $w = rptWorld();
    $inScope = rptStudent($w['college']);
    $outOfScope = rptStudent($w['college']);
    rptEntry($w, $inScope, '2026-11-23 07:00');
    rptEntry($w, $outOfScope, '2026-11-23 07:00');

    $totals = app(AttendanceReport::class)->totals(
        Student::query()->whereKey($inScope->id), rptWeek(), AttendanceMode::OnTime
    );

    expect($totals['present'])->toBe(1);
});

it('lists students alphabetically with their own counts', function () {
    $w = rptWorld();
    $zamora = rptStudent($w['college'], 'ZAMORA', 'ZED');
    $alcantara = rptStudent($w['college'], 'ALCANTARA', 'JOSHUA');
    $bautista = rptStudent($w['college'], 'BAUTISTA', 'MARIA');
    rptStudent($w['college'], 'CRUZ', 'DANIEL');
    rptEntry($w, $alcantara, '2026-11-23 07:00');
    rptEntry($w, $alcantara, '2026-11-24 07:00');
    rptEntry($w, $bautista, '2026-11-23 07:00');
    rptEntry($w, $zamora, '2026-11-23 07:00');

    $records = app(AttendanceReport::class)->records(rptEveryone(), rptWeek(), AttendanceMode::OnTime, 3);

    expect($records['total'])->toBe(4)
        ->and(array_column($records['rows'], 'name'))->toBe(['ALCANTARA, JOSHUA', 'BAUTISTA, MARIA', 'CRUZ, DANIEL'])
        ->and(array_column($records['rows'], 'present'))->toBe([2, 1, 0]);
});

it('gives stable mock absences that add up to the card', function () {
    $w = rptWorld();
    foreach (range(1, 6) as $ignored) {
        rptStudent($w['college']);
    }
    $report = app(AttendanceReport::class);

    $first = $report->totals(rptEveryone(), rptWeek(), AttendanceMode::OnTime)['absent'];
    $second = $report->totals(rptEveryone(), rptWeek(), AttendanceMode::OnTime)['absent'];
    $rows = $report->records(rptEveryone(), rptWeek(), AttendanceMode::OnTime, 50)['rows'];

    expect($second)->toBe($first)
        ->and(array_sum(array_column($rows, 'absent')))->toBe($first);
});

/* ---------- incidents ---------- */

it('counts a non-compliant uniform once per student per day, whatever the outcome', function () {
    $w = rptWorld();
    $a = rptStudent($w['college']);
    $b = rptStudent($w['college']);
    rptFlag(rptEntry($w, $a, '2026-11-23 07:00', ['status' => GateStatus::Flagged]));
    rptFlag(rptEntry($w, $a, '2026-11-23 07:30', rptPending()));
    rptFlag(rptEntry($w, $a, '2026-11-24 07:00', ['status' => GateStatus::ApprovedFlaggedUniform]));
    rptFlag(rptEntry($w, $b, '2026-11-23 08:00'));

    $result = app(IncidentReport::class)->series(rptEveryone(), rptWeek());

    expect($result['total'])->toBe(3)
        ->and(array_column($result['series'], 'value'))->toBe([2, 1, 0, 0, 0, 0])
        ->and(array_column($result['series'], 'label'))->toBe(['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat']);
});

it('ignores other flag reasons and anyone who is not a student', function () {
    $w = rptWorld();
    $student = rptStudent($w['college']);
    rptFlag(rptEntry($w, $student, '2026-11-23 07:00'), FlagReason::UniformUnavailable);
    rptFlag(rptEntry($w, $student, '2026-11-24 07:00'), FlagReason::UniformLowConfidence);
    rptFlag(rptVisitor($w, '2026-11-25 07:00'));

    $result = app(IncidentReport::class)->series(rptEveryone(), rptWeek());

    expect($result['total'])->toBe(0);
});

it('puts a daily incident in the hour of the earliest flagged entry', function () {
    $w = rptWorld();
    $student = rptStudent($w['college']);
    rptFlag(rptEntry($w, $student, '2026-11-23 09:40'));
    rptFlag(rptEntry($w, $student, '2026-11-23 07:10'));

    $result = app(IncidentReport::class)->series(
        rptEveryone(), ReportPeriod::for(Period::Daily, rptTime('2026-11-23 12:00'))
    );

    expect($result['series'])->toHaveCount(24)
        ->and($result['series'][7]['value'])->toBe(1)
        ->and($result['series'][9]['value'])->toBe(0)
        ->and($result['total'])->toBe(1);
});

it('drops incidents on Sundays and outside the scope', function () {
    $w = rptWorld();
    $inScope = rptStudent($w['college']);
    $outOfScope = rptStudent($w['college']);
    rptFlag(rptEntry($w, $inScope, '2026-11-29 07:00'));
    rptFlag(rptEntry($w, $inScope, '2026-11-23 07:00'));
    rptFlag(rptEntry($w, $outOfScope, '2026-11-23 07:00'));

    $result = app(IncidentReport::class)->series(Student::query()->whereKey($inScope->id), rptWeek());

    expect($result['total'])->toBe(1);
});

/* ---------- campus ---------- */

it('counts students currently inside by level, without exits or other people', function () {
    $w = rptWorld();
    $at = rptTime('2026-11-23 10:00');
    $jhs = rptStudent($w['jhs']);
    $shs = rptStudent($w['shs']);
    $left = rptStudent($w['college']);
    $yesterday = rptStudent($w['college']);
    $pending = rptStudent($w['college']);

    rptEntry($w, $jhs, '2026-11-23 07:00');
    rptEntry($w, $shs, '2026-11-23 07:00');
    rptEntry($w, $shs, '2026-11-23 08:00');
    $entry = rptEntry($w, $left, '2026-11-23 07:00');
    rptEntry($w, $left, '2026-11-23 09:00', ['direction' => Direction::Out, 'paired_entry_id' => $entry->id]);
    rptEntry($w, $yesterday, '2026-11-22 23:00');
    rptEntry($w, $pending, '2026-11-23 07:00', rptPending());
    rptVisitor($w, '2026-11-23 07:00');

    $inside = app(CampusReport::class)->currentlyInside($at);

    expect($inside)->toBe(['total' => 2, 'jhs' => 1, 'shs' => 1, 'college' => 0]);
});

it('counts only approved visitor entries in the period', function () {
    $w = rptWorld();
    rptVisitor($w, '2026-11-24 09:00');
    rptVisitor($w, '2026-11-25 09:00', rptPending());
    rptVisitor($w, '2026-11-26 09:00', ['status' => GateStatus::Flagged]);
    rptVisitor($w, '2026-11-17 09:00');
    rptEntry($w, rptStudent($w['college']), '2026-11-24 09:00');

    expect(app(CampusReport::class)->visitors(rptWeek()))->toBe(1);
});

it('counts registration-card entries per student per day', function () {
    $w = rptWorld();
    $a = rptStudent($w['college']);
    $b = rptStudent($w['college']);
    $card = ['verification_method' => VerificationMethod::RegistrationCard];
    rptEntry($w, $a, '2026-11-23 07:00', $card);
    rptEntry($w, $a, '2026-11-23 13:00', $card);
    rptEntry($w, $a, '2026-11-24 07:00', $card);
    rptEntry($w, $b, '2026-11-23 07:00');
    rptEntry($w, $b, '2026-11-24 07:00', $card + rptPending());
    rptEntry($w, $b, '2026-11-17 07:00', $card);

    expect(app(CampusReport::class)->registrationCardScans(rptWeek()))->toBe(2);
});

it('shows no active event and three sample exception rows', function () {
    $panels = new PlaceholderPanels;

    expect($panels->eventStatus()['active'])->toBeFalse()
        ->and(array_column($panels->uniformExceptions(), 'label'))
        ->toBe(['PE 114', 'ITE Acquaintance Party', 'CE 112']);
});

/* ---------- assembled page data ---------- */

it('builds the faculty page data from the mock scope only', function () {
    $w = rptWorld();
    rptSeedWeek($w);

    $data = app(DashboardReports::class)->faculty(rptWeek(), AttendanceMode::OnTime);

    expect($data['period']['key'])->toBe('weekly')
        ->and($data['mode'])->toBe('on_time')
        ->and($data['cards']['present'])->toBe(3)
        ->and($data['cards']['late'])->toBe(0)
        ->and($data['absent_is_mock'])->toBeTrue()
        ->and($data['chart']['legend'])->toBe('Incidents')
        ->and($data['chart']['total'])->toBe(1)
        ->and($data['records']['total'])->toBe(2)
        ->and(array_column($data['records']['rows'], 'name'))->toBe(['ALCANTARA, JOSHUA', 'BAUTISTA, MARIA']);
});

it('builds the admin page data for the whole school', function () {
    $w = rptWorld();
    rptSeedWeek($w);

    $data = app(DashboardReports::class)->admin(rptWeek(), AttendanceMode::OnTime);

    expect($data['cards']['present'])->toBe(4)
        ->and($data['chart']['total'])->toBe(2)
        ->and($data['extras'])->toBe(['violations' => 2, 'visitors' => 1, 'reg_card_scans' => 1])
        ->and($data['occupancy'])->toHaveKeys(['total', 'jhs', 'shs', 'college'])
        ->and($data['event']['active'])->toBeFalse()
        ->and($data['exceptions']['rows'])->toHaveCount(3)
        ->and($data['exceptions']['date'])->not->toBeEmpty()
        ->and($data['records']['total'])->toBe(3);
});
