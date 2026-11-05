import { Search, X } from 'lucide-react';
import { useEffect, useState } from 'react';
import { api, ApiError, type GuardCard, type SearchHit } from '@/lib/gate-api';

/**
 * If `target` is given, the person picked is attached to that scan (unreadable or wrong ID).
 * Otherwise a manual entry is started first (lost ID, registration card).
 */
export default function SearchPanel({ target, onClose }: { target: GuardCard | null; onClose: () => void }) {
    const [q, setQ] = useState('');
    const [hits, setHits] = useState<SearchHit[]>([]);
    const [busy, setBusy] = useState(false);
    const [message, setMessage] = useState<string | null>(null);

    useEffect(() => {
        if (q.trim().length < 2) {
            setHits([]);
            return;
        }
        let stale = false;
        const t = window.setTimeout(async () => {
            try {
                const res = await api<SearchHit[]>(`/gate/people/search?q=${encodeURIComponent(q.trim())}`);
                if (!stale) setHits(res);
            } catch {
                if (!stale) setMessage('Search failed.');
            }
        }, 300);
        return () => {
            stale = true;
            window.clearTimeout(t);
        };
    }, [q]);

    async function pick(hit: SearchHit) {
        setBusy(true);
        setMessage(null);
        try {
            const eventId = target
                ? target.id
                : (await api<{ event_id: number }>('/gate/events/manual', { method: 'POST' })).event_id;
            await api(`/gate/events/${eventId}/identify`, {
                method: 'POST',
                body: JSON.stringify({ person_type: hit.person_type, person_id: hit.person_id }),
            });
            onClose(); // the next poll shows the updated card
        } catch (e) {
            setMessage(e instanceof ApiError ? e.message : 'Could not identify this person.');
            setBusy(false);
        }
    }

    return (
        <div className="fixed inset-0 z-50 flex items-start justify-center bg-black/40 p-6 pt-[10vh]">
            <div className="w-full max-w-xl rounded-3xl bg-white p-8 shadow-xl">
                <div className="flex items-start justify-between">
                    <div>
                        <h2 className="text-2xl font-bold">Find student or staff</h2>
                        <p className="text-neutral-500">
                            {target ? 'The person you pick replaces the current scan result.' : 'Starts a manual entry (lost ID).'}
                        </p>
                    </div>
                    <button type="button" onClick={onClose} aria-label="Close">
                        <X className="h-7 w-7" />
                    </button>
                </div>

                <div className="mt-5 flex items-center gap-2 rounded-lg border px-3 py-2">
                    <Search className="h-5 w-5 text-neutral-500" />
                    <input
                        autoFocus
                        value={q}
                        onChange={(e) => setQ(e.target.value)}
                        placeholder="Name or ID number"
                        className="w-full text-lg outline-none"
                    />
                </div>

                {message && <p className="mt-3 text-[#C52F37]">{message}</p>}

                <ul className="mt-4 max-h-[45vh] overflow-y-auto">
                    {hits.map((h) => (
                        <li key={`${h.person_type}-${h.person_id}`}>
                            <button
                                type="button"
                                disabled={busy}
                                onClick={() => pick(h)}
                                className="flex w-full items-center justify-between gap-3 border-t px-2 py-3 text-left hover:bg-neutral-100 disabled:opacity-50"
                            >
                                <span>
                                    <span className="block text-lg font-bold">{h.name}</span>
                                    <span className="text-neutral-600">
                                        {h.identifier}
                                        {h.section ? ` · ${h.section}` : ''}
                                        {h.person_type !== 'student' ? ` · ${h.person_type}` : ''}
                                    </span>
                                </span>
                                {!h.active && <span className="text-sm text-[#C52F37]">Inactive</span>}
                            </button>
                        </li>
                    ))}
                    {q.trim().length >= 2 && hits.length === 0 && <li className="py-3 text-neutral-500">No matches.</li>}
                </ul>
            </div>
        </div>
    );
}
