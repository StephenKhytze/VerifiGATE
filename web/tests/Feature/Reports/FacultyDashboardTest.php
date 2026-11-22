<?php

use App\Enums\Gate\DecidedBy;
use App\Enums\Gate\Direction;
use App\Enums\Gate\GateStatus;
use App\Enums\Gate\PersonType;
use App\Models\Department;
use App\Models\GateEvent;
use App\Models\Program;
use App\Models\SchoolYear;
use App\Models\Section;
use App\Models\Student;
use App\Models\User;
use Illuminate\Database\Eloquent\Model;
use Inertia\Testing\AssertableInertia as Assert;

beforeEach(function () {
    config([
        'verifigate.reports.attendance_mode' => 'on_time',
        'verifigate.reports.mock.faculty' => ['name' => 'Sir Kyle', 'title' => 'Faculty', 'program' => 'BSIT', 'year' => 1],
    ]);
});

function fdUser(): User
{
    return User::factory()->create();
}

it('sends guests to the login page', function () {
    $this->get('/dashboard/faculty')->assertRedirect(route('login'));
});

it('redirects /dashboard to the faculty dashboard', function () {
    $this->actingAs(fdUser())->get('/dashboard')->assertRedirect('/dashboard/faculty');
});

it('renders the faculty page with the weekly report by default', function () {
    $this->actingAs(fdUser())->get('/dashboard/faculty')
        ->assertOk()
        ->assertInertia(fn (Assert $page) => $page
            ->component('reports/faculty')
            ->where('viewer.name', 'Sir Kyle')
            ->where('viewer.role', 'faculty')
            ->where('dashboard.period.key', 'weekly')
            ->where('dashboard.mode', 'on_time')
            ->where('dashboard.cards.present', 0)
            ->where('dashboard.records.total', 0)
            ->has('dashboard.chart.series', 6)
            ->where('testControls', true));
});

it('honours the period in the URL and falls back to weekly for bad input', function () {
    $user = fdUser();

    $this->actingAs($user)->get('/dashboard/faculty?period=daily')
        ->assertInertia(fn (Assert $page) => $page->where('dashboard.period.key', 'daily')->has('dashboard.chart.series', 24));
    $this->actingAs($user)->get('/dashboard/faculty?period=monthly')
        ->assertInertia(fn (Assert $page) => $page->where('dashboard.period.key', 'monthly'));
    $this->actingAs($user)->get('/dashboard/faculty?period=yearly')
        ->assertInertia(fn (Assert $page) => $page->where('dashboard.period.key', 'weekly'));
    $this->actingAs($user)->get('/dashboard/faculty?period[]=daily')
        ->assertInertia(fn (Assert $page) => $page->where('dashboard.period.key', 'weekly'));
});

it('honours the test mode outside production only', function () {
    $user = fdUser();

    $this->actingAs($user)->get('/dashboard/faculty?mode=late')
        ->assertInertia(fn (Assert $page) => $page->where('dashboard.mode', 'late')->where('testControls', true));

    app()->detectEnvironment(fn () => 'production');

    $this->actingAs($user)->get('/dashboard/faculty?mode=late')
        ->assertInertia(fn (Assert $page) => $page->where('dashboard.mode', 'on_time')->where('testControls', false));
});

it('shows only the students of the mock faculty scope', function () {
    [$bsit1, $jhs] = Model::unguarded(function () {
        $year = SchoolYear::create([
            'label' => '2026-2027 (TEST)', 'starts_on' => '2026-06-01',
            'ends_on' => '2027-03-31', 'is_current' => true,
        ]);
        $program = Program::create([
            'department_id' => Department::create(['name' => 'TEST DEPARTMENT'])->id, 'code' => 'BSIT',
        ]);

        return [
            Section::create(['school_year_id' => $year->id, 'level' => 'college', 'program_id' => $program->id, 'year_or_grade' => 1, 'name' => '1A']),
            Section::create(['school_year_id' => $year->id, 'level' => 'junior_high', 'year_or_grade' => 10, 'name' => 'Mercury']),
        ];
    });

    $mine = Model::unguarded(fn () => Student::create([
        'student_number' => 'FD-0001', 'last_name' => 'ALCANTARA', 'first_name' => 'JOSHUA',
        'section_id' => $bsit1->id, 'enrollment_status' => 'active',
    ]));
    $other = Model::unguarded(fn () => Student::create([
        'student_number' => 'FD-0002', 'last_name' => 'CRUZ', 'first_name' => 'DANIEL',
        'section_id' => $jhs->id, 'enrollment_status' => 'active',
    ]));

    $monday = now('Asia/Manila')->startOfWeek()->addHours(7)->setTimezone(config('app.timezone'));
    foreach ([$mine, $other] as $student) {
        GateEvent::create([
            'school_year_id' => $bsit1->school_year_id, 'direction' => Direction::In,
            'person_type' => PersonType::Student, 'student_id' => $student->id,
            'status' => GateStatus::Approved, 'decided_by' => DecidedBy::System,
            'decided_at' => $monday, 'scanned_at' => $monday,
        ]);
    }

    $this->actingAs(fdUser())->get('/dashboard/faculty')
        ->assertInertia(fn (Assert $page) => $page
            ->where('dashboard.cards.present', 1)
            ->where('dashboard.records.total', 1)
            ->where('dashboard.records.rows.0.name', 'ALCANTARA, JOSHUA')
            ->where('dashboard.records.rows.0.present', 1));
});
