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

const Y_DOMAIN: [number, (max: number) => number] = [
    0,
    (max) => Math.max(4, max),
];

type Props = {
    series: ChartPoint[];
    legend: string;
    height?: number;
    /** A fixed width is for the print page, where a resizing chart would print at the wrong size. */
    width?: number;
    animate?: boolean;
    /** Adds a screen-reader-only table of the values; the print page already shows one. */
    describe?: boolean;
};

export default function IncidentsChart({
    series,
    legend,
    height = 380,
    width,
    animate = true,
    describe = true,
}: Props) {
    const empty = series.every((point) => point.value === 0);

    const chart = (
        <LineChart
            data={series}
            width={width}
            height={height}
            margin={{ top: 8, right: 24, bottom: 8, left: 0 }}
        >
            <CartesianGrid stroke="#D4D4D4" vertical={false} />
            <XAxis
                dataKey="label"
                tick={{ fontSize: 13 }}
                padding={{ left: 20, right: 20 }}
            />
            <YAxis
                allowDecimals={false}
                domain={Y_DOMAIN}
                tick={{ fontSize: 13 }}
                width={36}
            />
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
    );

    return (
        <div>
            <div
                role="img"
                aria-label={`${legend} chart. The values are listed in the table below.`}
            >
                {width ? (
                    chart
                ) : (
                    <ResponsiveContainer width="100%" height={height}>
                        {chart}
                    </ResponsiveContainer>
                )}
            </div>

            {describe && (
                <table className="sr-only">
                    <caption>{legend} per period</caption>
                    <thead>
                        <tr>
                            <th scope="col">Period</th>
                            <th scope="col">{legend}</th>
                        </tr>
                    </thead>
                    <tbody>
                        {series.map((point) => (
                            <tr key={point.key}>
                                <th scope="row">{point.label}</th>
                                <td>{point.value}</td>
                            </tr>
                        ))}
                    </tbody>
                </table>
            )}

            {empty && (
                <p className="mt-2 text-center" style={{ color: GRAY }}>
                    No incidents recorded for this period.
                </p>
            )}
        </div>
    );
}
