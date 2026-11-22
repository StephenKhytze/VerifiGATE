import { GRAY, GREEN, ORANGE } from '@/components/reports/colors';
import type { AttendanceMode } from '@/types/reports';

const OPTIONS: { value: AttendanceMode; label: string; color: string }[] = [
    { value: 'on_time', label: 'On time', color: GREEN },
    { value: 'late', label: 'Late', color: ORANGE },
];

type Props = {
    value: AttendanceMode;
    onChange: (value: AttendanceMode) => void;
    disabled?: boolean;
};

export default function ModeToggle({ value, onChange, disabled = false }: Props) {
    return (
        <div className="flex items-center gap-2">
            <span className="text-sm" style={{ color: GRAY }}>
                Test mode
            </span>
            <div
                role="group"
                aria-label="Attendance test mode"
                className="flex overflow-hidden rounded-lg border border-neutral-300 bg-white"
            >
                {OPTIONS.map((option) => (
                    <button
                        key={option.value}
                        type="button"
                        disabled={disabled}
                        aria-pressed={value === option.value}
                        onClick={() => onChange(option.value)}
                        className="h-10 px-4 text-lg disabled:opacity-60"
                        style={value === option.value ? { backgroundColor: option.color, color: '#fff' } : undefined}
                    >
                        {option.label}
                    </button>
                ))}
            </div>
        </div>
    );
}
