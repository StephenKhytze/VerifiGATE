import { router } from '@inertiajs/react';
import { useRef, useState } from 'react';
import type { AttendanceMode, PeriodKey } from '@/types/reports';

/** Reloads only the report data for a new period or test mode, and tracks loading and failure. */
export function useReportVisit(
    url: string,
    current: { period: PeriodKey; mode: AttendanceMode },
) {
    const [loading, setLoading] = useState(false);
    const [failed, setFailed] = useState(false);
    const succeeded = useRef(false);

    function visit(next: { period?: PeriodKey; mode?: AttendanceMode }) {
        router.get(
            url,
            {
                period: next.period ?? current.period,
                mode: next.mode ?? current.mode,
            },
            {
                only: ['dashboard'],
                preserveScroll: true,
                preserveState: true,
                replace: true,
                onStart: () => {
                    succeeded.current = false;
                    setFailed(false);
                    setLoading(true);
                },
                onSuccess: () => {
                    succeeded.current = true;
                },
                onFinish: () => {
                    setLoading(false);
                    if (!succeeded.current) {
                        setFailed(true);
                    }
                },
            },
        );
    }

    return { loading, failed, visit };
}
