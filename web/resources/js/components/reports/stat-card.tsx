import { GRAY } from '@/components/reports/colors';

type Props = {
    title: string;
    subtitle: string;
    value: number;
    color: string;
    sample?: boolean;
};

export default function StatCard({ title, subtitle, value, color, sample = false }: Props) {
    return (
        <div className="rounded-2xl border-2 bg-white px-6 py-4" style={{ borderColor: color }}>
            <div className="text-2xl font-semibold" style={{ color }}>
                {title}
            </div>
            <div className="text-lg" style={{ color: GRAY }}>
                {subtitle}
            </div>
            <div className="mt-1 flex items-end justify-between">
                <span className="text-4xl font-semibold" style={{ color }}>
                    {value.toLocaleString('en-US')}
                </span>
                {sample && (
                    <span className="text-xs" style={{ color: GRAY }}>
                        sample data
                    </span>
                )}
            </div>
        </div>
    );
}
