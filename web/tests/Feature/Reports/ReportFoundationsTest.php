<?php

use App\Enums\Reports\Period;
use App\Models\Department;
use App\Models\Program;
use App\Models\SchoolYear;
use App\Models\Section;
use App\Models\Student;
use App\Services\Reports\MockFacultyStudentScope;
use App\Services\Reports\ReportPeriod;
use Carbon\CarbonImmutable;
use Illuminate\Database\Eloquent\Model;

beforeEach(function () {
    config(['app.timezone' => 'UTC', 'verifigate.reports.timezone' => 'Asia/Manila']);
});

function reportAt(string $manilaTime): CarbonImmutable
{
    return CarbonImmutable::parse($manilaTime, 'Asia/Manila');
}

it('uses the Manila day even when the UTC date is different', function () {
    $period = ReportPeriod::for(Period::Daily, reportAt('2026-11-22 02:00'));

    expect($period->start->format('Y-m-d H:i'))->toBe('2026-11-22 00:00')
        ->and($period->queryStart()->format('Y-m-d H:i'))->toBe('2026-11-21 16:00')
        ->and($period->queryEnd()->format('Y-m-d H:i'))->toBe('2026-11-22 16:00');
});

it('keeps working after app.timezone is switched to Manila', function () {
    config(['app.timezone' => 'Asia/Manila']);

    $period = ReportPeriod::for(Period::Daily, reportAt('2026-11-22 02:00'));

    expect($period->queryStart()->format('Y-m-d H:i'))->toBe('2026-11-22 00:00');
});

it('starts the week on Monday', function () {
    $sunday = ReportPeriod::for(Period::Weekly, reportAt('2026-11-22 10:00'));
    $monday = ReportPeriod::for(Period::Weekly, reportAt('2026-11-23 00:30'));

    expect($sunday->start->toDateString())->toBe('2026-11-16')
        ->and($sunday->end->toDateString())->toBe('2026-11-23')
        ->and($monday->start->toDateString())->toBe('2026-11-23');
});

it('covers the whole calendar month', function () {
    $november = ReportPeriod::for(Period::Monthly, reportAt('2026-11-22 10:00'));
    $leapFebruary = ReportPeriod::for(Period::Monthly, reportAt('2028-02-10 10:00'));

    expect($november->start->toDateString())->toBe('2026-11-01')
        ->and($november->end->toDateString())->toBe('2026-12-01')
        ->and($leapFebruary->end->toDateString())->toBe('2028-03-01');
});

it('builds chart buckets without Sundays', function () {
    expect(ReportPeriod::for(Period::Daily, reportAt('2026-11-23 09:00'))->buckets())->toHaveCount(24)
        ->and(ReportPeriod::for(Period::Weekly, reportAt('2026-11-23 09:00'))->buckets())->toHaveCount(6)
        ->and(ReportPeriod::for(Period::Monthly, reportAt('2026-11-23 09:00'))->buckets())->toHaveCount(25);
});

it('maps instants to buckets in Manila time', function () {
    $week = ReportPeriod::for(Period::Weekly, reportAt('2026-11-18 09:00'));

    expect($week->bucketKey(reportAt('2026-11-17 07:15')))->toBe('2026-11-17')
        ->and($week->bucketKey(reportAt('2026-11-22 08:00')))->toBeNull()
        ->and($week->bucketKey(reportAt('2026-11-23 00:00')))->toBeNull()
        ->and($week->bucketKey(reportAt('2026-11-15 23:59')))->toBeNull();

    $day = ReportPeriod::for(Period::Daily, reportAt('2026-11-23 12:00'));

    expect($day->bucketKey(reportAt('2026-11-23 00:10')))->toBe('00')
        ->and($day->bucketKey(reportAt('2026-11-23 07:59')))->toBe('07');
});

it('describes the period for the page', function () {
    $week = ReportPeriod::for(Period::Weekly, reportAt('2026-11-18 09:00'));

    expect($week->toArray())->toMatchArray([
        'key' => 'weekly', 'title' => 'Weekly Report', 'subtitle' => 'this week',
        'range' => 'Nov 16 – Nov 22, 2026',
    ]);
});

it('limits the mock faculty scope to active students of the configured program and year', function () {
    config(['verifigate.reports.mock.faculty' => ['program' => 'BSIT', 'year' => 1]]);

    [$bsit1, $bsit4, $jhs] = Model::unguarded(function () {
        $year = SchoolYear::create([
            'label' => '2026-2027 (TEST)', 'starts_on' => '2026-06-01',
            'ends_on' => '2027-03-31', 'is_current' => true,
        ]);
        $program = Program::create([
            'department_id' => Department::create(['name' => 'TEST DEPARTMENT'])->id, 'code' => 'BSIT',
        ]);

        return [
            Section::create(['school_year_id' => $year->id, 'level' => 'college', 'program_id' => $program->id, 'year_or_grade' => 1, 'name' => '1A']),
            Section::create(['school_year_id' => $year->id, 'level' => 'college', 'program_id' => $program->id, 'year_or_grade' => 4, 'name' => '4A']),
            Section::create(['school_year_id' => $year->id, 'level' => 'junior_high', 'year_or_grade' => 10, 'name' => 'Mercury']),
        ];
    });

    $make = fn (string $number, Section $section, string $status = 'active') => Model::unguarded(
        fn () => Student::create([
            'student_number' => $number, 'last_name' => 'TEST', 'first_name' => $number,
            'section_id' => $section->id, 'enrollment_status' => $status,
        ])
    );
    $make('T-IN-1', $bsit1);
    $make('T-IN-2', $bsit1);
    $make('T-INACTIVE', $bsit1, 'inactive');
    $make('T-YEAR4', $bsit4);
    $make('T-JHS', $jhs);

    $numbers = (new MockFacultyStudentScope)->students()->pluck('student_number')->sort()->values()->all();

    expect($numbers)->toBe(['T-IN-1', 'T-IN-2']);
});
