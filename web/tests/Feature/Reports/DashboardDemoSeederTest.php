<?php

use App\Enums\Reports\AttendanceMode;
use App\Enums\Reports\Period;
use App\Models\GateEvent;
use App\Services\Reports\DashboardReports;
use App\Services\Reports\ReportPeriod;
use App\Support\SchoolClock;
use Database\Seeders\DashboardDemoSeeder;

beforeEach(function () {
    config(['verifigate.reports.mock.faculty' => ['name' => 'Sir Kyle', 'title' => 'Faculty', 'program' => 'BSIT', 'year' => 1]]);
});

it('fills a past week with data for both dashboards', function () {
    $this->seed(DashboardDemoSeeder::class);

    $lastWeek = ReportPeriod::for(Period::Weekly, SchoolClock::now()->subWeek());
    $faculty = app(DashboardReports::class)->faculty($lastWeek, AttendanceMode::OnTime);
    $admin = app(DashboardReports::class)->admin($lastWeek, AttendanceMode::OnTime);

    expect($faculty['cards']['present'])->toBeGreaterThan(0)
        ->and($faculty['records']['total'])->toBe(5 + 5)
        ->and($faculty['chart']['total'])->toBeGreaterThan(0)
        ->and($admin['cards']['present'])->toBeGreaterThan($faculty['cards']['present'])
        ->and($admin['extras']['visitors'])->toBeGreaterThan(0)
        ->and($admin['extras']['reg_card_scans'])->toBeGreaterThan(0);
});

it('replaces its own events when it is run again', function () {
    $this->seed(DashboardDemoSeeder::class);
    $first = GateEvent::where('id_type', 'DEMO')->count();

    $this->seed(DashboardDemoSeeder::class);
    $second = GateEvent::where('id_type', 'DEMO')->count();

    expect($first)->toBeGreaterThan(0)->and($second)->toBeLessThan($first * 2);
});
