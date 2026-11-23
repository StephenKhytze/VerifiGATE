import { NAVY } from '@/components/reports/colors';

const BASE =
    'inline-flex h-14 items-center rounded-2xl px-12 text-2xl font-semibold text-white shadow-md';

export default function ExportButton({ href }: { href?: string }) {
    if (!href) {
        return (
            <button
                type="button"
                disabled
                title="Available once the print layout is built"
                className={`${BASE} opacity-50`}
                style={{ backgroundColor: NAVY }}
            >
                Export
            </button>
        );
    }

    return (
        <a
            href={href}
            target="_blank"
            rel="noreferrer"
            className={BASE}
            style={{ backgroundColor: NAVY }}
        >
            Export
        </a>
    );
}
