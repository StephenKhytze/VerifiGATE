import { Head, router, usePoll } from '@inertiajs/react';
import { useState } from 'react';
import { GREEN, INK, ORANGE, RED } from '@/components/reports/colors';
import EventStatusCard from '@/components/reports/event-status-card';
import ExportButton from '@/components/reports/export-button';
import IncidentsChart from '@/components/reports/incidents-chart';
import ModeToggle from '@/components/reports/mode-toggle';
import OccupancyCard from '@/components/reports/occupancy-card';
import PeriodSelect from '@/components/reports/period-select';
import RecordListCard from '@/components/reports/record-list-card';
import StatCard from '@/components/reports/stat-card';
import UniformExceptionsCard from '@/components/reports/uniform-exceptions-card';
import ViewAsSwitch from '@/components/reports/view-as-switch';
import type {
    AdminDashboardData,
    AttendanceMode,
    Occupancy,
    PeriodKey,
} from '@/types/reports';

type Props = {
    dashboard: AdminDashboardData;
    occupancy: Occupancy;
    testControls: boolean;
};

export default function AdminDashboard({
    dashboard,
    occupancy,
    testControls,
}: Props) {
    const [loading, setLoading] = useState(false);
    const { period, cards, chart, records, extras, event, exceptions } =
        dashboard;

    usePoll(30000, { only: ['occupancy'] });

    function visit(next: { period?: PeriodKey; mode?: AttendanceMode }) {
        router.get(
            '/dashboard/admin',
            {
                period: next.period ?? period.key,
                mode: next.mode ?? dashboard.mode,
            },
            {
                only: ['dashboard'],
                preserveScroll: true,
                preserveState: true,
                replace: true,
                onStart: () => setLoading(true),
                onFinish: () => setLoading(false),
            },
        );
    }

    return (
        <>
            <Head title="Admin Dashboard" />

            <div className="flex flex-wrap items-center justify-between gap-4">
                <h1 className="text-3xl font-bold">
                    Admin Dashboard - {exceptions.date}
                </h1>
                <div className="flex flex-wrap items-center gap-4">
                    {testControls && (
                        <ViewAsSwitch
                            role="admin"
                            period={period.key}
                            mode={dashboard.mode}
                        />
                    )}
                    {testControls && (
                        <ModeToggle
                            value={dashboard.mode}
                            disabled={loading}
                            onChange={(mode) => visit({ mode })}
                        />
                    )}
                    <PeriodSelect
                        value={period.key}
                        disabled={loading}
                        onChange={(key) => visit({ period: key })}
                    />
                </div>
            </div>

            <div
                className="mt-6 space-y-6 transition-opacity"
                style={{ opacity: loading ? 0.6 : 1 }}
                aria-busy={loading}
            >
                <OccupancyCard occupancy={occupancy} />

                <div className="grid gap-5 md:grid-cols-3">
                    <StatCard
                        title="Uniform Violations"
                        subtitle={period.subtitle}
                        value={extras.violations}
                        color={INK}
                    />
                    <StatCard
                        title="Visitors"
                        subtitle={period.subtitle}
                        value={extras.visitors}
                        color={INK}
                    />
                    <StatCard
                        title="Reg. Card Scans"
                        subtitle={period.subtitle}
                        value={extras.reg_card_scans}
                        color={INK}
                    />
                </div>

                <hr className="border-neutral-300" />

                <div className="grid gap-5 md:grid-cols-3">
                    <StatCard
                        title="Present Students"
                        subtitle={period.subtitle}
                        value={cards.present}
                        color={GREEN}
                    />
                    <StatCard
                        title="Absent Students"
                        subtitle={period.subtitle}
                        value={cards.absent}
                        color={RED}
                        sample={dashboard.absent_is_mock}
                    />
                    <StatCard
                        title="Late Students"
                        subtitle={period.subtitle}
                        value={cards.late}
                        color={ORANGE}
                    />
                </div>

                <hr className="border-neutral-300" />

                <section className="rounded-2xl border border-neutral-300 bg-white p-8">
                    <div className="flex flex-wrap items-baseline justify-between gap-2">
                        <h2 className="text-2xl font-semibold">
                            {period.title}
                        </h2>
                        <span className="text-lg text-neutral-500">
                            {period.range}
                        </span>
                    </div>
                    <div className="mt-4">
                        <IncidentsChart
                            series={chart.series}
                            legend={chart.legend}
                        />
                    </div>
                </section>

                <div className="flex justify-end">
                    <ExportButton href={`/dashboard/admin/print?period=${period.key}&mode=${dashboard.mode}`} />
                </div>

                <hr className="border-neutral-300" />

                <RecordListCard rows={records.rows} total={records.total} />

                <hr className="border-neutral-300" />

                <EventStatusCard event={event} />

                <hr className="border-neutral-300" />

                <UniformExceptionsCard
                    date={exceptions.date}
                    rows={exceptions.rows}
                />
            </div>
        </>
    );
}
