import { router } from '@inertiajs/react';
import { GRAY, NAVY } from '@/components/reports/colors';
import type { AttendanceMode, PeriodKey, Viewer } from '@/types/reports';

const ROLES: { value: Viewer['role']; label: string }[] = [
    { value: 'faculty', label: 'Faculty' },
    { value: 'admin', label: 'Admin' },
];

type Props = {
    role: Viewer['role'];
    period: PeriodKey;
    mode: AttendanceMode;
};

export default function ViewAsSwitch({ role, period, mode }: Props) {
    function switchTo(next: Viewer['role']) {
        if (next !== role) {
            router.get(`/dashboard/${next}`, { period, mode });
        }
    }

    return (
        <div className="flex items-center gap-2">
            <span className="text-sm" style={{ color: GRAY }}>
                View as
            </span>
            <div
                role="group"
                aria-label="View dashboard as"
                className="flex overflow-hidden rounded-lg border border-neutral-300 bg-white"
            >
                {ROLES.map((option) => (
                    <button
                        key={option.value}
                        type="button"
                        aria-pressed={role === option.value}
                        onClick={() => switchTo(option.value)}
                        className="h-10 px-4 text-lg"
                        style={
                            role === option.value
                                ? { backgroundColor: NAVY, color: '#fff' }
                                : undefined
                        }
                    >
                        {option.label}
                    </button>
                ))}
            </div>
        </div>
    );
}
