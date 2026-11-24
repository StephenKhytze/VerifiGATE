import { ChevronRight } from 'lucide-react';
import { GRAY, GREEN } from '@/components/reports/colors';
import type { RecordRow } from '@/types/reports';

type Props = {
    rows: RecordRow[];
    total: number;
};

export default function RecordListCard({ rows, total }: Props) {
    return (
        <section className="rounded-2xl border border-neutral-300 bg-white p-8">
            <h2 className="text-2xl font-semibold">Record List</h2>
            <div className="mt-6 overflow-x-auto">
                <table className="w-full text-left text-lg">
                    <thead style={{ color: GRAY }}>
                        <tr className="border-b border-neutral-300">
                            <th className="pb-3 font-normal">Name</th>
                            <th className="pb-3 font-normal">Student No.</th>
                            <th className="pb-3 font-normal">Present</th>
                            <th className="pb-3 font-normal">Absent</th>
                            <th className="pb-3 font-normal">Late</th>
                        </tr>
                    </thead>
                    <tbody>
                        {rows.length === 0 && (
                            <tr>
                                <td
                                    colSpan={5}
                                    className="py-6 text-center"
                                    style={{ color: GRAY }}
                                >
                                    No students to show.
                                </td>
                            </tr>
                        )}
                        {rows.map((row) => (
                            <tr
                                key={row.id}
                                className="border-b border-neutral-300"
                            >
                                <td className="py-4">{row.name}</td>
                                <td className="py-4">{row.student_number}</td>
                                <td className="py-4">{row.present}</td>
                                <td className="py-4">{row.absent}</td>
                                <td className="py-4">{row.late}</td>
                            </tr>
                        ))}
                    </tbody>
                </table>
            </div>

            <div className="mt-4 flex items-center justify-between">
                <span style={{ color: GRAY }}>
                    Showing {rows.length} of {total} students
                </span>
                <button
                    type="button"
                    disabled
                    title="The Record List page is not built yet"
                    className="flex items-center gap-1 text-xl font-semibold opacity-60"
                    style={{ color: GREEN }}
                >
                    View All
                    <ChevronRight className="size-5" />
                </button>
            </div>
        </section>
    );
}
