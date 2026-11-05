import { X } from 'lucide-react';
import { useEffect, useState } from 'react';
import { api, type History } from '@/lib/gate-api';

export default function HistoryModal({ eventId, onClose }: { eventId: number; onClose: () => void }) {
    const [data, setData] = useState<History | null>(null);
    const [failed, setFailed] = useState(false);

    useEffect(() => {
        api<History>(`/gate/events/${eventId}/history`)
            .then(setData)
            .catch(() => setFailed(true));
    }, [eventId]);

    return (
        <div className="fixed inset-0 z-50 flex items-center justify-center bg-black/40 p-6">
            <div className="w-full max-w-xl rounded-3xl bg-white p-8 shadow-xl">
                <div className="flex items-start justify-between gap-4">
                    <div>
                        <div className="text-xl">Showing today's entry/exit logs for</div>
                        <div className="text-2xl font-bold">
                            {data ? data.name : '...'}
                            {data?.identifier ? ` (${data.identifier})` : ''}
                        </div>
                    </div>
                    <button type="button" onClick={onClose} aria-label="Close">
                        <X className="h-7 w-7" />
                    </button>
                </div>

                {failed && <p className="mt-6 text-[#C52F37]">Could not load the logs.</p>}

                {data && (
                    <table className="mt-6 w-full text-left text-lg">
                        <thead className="text-neutral-500">
                            <tr>
                                <th className="py-2 font-normal">Entered</th>
                                <th className="py-2 font-normal">Exited</th>
                            </tr>
                        </thead>
                        <tbody>
                            {data.rows.map((r, i) => (
                                <tr key={i} className="border-t">
                                    <td className="py-3">{r.entered}</td>
                                    <td className="py-3">{r.exited ?? '—'}</td>
                                </tr>
                            ))}
                        </tbody>
                    </table>
                )}
                {data && (
                    <p className="mt-4 text-neutral-500">
                        Showing {data.rows.length} out of {data.rows.length} entry/exit logs
                    </p>
                )}
            </div>
        </div>
    );
}
