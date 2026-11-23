import '@fontsource/afacad/400.css';
import '@fontsource/afacad/600.css';
import '@fontsource/afacad/700.css';
import { Head } from '@inertiajs/react';
import { useEffect, useRef } from 'react';
import IncidentsChart from '@/components/reports/incidents-chart';
import type { PrintReport } from '@/types/reports';

const PAGE_CSS = `
@page { size: A4 portrait; margin: 14mm; }
.report-sheet { font-family: 'Afacad', ui-sans-serif, system-ui, sans-serif; color: #000; }
.report-sheet table { width: 100%; border-collapse: collapse; }
.report-sheet thead { display: table-header-group; }
.report-sheet tr, .report-sheet section { break-inside: avoid; }
@media print {
    html, body { background: #fff !important; }
    .no-print { display: none !important; }
    .report-sheet { width: auto !important; min-height: 0 !important; margin: 0 !important; padding: 0 !important; box-shadow: none !important; }
}
`;

const n = (value: number) => value.toLocaleString('en-US');

function Box({ label, value, note, wide = false }: { label: string; value: string; note?: string; wide?: boolean }) {
    return (
        <div className={`rounded border border-black px-3 py-2 ${wide ? 'col-span-3' : ''}`}>
            <div className="text-[10pt]">{label}</div>
            <div className="text-[18pt] leading-tight font-semibold">{value}</div>
            {note && <div className="text-[8pt] text-neutral-600">{note}</div>}
        </div>
    );
}

