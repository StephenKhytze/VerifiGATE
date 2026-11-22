import { Head, router } from '@inertiajs/react';
import { useState } from 'react';
import { GREEN, ORANGE, RED } from '@/components/reports/colors';
import ExportButton from '@/components/reports/export-button';
import IncidentsChart from '@/components/reports/incidents-chart';
import ModeToggle from '@/components/reports/mode-toggle';
import PeriodSelect from '@/components/reports/period-select';
import RecordListCard from '@/components/reports/record-list-card';
import StatCard from '@/components/reports/stat-card';
import type { AttendanceMode, DashboardData, PeriodKey } from '@/types/reports';

type Props = {
    dashboard: DashboardData;
    testControls: boolean;
};

export default function FacultyDashboard({ dashboard, testControls }: Props) {
    const [loading, setLoading] = useState(false);
    const { period, cards, chart, records } = dashboard;

    function visit(next: { period?: PeriodKey; mode?: AttendanceMode }) {
        router.get(
            '/dashboard/faculty',
            { period: next.period ?? period.key, mode: next.mode ?? dashboard.mode },
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
            <Head title="Faculty Dashboard" />

            <div className="flex flex-wrap items-center justify-between gap-4">
                <h1 className="text-3xl font-bold">Faculty Dashboard</h1>
                <div className="flex items-center gap-4">
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

            <div className="mt-8 space-y-8 transition-opacity" style={{ opacity: loading ? 0.6 : 1 }} aria-busy={loading}>
                <div className="grid gap-5 md:grid-cols-3">
                    <StatCard title="Present Students" subtitle={period.subtitle} value={cards.present} color={GREEN} />
                    <StatCard
                        title="Absent Students"
                        subtitle={period.subtitle}
                        value={cards.absent}
                        color={RED}
                        sample={dashboard.absent_is_mock}
                    />
                    <StatCard title="Late Students" subtitle={period.subtitle} value={cards.late} color={ORANGE} />
                </div>

                <section className="rounded-2xl border border-neutral-300 bg-white p-8">
                    <div className="flex flex-wrap items-baseline justify-between gap-2">
                        <h2 className="text-2xl font-semibold">{period.title}</h2>
                        <span className="text-lg text-neutral-500">{period.range}</span>
                    </div>
                    <div className="mt-4">
                        <IncidentsChart series={chart.series} legend={chart.legend} />
                    </div>
                </section>

                <div className="flex justify-end border-b border-neutral-300 pb-8">
                    <ExportButton />
                </div>

                <RecordListCard rows={records.rows} total={records.total} />
            </div>
        </>
    );
}
