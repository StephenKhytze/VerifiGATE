import { ChevronDown } from 'lucide-react';
import type { PeriodKey } from '@/types/reports';

const OPTIONS: { value: PeriodKey; label: string }[] = [
    { value: 'daily', label: 'Daily' },
    { value: 'weekly', label: 'Weekly' },
    { value: 'monthly', label: 'Monthly' },
];

type Props = {
    value: PeriodKey;
    onChange: (value: PeriodKey) => void;
    disabled?: boolean;
};

export default function PeriodSelect({
    value,
    onChange,
    disabled = false,
}: Props) {
    return (
        <label className="relative inline-block">
            <span className="sr-only">Report period</span>
            <select
                value={value}
                disabled={disabled}
                onChange={(event) => onChange(event.target.value as PeriodKey)}
                className="h-10 appearance-none rounded-lg border border-neutral-300 bg-white pr-10 pl-4 text-lg disabled:opacity-60"
            >
                {OPTIONS.map((option) => (
                    <option key={option.value} value={option.value}>
                        {option.label}
                    </option>
                ))}
            </select>
            <ChevronDown className="pointer-events-none absolute top-1/2 right-3 size-5 -translate-y-1/2" />
        </label>
    );
}
