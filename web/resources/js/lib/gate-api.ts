export type Flag = { code: string; label: string };

export type GuardCard = {
    id: number;
    status: 'pending' | 'approved' | 'approved_flagged_uniform' | 'flagged';
    person_type: 'student' | 'faculty' | 'employee' | 'visitor' | 'unknown';
    name: string;
    identifier: string | null;
    section: string | null;
    id_type: string | null;
    time: string;
    scan_attempts: number;
    uniform: {
        status: 'compliant' | 'non_compliant' | 'low_confidence' | 'unavailable';
        confidence: number | null;
    } | null;
    exceptions: string;
    flags: Flag[];
    sms: string;
    pickup: string[] | null; // null = not a visitor; [] = visitor on no pickup list
    needs_decision: boolean;
    can_approve: boolean;
    image_url: string;
};

export type LogCard = {
    id: number;
    label: string;
    tone: 'green' | 'orange' | 'gray' | 'amber' | 'red';
    icon: 'exit' | 'clock' | 'check' | 'shirt' | 'x';
    name: string;
    identifier: string | null;
    time: string;
};

export type GuardState = {
    mode: 'idle' | 'review' | 'result';
    current: GuardCard | null;
    pending_count: number;
    important: LogCard[];
    recent: LogCard[];
};

export type ScreenState = {
    screen: 'idle' | 'scanning' | 'welcome' | 'visitor_welcome' | 'flagged';
    given_names: string | null;
    time: string | null;
};

export type SearchHit = {
    person_type: 'student' | 'faculty' | 'employee';
    person_id: number;
    name: string;
    identifier: string;
    section: string | null;
    active: boolean;
};

export type History = {
    name: string;
    identifier: string | null;
    rows: { entered: string; exited: string | null; status: string }[];
};

export class ApiError extends Error {
    status: number;
    constructor(status: number, message: string) {
        super(message);
        this.status = status;
    }
}

function xsrfToken(): string {
    const m = document.cookie.match(/(?:^|; )XSRF-TOKEN=([^;]+)/);
    return m ? decodeURIComponent(m[1]) : '';
}

export async function api<T>(url: string, init: RequestInit = {}): Promise<T> {
    const res = await fetch(url, {
        credentials: 'same-origin',
        ...init,
        headers: {
            Accept: 'application/json',
            'Content-Type': 'application/json',
            'X-XSRF-TOKEN': xsrfToken(),
            ...((init.headers as Record<string, string> | undefined) ?? {}),
        },
    });

    if (!res.ok) {
        let message = res.statusText;
        try {
            const body = await res.json();
            message = body.message ?? message;
        } catch {
            /* response was not JSON */
        }
        throw new ApiError(res.status, message);
    }

    return (await res.json()) as T;
}
