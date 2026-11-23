import { GRAY } from '@/components/reports/colors';
import type { Occupancy } from '@/types/reports';

export default function OccupancyCard({ occupancy }: { occupancy: Occupancy }) {
    const levels = [
        { label: 'JHS', value: occupancy.jhs },
        { label: 'SHS', value: occupancy.shs },
        { label: 'College', value: occupancy.college },
    ];

    return (
        <section
            aria-label="Campus occupancy"
            className="flex flex-wrap items-center justify-between gap-6 rounded-2xl border-2 border-black bg-white px-8 py-5"
        >
            <div>
                <div className="text-3xl font-semibold">Campus Occupancy</div>
                <div className="text-lg" style={{ color: GRAY }}>
                    currently inside
                </div>
                <div className="text-5xl font-semibold">
                    {occupancy.total.toLocaleString('en-US')}
                </div>
            </div>
            <dl className="flex gap-12 text-center">
                {levels.map((level) => (
                    <div key={level.label}>
                        <dt className="text-2xl" style={{ color: GRAY }}>
                            {level.label}
                        </dt>
                        <dd className="mt-2 text-3xl font-semibold">
                            {level.value.toLocaleString('en-US')}
                        </dd>
                    </div>
                ))}
            </dl>
        </section>
    );
}