export default function PrintReportPage({ report }: { report: PrintReport }) {
    const printed = useRef(false);
    const { period, chart, violators } = report;

    useEffect(() => {
        if (printed.current || new URLSearchParams(window.location.search).get('autoprint') === '0') {
            return;
        }
        printed.current = true;
        void document.fonts.ready.then(() => window.setTimeout(() => window.print(), 600));
    }, []);

    return (
        <>
            <Head title={`${report.title} - ${period.range}`} />
            <style>{PAGE_CSS}</style>

            <div className="min-h-screen bg-neutral-200 pb-8 print:bg-white print:pb-0">
                <div className="no-print mx-auto flex w-[210mm] max-w-full items-center justify-between gap-4 px-2 py-3 text-lg">
                    <p>In the print dialog, choose “Save as PDF” as the destination.</p>
                    <div className="flex gap-2">
                        <button
                            type="button"
                            onClick={() => window.print()}
                            className="h-10 rounded-lg bg-[#15325A] px-5 text-white"
                        >
                            Print / Save as PDF
                        </button>
                        <button
                            type="button"
                            onClick={() => window.close()}
                            className="h-10 rounded-lg border border-neutral-400 bg-white px-5"
                        >
                            Close
                        </button>
                    </div>
                </div>

                <div className="report-sheet mx-auto min-h-[297mm] w-[210mm] bg-white p-[14mm] shadow-lg">
                    <header className="border-b-2 border-black pb-3">
                        <div className="text-[22pt] leading-none">
                            <span className="font-light">Verifi</span>
                            <span className="font-bold">GATE</span>
                        </div>
                        <div className="mt-1 text-[13pt] font-semibold">{report.organization}</div>
                        <h1 className="mt-3 text-[16pt] font-bold">{report.title}</h1>
                        <div className="text-[11pt]">
                            {period.label} report: {period.range}
                        </div>
                        <div className="text-[11pt]">Scope: {report.scope}</div>
                        <div className="text-[10pt] text-neutral-600">Generated {report.generated_at}</div>
                    </header>

                    {report.mode_note && <p className="mt-3 text-[10pt] italic">{report.mode_note}</p>}

                    <section className="mt-4 grid grid-cols-3 gap-2">
                        {report.occupancy && (
                            <Box
                                wide
                                label="Campus Occupancy (currently inside, when generated)"
                                value={n(report.occupancy.total)}
                                note={`JHS ${n(report.occupancy.jhs)} · SHS ${n(report.occupancy.shs)} · College ${n(report.occupancy.college)}`}
                            />
                        )}
                        {report.extras && (
                            <>
                                <Box label="Uniform Violations" value={n(report.extras.violations)} />
                                <Box label="Visitors" value={n(report.extras.visitors)} />
                                <Box label="Reg. Card Scans" value={n(report.extras.reg_card_scans)} />
                            </>
                        )}
                        <Box label="Present Students" value={n(report.cards.present)} />
                        <Box label="Absent Students" value="Not tracked yet" />
                        <Box label="Late Students" value={n(report.cards.late)} />
                    </section>

                    <section className="mt-6">
                        <div className="flex items-baseline justify-between">
                            <h2 className="text-[13pt] font-semibold">{period.title}</h2>
                            <span className="text-[10pt]">Total incidents: {n(chart.total)}</span>
                        </div>
                        <div className="mt-2">
                            <IncidentsChart series={chart.series} legend={chart.legend} width={680} height={260} animate={false} />
                        </div>
                        <div
                            className="mt-2 grid text-center text-[9pt]"
                            style={{ gridTemplateColumns: `repeat(${Math.min(chart.series.length, 13)}, minmax(0, 1fr))` }}
                        >
                            {chart.series.map((point) => (
                                <div key={point.key} className="border border-neutral-400 px-0.5 py-0.5">
                                    <div className="text-neutral-600">{point.label}</div>
                                    <div className="font-semibold">{point.value}</div>
                                </div>
                            ))}
                        </div>
                    </section>

                    <section className="mt-6">
                        <h2 className="text-[13pt] font-semibold">Students with the most violations</h2>
                        <p className="text-[9pt] text-neutral-600">
                            Top {violators.limit} by days with a non-compliant uniform in this period. Showing{' '}
                            {violators.rows.length} of {violators.with_violations} students with violations.
                        </p>
                        <table className="mt-2 text-left text-[10pt]">
                            <thead>
                                <tr className="border-b border-black">
                                    <th className="py-1 pr-2 font-semibold">#</th>
                                    <th className="py-1 pr-2 font-semibold">Name</th>
                                    <th className="py-1 pr-2 font-semibold">Student No.</th>
                                    <th className="py-1 pr-2 text-right font-semibold">Violations</th>
                                    <th className="py-1 pr-2 text-right font-semibold">Present</th>
                                    <th className="py-1 text-right font-semibold">Late</th>
                                </tr>
                            </thead>
                            <tbody>
                                {violators.rows.length === 0 && (
                                    <tr>
                                        <td colSpan={6} className="py-3 text-center text-neutral-600">
                                            No violations recorded for this period.
                                        </td>
                                    </tr>
                                )}
                                {violators.rows.map((row, index) => (
                                    <tr key={row.id} className="border-b border-neutral-400">
                                        <td className="py-1 pr-2">{index + 1}</td>
                                        <td className="py-1 pr-2">{row.name}</td>
                                        <td className="py-1 pr-2">{row.student_number}</td>
                                        <td className="py-1 pr-2 text-right font-semibold">{row.violations}</td>
                                        <td className="py-1 pr-2 text-right">{row.present}</td>
                                        <td className="py-1 text-right">{row.late}</td>
                                    </tr>
                                ))}
                            </tbody>
                        </table>
                    </section>

                    <section className="mt-12 grid grid-cols-2 gap-16">
                        <div>
                            <div className="border-b border-black pb-1 text-[12pt] font-semibold">{report.prepared_by.name}</div>
                            <div className="text-[10pt]">Prepared by ({report.prepared_by.title})</div>
                        </div>
                        <div>
                            <div className="border-b border-black pb-1 text-[12pt]">&nbsp;</div>
                            <div className="text-[10pt]">Noted by</div>
                        </div>
                    </section>

                    <p className="mt-6 text-[8pt] text-neutral-600">
                        Absent counts are not tracked yet and are not included in this report.
                    </p>
                </div>
            </div>
        </>
    );
}
