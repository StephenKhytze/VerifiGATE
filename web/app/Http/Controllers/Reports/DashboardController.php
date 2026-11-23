<?php

namespace App\Http\Controllers\Reports;

use App\Enums\Reports\AttendanceMode;
use App\Enums\Reports\Period;
use App\Http\Controllers\Controller;
use App\Services\Reports\DashboardReports;
use App\Services\Reports\ReportPeriod;
use Illuminate\Http\RedirectResponse;
use Illuminate\Http\Request;
use Inertia\Inertia;
use Inertia\Response;

class DashboardController extends Controller
{
    /** Where /dashboard sends people: the mock role until the accounts module defines real roles. */
    public function index(): RedirectResponse
    {
        return redirect()->route(
            config('verifigate.reports.mock.role') === 'admin' ? 'reports.admin' : 'reports.faculty'
        );
    }

    public function faculty(Request $request, DashboardReports $reports): Response
    {
        $period = ReportPeriod::for(Period::fromInput($this->queryString($request, 'period')));

        return Inertia::render('reports/faculty', [
            'viewer' => $this->viewer('faculty'),
            'dashboard' => $reports->faculty($period, $this->mode($request)),
            'testControls' => $this->testControlsEnabled(),
        ]);
    }

    public function admin(Request $request, DashboardReports $reports): Response
    {
        $period = ReportPeriod::for(Period::fromInput($this->queryString($request, 'period')));
        $mode = $this->mode($request);

        return Inertia::render('reports/admin', [
            'viewer' => $this->viewer('admin'),
            'testControls' => $this->testControlsEnabled(),
            // Closures are only evaluated when requested, so the 30-second occupancy poll
            // does not recompute the whole report.
            'dashboard' => fn () => $reports->admin($period, $mode),
            'occupancy' => fn () => $reports->occupancy(),
        ]);
    }

    public function print(Request $request, DashboardReports $reports, string $role): Response
    {
        $period = ReportPeriod::for(Period::fromInput($this->queryString($request, 'period')));

        return Inertia::render('reports/print', [
            'report' => $reports->printable($role, $period, $this->mode($request), $this->viewer($role)),
        ]);
    }

    /** The late toggle is a test control: it is ignored in production. */
    private function mode(Request $request): AttendanceMode
    {
        return $this->testControlsEnabled()
            ? AttendanceMode::fromInput($this->queryString($request, 'mode'))
            : AttendanceMode::fromConfig();
    }

    private function testControlsEnabled(): bool
    {
        return ! app()->isProduction();
    }

    /** A repeated or array parameter (?period[]=x) is treated as missing. */
    private function queryString(Request $request, string $key): ?string
    {
        $value = $request->query($key);

        return is_string($value) ? $value : null;
    }

    /** Stand-in identity until the accounts module defines roles. */
    private function viewer(string $role): array
    {
        $mock = config("verifigate.reports.mock.{$role}");

        return ['name' => $mock['name'], 'title' => $mock['title'], 'role' => $role];
    }
}
