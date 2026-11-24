import { RED } from '@/components/reports/colors';

export default function ReportStatus({
    loading,
    failed,
}: {
    loading: boolean;
    failed: boolean;
}) {
    return (
        <>
            <p role="status" className="sr-only">
                {loading ? 'Updating report…' : ''}
            </p>
            {failed && (
                <p
                    role="alert"
                    className="mt-4 rounded-lg px-4 py-3 text-lg text-white"
                    style={{ backgroundColor: RED }}
                >
                    Could not load this period. Please try again.
                </p>
            )}
        </>
    );
}
