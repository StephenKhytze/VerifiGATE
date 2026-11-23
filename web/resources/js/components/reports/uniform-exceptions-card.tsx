import { ChevronRight, Info } from 'lucide-react';
import { Fragment } from 'react';
import { GRAY, GREEN } from '@/components/reports/colors';
import type { ExceptionRow } from '@/types/reports';

type Props = {
    date: string;
    rows: ExceptionRow[];
};

export default function UniformExceptionsCard({ date, rows }: Props) {
    return (
        <section className="rounded-2xl border border-neutral-300 bg-white p-8">
            <h2 className="text-2xl font-semibold">
                Uniform Exceptions - {date}
            </h2>

            <table className="mt-6 w-full text-left text-lg">
                <thead style={{ color: GRAY }}>
                    <tr className="border-b border-neutral-300">
                        <th className="w-1/2 pb-3 font-normal">Class/Event</th>
                        <th className="pb-3 font-normal">Exception</th>
                    </tr>
                </thead>
                <tbody>
                    {rows.length === 0 && (
                        <tr>
                            <td
                                colSpan={2}
                                className="py-6 text-center"
                                style={{ color: GRAY }}
                            >
                                No exceptions today.
                            </td>
                        </tr>
                    )}
                    {rows.map((row) => (
                        <tr
                            key={row.label}
                            className="border-b border-neutral-300"
                        >
                            <td className="py-4">{row.label}</td>
                            <td className="py-4">
                                {row.exceptions.map((item, index) => (
                                    <Fragment key={item.name}>
                                        {index > 0 && ', '}
                                        {item.name}
                                        {item.info && (
                                            <Info
                                                className="mx-1 inline size-4 align-baseline"
                                                style={{ color: GRAY }}
                                                aria-label="Allowed for this class or event"
                                            />
                                        )}
                                    </Fragment>
                                ))}
                            </td>
                        </tr>
                    ))}
                </tbody>
            </table>

            <div className="mt-4 flex justify-end">
                <button
                    type="button"
                    disabled
                    title="The Uniform Exception module is not built yet"
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
