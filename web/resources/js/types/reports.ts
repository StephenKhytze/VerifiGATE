export type PeriodKey = 'daily' | 'weekly' | 'monthly';
export type AttendanceMode = 'on_time' | 'late';

export type Viewer = {
    name: string;
    title: string;
    role: 'faculty' | 'admin';
};

export type PeriodInfo = {
    key: PeriodKey;
    label: string;
    title: string;
    subtitle: string;
    range: string;
};

export type ChartPoint = { key: string; label: string; value: number };

export type RecordRow = {
    id: number;
    name: string;
    student_number: string;
    present: number;
    absent: number;
    late: number;
};

export type DashboardData = {
    period: PeriodInfo;
    mode: AttendanceMode;
    cards: { present: number; late: number; absent: number };
    absent_is_mock: boolean;
    chart: { legend: string; series: ChartPoint[]; total: number };
    records: { rows: RecordRow[]; total: number };
};
