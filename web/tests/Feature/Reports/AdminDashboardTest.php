<?php

use App\Models\Department;
use App\Models\Program;
use App\Models\SchoolYear;
use App\Models\Section;
use App\Models\Student;
use App\Models\User;
use Illuminate\Database\Eloquent\Model;
use Inertia\Testing\AssertableInertia as Assert;

beforeEach(function () {
    $this->withoutVite();

    config([
        'verifigate.reports.attendance_mode' => 'on_time',
        'verifigate.reports.mock.role' => 'faculty',
        'verifigate.reports.mock.admin' => ['name' => 'Ms. Schuyler', 'title' => 'Admin'],
        'verifigate.reports.mock.faculty' => ['name' => 'Sir Kyle', 'title' => 'Faculty', 'program' => 'BSIT', 'year' => 1],
    ]);
});

function adUser(): User
{
    return User::factory()->create();
}

it('sends guests to the login page', function () {
    $this->get('/dashboard/admin')->assertRedirect(route('login'));
});

it('sends /dashboard to the dashboard of the mock role', function () {
    $user = adUser();

    config(['verifigate.reports.mock.role' => 'admin']);
    $this->actingAs($user)->get('/dashboard')->assertRedirect('/dashboard/admin');

    config(['verifigate.reports.mock.role' => 'faculty']);
    $this->actingAs($user)->get('/dashboard')->assertRedirect('/dashboard/faculty');
});

it('renders the admin page with the school-wide data', function () {
    $this->actingAs(adUser())->get('/dashboard/admin')
        ->assertOk()
        ->assertInertia(fn (Assert $page) => $page
            ->component('reports/admin')
            ->where('viewer.name', 'Ms. Schuyler')
            ->where('viewer.role', 'admin')
            ->where('testControls', true)
            ->where('dashboard.period.key', 'weekly')
            ->where('dashboard.cards.present', 0)
            ->where('dashboard.extras.violations', 0)
            ->where('dashboard.extras.visitors', 0)
            ->where('dashboard.extras.reg_card_scans', 0)
            ->where('dashboard.event.active', false)
            ->has('dashboard.exceptions.rows', 3)
            ->has('dashboard.chart.series', 6)
            ->where('occupancy.total', 0)
            ->where('occupancy.jhs', 0)
            ->where('occupancy.shs', 0)
            ->where('occupancy.college', 0));
});

it('applies the same period and test-mode rules as the faculty page', function () {
    $user = adUser();

    $this->actingAs($user)->get('/dashboard/admin?period=monthly&mode=late')
        ->assertInertia(fn (Assert $page) => $page
            ->where('dashboard.period.key', 'monthly')
            ->where('dashboard.mode', 'late'));
    $this->actingAs($user)->get('/dashboard/admin?period=yearly&mode=nonsense')
        ->assertInertia(fn (Assert $page) => $page
            ->where('dashboard.period.key', 'weekly')
            ->where('dashboard.mode', 'on_time'));

    app()->detectEnvironment(fn () => 'production');

    $this->actingAs($user)->get('/dashboard/admin?mode=late')
        ->assertInertia(fn (Assert $page) => $page->where('dashboard.mode', 'on_time')->where('testControls', false));
});

it('reloads only the occupancy when the page polls', function () {
    $this->actingAs(adUser())->get('/dashboard/admin')
        ->assertInertia(fn (Assert $page) => $page
            ->component('reports/admin')
            ->reloadOnly('occupancy', fn (Assert $reload) => $reload
                ->has('occupancy.total')
                ->missing('dashboard')));
});

it('lists every student on the admin page but only the mock scope on the faculty page', function () {
    Model::unguarded(function () {
        $year = SchoolYear::create([
            'label' => '2026-2027 (TEST)', 'starts_on' => '2026-06-01',
            'ends_on' => '2027-03-31', 'is_current' => true,
        ]);
        $program = Program::create([
            'department_id' => Department::create(['name' => 'TEST DEPARTMENT'])->id, 'code' => 'BSIT',
        ]);
        $bsit1 = Section::create(['school_year_id' => $year->id, 'level' => 'college', 'program_id' => $program->id, 'year_or_grade' => 1, 'name' => '1A']);
        $jhs = Section::create(['school_year_id' => $year->id, 'level' => 'junior_high', 'year_or_grade' => 10, 'name' => 'Mercury']);

        Student::create(['student_number' => 'AD-0001', 'last_name' => 'ALCANTARA', 'first_name' => 'JOSHUA', 'section_id' => $bsit1->id, 'enrollment_status' => 'active']);
        Student::create(['student_number' => 'AD-0002', 'last_name' => 'CRUZ', 'first_name' => 'DANIEL', 'section_id' => $jhs->id, 'enrollment_status' => 'active']);
    });
    $user = adUser();

    $this->actingAs($user)->get('/dashboard/admin')
        ->assertInertia(fn (Assert $page) => $page->where('dashboard.records.total', 2));
    $this->actingAs($user)->get('/dashboard/faculty')
        ->assertInertia(fn (Assert $page) => $page->where('dashboard.records.total', 1));
});
