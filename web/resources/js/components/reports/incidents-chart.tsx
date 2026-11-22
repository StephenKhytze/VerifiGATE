import {
    CartesianGrid,
    Legend,
    Line,
    LineChart,
    ResponsiveContainer,
    Tooltip,
    XAxis,
    YAxis,
} from 'recharts';
import { CHART_BLUE, GRAY } from '@/components/reports/colors';
import type { ChartPoint } from '@/types/reports';

const Y_DOMAIN: [number, (max: number) => number] = [0, (max) => Math.max(4, max)];

type Props = {
    series: ChartPoint[];
    legend: string;
    height?: number;
    animate?: boolean;
};

export default function IncidentsChart({ series, legend, height = 380, animate = true }: Props) {
    const empty = series.every((point) => point.value === 0);

    return (
        <div role="img" aria-label={`${legend} chart`}>
            <ResponsiveContainer width="100%" height={height}>
                <LineChart data={series} margin={{ top: 8, right: 24, bottom: 8, left: 0 }}>
                    <CartesianGrid stroke="#D4D4D4" vertical={false} />
                    <XAxis dataKey="label" tick={{ fontSize: 13 }} />
                    <YAxis allowDecimals={false} domain={Y_DOMAIN} tick={{ fontSize: 13 }} width={36} />
                    <Tooltip />
                    <Legend verticalAlign="top" align="left" iconType="square" />
                    <Line
                        type="linear"
                        dataKey="value"
                        name={legend}
                        stroke={CHART_BLUE}
                        strokeWidth={2}
                        dot={{ r: 4, fill: CHART_BLUE }}
                        isAnimationActive={animate}
                    />
                </LineChart>
            </ResponsiveContainer>
            {empty && (
                <p className="mt-2 text-center" style={{ color: GRAY }}>
                    No incidents recorded for this period.
                </p>
            )}
        </div>
    );
}
