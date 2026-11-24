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

export type Occupancy = {
    total: number;
    jhs: number;
    shs: number;
    college: number;
};

export type EventStatus = {
    active: boolean;
    name: string | null;
    date: string | null;
    attendees: number | null;
    capacity: number | null;
};

export type ExceptionRow = {
    label: string;
    exceptions: { name: string; info: boolean }[];
};

export type AdminDashboardData = DashboardData & {
    occupancy: Occupancy;
    extras: { violations: number; visitors: number; reg_card_scans: number };
    event: EventStatus;
    exceptions: { date: string; rows: ExceptionRow[] };
};

export type PrintReport = {
    organization: string;
    title: string;
    role: Viewer['role'];
    scope: string;
    period: PeriodInfo;
    generated_at: string;
    prepared_by: { name: string; title: string };
    mode_note: string | null;
    cards: { present: number; late: number };
    chart: { legend: string; series: ChartPoint[]; total: number };
    violators: {
        rows: (Pick<
            RecordRow,
            'id' | 'name' | 'student_number' | 'present' | 'late'
        > & { violations: number })[];
        with_violations: number;
        limit: number;
    };
    occupancy?: Occupancy;
    extras?: { violations: number; visitors: number; reg_card_scans: number };
};
