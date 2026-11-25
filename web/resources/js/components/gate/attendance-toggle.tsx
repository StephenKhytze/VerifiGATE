import { useState } from 'react';
import { api, ApiError, type GuardState } from '@/lib/gate-api';

const GREEN = '#2B8132';
const ORANGE = '#FF9831';
const RED = '#C52F37';

const OPTIONS = [
    { value: 'on_time', label: 'On time', color: GREEN },
    { value: 'late', label: 'Late', color: ORANGE },
] as const;

type Attendance = GuardState['attendance'];

export default function AttendanceToggle({
    attendance,
}: {
    attendance: Attendance;
}) {
    const [busy, setBusy] = useState(false);
    const [error, setError] = useState<string | null>(null);

    async function choose(status: Attendance['mode']) {
        if (status === attendance.mode) {
            return;
        }

        setBusy(true);
        setError(null);
        try {
            await api('/gate/attendance-mode', {
                method: 'POST',
                body: JSON.stringify({ status }),
            });
        } catch (e) {
            setError(
                e instanceof ApiError
                    ? e.message
                    : 'Could not change the scan mode.',
            );
        } finally {
            setBusy(false);
        }
    }

    return (
        <div
            className="flex items-center gap-2"
            title="Test control: marks new entries as on time or late until class schedules exist"
        >
            <span className="text-lg text-neutral-600">Scan as</span>
            <div
                role="group"
                aria-label="Mark new entries as"
                className="flex overflow-hidden rounded-xl border-2"
            >
                {OPTIONS.map((option) => (
                    <button
                        key={option.value}
                        type="button"
                        disabled={busy}
                        aria-pressed={attendance.mode === option.value}
                        onClick={() => choose(option.value)}
                        className="px-4 py-2 text-lg disabled:opacity-60"
                        style={
                            attendance.mode === option.value
                                ? { backgroundColor: option.color, color: '#fff' }
                                : undefined
                        }
                    >
                        {option.label}
                    </button>
                ))}
            </div>
            {error && (
                <span className="text-sm" style={{ color: RED }}>
                    {error}
                </span>
            )}
        </div>
    );
}
