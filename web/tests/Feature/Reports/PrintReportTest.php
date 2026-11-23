<?php

use App\Enums\Gate\DecidedBy;
use App\Enums\Gate\Direction;
use App\Enums\Gate\FlagReason;
use App\Enums\Gate\GateStatus;
use App\Enums\Gate\PersonType;
use App\Models\Department;
use App\Models\GateEvent;
use App\Models\Program;
use App\Models\SchoolYear;
use App\Models\Section;
use App\Models\Student;
use App\Models\User;
use Carbon\CarbonInterface;
use Illuminate\Database\Eloquent\Model;
use Inertia\Testing\AssertableInertia as Assert;

beforeEach(function () {
    $this->withoutVite();

    config([
        'verifigate.reports.attendance_mode' => 'on_time',
        'verifigate.reports.mock.admin' => ['name' => 'Ms. Schuyler', 'title' => 'Admin'],
        'verifigate.reports.mock.faculty' => ['name' => 'Sir Kyle', 'title' => 'Faculty', 'program' => 'BSIT', 'year' => 1],
    ]);
});

function prtWorld(): array
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
            'section' => Section::create(['school_year_id' => $year->id, 'level' => 'college', 'program_id' => $program->id, 'year_or_grade' => 1, 'name' => '1A']),
        ];
    });
}

/** A student with one flagged, approved entry on each of the first $days days of this week (Mon to Sat). */
function prtViolator(array $world, string $last, int $days, FlagReason $reason = FlagReason::UniformNonCompliant): Student
{
    static $n = 0;
    $n++;

    $student = Model::unguarded(fn () => Student::create([
        'student_number' => sprintf('PR-%04d', $n), 'last_name' => $last, 'first_name' => 'TEST',
        'section_id' => $world['section']->id, 'enrollment_status' => 'active',
    ]));

    for ($i = 0; $i < $days; $i++) {
        $at = now('Asia/Manila')->startOfWeek(CarbonInterface::MONDAY)->addDays($i)->addHours(7)
            ->setTimezone(config('app.timezone'));

        $event = GateEvent::create([
            'school_year_id' => $world['sy']->id, 'direction' => Direction::In,
            'person_type' => PersonType::Student, 'student_id' => $student->id,
            'status' => GateStatus::Approved, 'decided_by' => DecidedBy::System,
            'decided_at' => $at, 'scanned_at' => $at,
        ]);
        $event->flags()->create(['reason' => $reason]);
    }

    return $student;
}

it('sends guests to the login page', function () {
    $this->get('/dashboard/admin/print')->assertRedirect(route('login'));
});

it('only prints for the known roles', function () {
    $this->actingAs(User::factory()->create())->get('/dashboard/guard/print')->assertNotFound();
});

it('prints the faculty report for the mock faculty scope', function () {
    $this->actingAs(User::factory()->create())->get('/dashboard/faculty/print')
        ->assertOk()
        ->assertInertia(fn (Assert $page) => $page
            ->component('reports/print')
            ->where('report.organization', 'Laguna College')
            ->where('report.title', 'Faculty Dashboard Report')
            ->where('report.scope', 'BSIT Year 1 students')
            ->where('report.prepared_by.name', 'Sir Kyle')
            ->where('report.prepared_by.title', 'Faculty')
            ->where('report.period.key', 'weekly')
            ->where('report.mode_note', null)
            ->has('report.generated_at')
            ->has('report.chart.series', 6)
            ->missing('report.occupancy')
            ->missing('report.extras'));
});

it('prints the admin report with the school-wide counts', function () {
    $this->actingAs(User::factory()->create())->get('/dashboard/admin/print?period=monthly')
        ->assertInertia(fn (Assert $page) => $page
            ->where('report.title', 'Admin Dashboard Report')
            ->where('report.scope', 'All students')
            ->where('report.prepared_by.name', 'Ms. Schuyler')
            ->where('report.period.key', 'monthly')
            ->has('report.occupancy.total')
            ->has('report.extras.visitors')
            ->has('report.extras.reg_card_scans')
            ->has('report.extras.violations'));
});

it('leaves out mock data and the hard-coded panels', function () {
    $this->actingAs(User::factory()->create())->get('/dashboard/admin/print')
        ->assertInertia(fn (Assert $page) => $page
            ->missing('report.cards.absent')
            ->missing('report.absent_is_mock')
            ->missing('report.event')
            ->missing('report.exceptions'));
});

it('notes the late test mode on the report', function () {
    $this->actingAs(User::factory()->create())->get('/dashboard/faculty/print?mode=late')
        ->assertInertia(fn (Assert $page) => $page
            ->where('report.mode_note', 'Test mode: every entry is counted as Late.'));
});

it('lists the ten students with the most violations, most first', function () {
    $world = prtWorld();
    foreach ([6, 6, 5, 5, 4, 4, 3, 3, 2, 2, 1, 1] as $index => $days) {
        prtViolator($world, sprintf('S%02d', $index + 1), $days);
    }
    prtViolator($world, 'ZZ', 3, FlagReason::UniformUnavailable);

    $this->actingAs(User::factory()->create())->get('/dashboard/admin/print')
        ->assertInertia(fn (Assert $page) => $page
            ->where('report.violators.limit', 10)
            ->where('report.violators.with_violations', 12)
            ->has('report.violators.rows', 10)
            ->where('report.violators.rows.0.name', 'S01, TEST')
            ->where('report.violators.rows.0.violations', 6)
            ->where('report.violators.rows.0.present', 6)
            ->where('report.violators.rows.0.late', 0)
            ->where('report.violators.rows.1.name', 'S02, TEST')
            ->where('report.violators.rows.9.name', 'S10, TEST')
            ->where('report.violators.rows.9.violations', 2)
            ->where('report.violators.rows', fn ($rows) => $rows->pluck('name')->doesntContain('S11, TEST')
                && $rows->pluck('name')->doesntContain('ZZ, TEST'))
            ->where('report.chart.total', 38));
});

it('shows no violators when nobody has a violation', function () {
    $world = prtWorld();
    prtViolator($world, 'CLEAN', 2, FlagReason::UniformLowConfidence);

    $this->actingAs(User::factory()->create())->get('/dashboard/admin/print')
        ->assertInertia(fn (Assert $page) => $page
            ->where('report.violators.with_violations', 0)
            ->has('report.violators.rows', 0));
});
