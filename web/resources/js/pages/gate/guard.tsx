import { Head } from '@inertiajs/react';
import { Check, Search, X } from 'lucide-react';
import { useState } from 'react';
import HistoryModal from '@/components/gate/history-modal';
import LogCardView from '@/components/gate/log-card';
import SearchPanel from '@/components/gate/search-panel';
import { usePoll } from '@/hooks/use-poll';
import { api, ApiError, type GuardCard, type GuardState } from '@/lib/gate-api';

const GREEN = '#2B8132';
const ORANGE = '#FF9831';
const RED = '#C52F37';

const UNIFORM = {
    compliant: { text: 'Compliant', color: GREEN },
    low_confidence: { text: 'Low Confidence', color: ORANGE },
    non_compliant: { text: 'Non-compliant', color: RED },
    unavailable: { text: 'Unavailable', color: '#737373' },
} as const;

const RESULT = {
    approved: { text: 'Entry approved', color: GREEN },
    approved_flagged_uniform: { text: 'Approved with flagged uniform', color: ORANGE },
    flagged: { text: 'Flagged: entry not allowed', color: RED },
    pending: { text: '', color: '#737373' },
} as const;

function Logo() {
    return (
        <div className="text-5xl leading-none">
            <span className="font-light">Verifi</span>
            <span className="font-extrabold">GATE</span>
        </div>
    );
}

function Review({
    card,
    mode,
    pending,
    onSearch,
}: {
    card: GuardCard;
    mode: GuardState['mode'];
    pending: number;
    onSearch: () => void;
}) {
    const [busy, setBusy] = useState(false);
    const [message, setMessage] = useState<string | null>(null);
    const [imageOk, setImageOk] = useState(true);
    const visitor = card.person_type === 'visitor';

    async function decide(decision: 'approve' | 'deny') {
        setBusy(true);
        setMessage(null);
        try {
            await api(`/gate/events/${card.id}/decision`, { method: 'POST', body: JSON.stringify({ decision }) });
        } catch (e) {
            setMessage(e instanceof ApiError ? e.message : 'Could not save the decision.');
        } finally {
            setBusy(false);
        }
    }

    const idLine =
        card.person_type === 'student'
            ? `Student Number: ${card.identifier ?? ''}`
            : card.person_type === 'faculty' || card.person_type === 'employee'
              ? `ID Number: ${card.identifier ?? ''}`
              : visitor
                ? `ID Type: ${card.id_type ?? 'Unknown'}`
                : 'Not identified yet';

    return (
        <div className="mt-6 grid grid-cols-2 gap-8">
            <section>
                {imageOk ? (
                    <img
                        src={card.image_url}
                        alt="Scanned ID"
                        onError={() => setImageOk(false)}
                        className="max-h-[34vh] rounded-lg object-contain"
                    />
                ) : (
                    <div className="flex h-[34vh] items-center justify-center rounded-lg bg-neutral-100 text-neutral-500">
                        ID image no longer available
                    </div>
                )}

                <h2 className="mt-5 text-3xl font-bold">{card.name}</h2>
                <div className="text-xl font-bold">{idLine}</div>
                {visitor && <div className="text-xl">Visitor</div>}
                {card.section && <div className="text-xl">{card.section}</div>}

                <div className="mt-4 flex justify-between border-b pb-3 text-lg">
                    <span>Time: {card.time}</span>
                    <span>Scan attempts: {card.scan_attempts}</span>
                </div>

                {card.uniform && (
                    <div className="mt-3 text-lg">
                        <span className="mr-2 inline-block h-3 w-3 rounded-full" style={{ backgroundColor: UNIFORM[card.uniform.status].color }} />
                        <b>Uniform: </b>
                        <span style={{ color: UNIFORM[card.uniform.status].color }}>
                            {UNIFORM[card.uniform.status].text}
                            {card.uniform.confidence !== null ? ` (${card.uniform.confidence.toFixed(2)}%)` : ''}
                        </span>
                        <div>
                            <b>Exceptions: </b>
                            {card.exceptions}
                        </div>
                    </div>
                )}

                {card.pickup !== null && (
                    <div className="mt-3 text-lg">
                        <b>Visitor is authorized to pick-up:</b>
                        {card.pickup.length === 0 ? (
                            <div style={{ color: ORANGE }}>Not on any pickup list</div>
                        ) : (
                            card.pickup.map((n) => <div key={n}>{n}</div>)
                        )}
                    </div>
                )}

                {card.flags.length > 0 && (
                    <div className="mt-4 rounded-xl border-2 p-3" style={{ borderColor: ORANGE }}>
                        <div className="font-bold">Needs your attention:</div>
                        <ul className="list-disc pl-5">
                            {card.flags.map((f) => (
                                <li key={f.code}>{f.label}</li>
                            ))}
                        </ul>
                    </div>
                )}

                {!visitor && (
                    <div className="mt-3 text-lg">
                        <b>SMS Notification: </b>
                        <span className="text-neutral-500">{card.sms}</span>
                    </div>
                )}
            </section>

            <section>
                {/* TODO: replace with the live uniform-camera frame when that module exists */}
                <div className="flex h-[52vh] items-center justify-center rounded-lg bg-neutral-200 p-6 text-center text-neutral-500">
                    Live camera not connected yet
                </div>

                {mode === 'result' && card.status !== 'pending' && (
                    <div
                        className="mt-5 rounded-2xl py-4 text-center text-2xl font-bold text-white"
                        style={{ backgroundColor: RESULT[card.status].color }}
                    >
                        {RESULT[card.status].text}
                    </div>
                )}

                {card.needs_decision && (
                    <>
                        <div className="mt-5 grid grid-cols-2 gap-4">
                            <button
                                type="button"
                                disabled={busy || !card.can_approve}
                                onClick={() => decide('approve')}
                                className="flex h-16 items-center justify-center rounded-2xl text-white shadow disabled:opacity-40"
                                style={{ backgroundColor: GREEN }}
                                aria-label="Approve entry"
                            >
                                <Check className="h-8 w-8" strokeWidth={3} />
                            </button>
                            <button
                                type="button"
                                disabled={busy}
                                onClick={() => decide('deny')}
                                className="flex h-16 items-center justify-center rounded-2xl text-white shadow disabled:opacity-40"
                                style={{ backgroundColor: RED }}
                                aria-label="Deny entry"
                            >
                                <X className="h-8 w-8" strokeWidth={3} />
                            </button>
                        </div>
                        {visitor && (
                            <button
                                type="button"
                                onClick={() => setMessage('The turnstile is not connected yet.')}
                                className="mt-4 h-14 w-full rounded-2xl text-xl font-bold text-white shadow"
                                style={{ backgroundColor: GREEN }}
                            >
                                Open Turnstile
                            </button>
                        )}
                        {!visitor && (
                            <button
                                type="button"
                                onClick={onSearch}
                                className="mt-4 flex w-full items-center justify-center gap-2 rounded-2xl border-2 py-3 text-lg"
                            >
                                <Search className="h-5 w-5" />
                                {card.can_approve ? 'Wrong person? Search' : 'Identify the person'}
                            </button>
                        )}
                        {!card.can_approve && <p className="mt-2 text-neutral-600">Identify the person before approving.</p>}
                    </>
                )}

                {message && <p className="mt-3" style={{ color: RED }}>{message}</p>}
                {pending > 1 && mode === 'review' && (
                    <p className="mt-3 text-neutral-600">{pending - 1} more waiting after this one.</p>
                )}
            </section>
        </div>
    );
}

export default function GateGuard() {
    const { data, error } = usePoll<GuardState>('/gate/state', 500);
    const [historyFor, setHistoryFor] = useState<number | null>(null);
    const [searching, setSearching] = useState(false);
    const [showAll, setShowAll] = useState(false);

    const current = data?.current ?? null;
    const important = data?.important ?? [];
    const shownImportant = showAll ? important : important.slice(0, 2);

    return (
        <div className="flex h-screen w-screen overflow-hidden bg-white text-black">
            <Head title="Guard view" />

            <main className="flex-1 overflow-y-auto p-8">
                <div className="flex items-center justify-between">
                    <Logo />
                    <button
                        type="button"
                        onClick={() => setSearching(true)}
                        className="flex items-center gap-2 rounded-xl border-2 px-4 py-2 text-lg"
                    >
                        <Search className="h-5 w-5" />
                        {current?.needs_decision ? 'Search' : 'Lost ID / manual entry'}
                    </button>
                </div>

                {error && (
                    <div className="mt-4 rounded-lg p-3 text-white" style={{ backgroundColor: RED }}>
                        Connection to the server lost. Retrying...
                    </div>
                )}

                {!current ? (
                    <div className="flex h-[70vh] flex-col items-center justify-center text-center">
                        <h1 className="text-5xl font-bold">Idle Mode</h1>
                        <p className="mt-8 text-4xl font-light">No students to display</p>
                    </div>
                ) : (
                    <Review
                        key={current.id}
                        card={current}
                        mode={data!.mode}
                        pending={data!.pending_count}
                        onSearch={() => setSearching(true)}
                    />
                )}
            </main>

            <aside className="w-[32%] min-w-[360px] overflow-y-auto bg-neutral-100 p-6">
                <h2 className="text-3xl font-bold">Important</h2>
                <div className="mt-4 space-y-3">
                    {shownImportant.length === 0 && <p className="text-neutral-500">Nothing needs attention.</p>}
                    {shownImportant.map((c) => (
                        <LogCardView key={c.id} card={c} onOpen={setHistoryFor} />
                    ))}
                </div>
                {important.length > 2 && (
                    <button
                        type="button"
                        onClick={() => setShowAll((v) => !v)}
                        className="mt-4 w-full border-b pb-3 text-left text-2xl"
                    >
                        {showAll ? 'Show less' : 'View All'}
                    </button>
                )}

                <h2 className="mt-10 text-3xl font-bold">Student Logs</h2>
                <div className="mt-4 space-y-3">
                    {(data?.recent ?? []).map((c) => (
                        <LogCardView key={c.id} card={c} onOpen={setHistoryFor} />
                    ))}
                </div>
            </aside>

            {historyFor !== null && <HistoryModal eventId={historyFor} onClose={() => setHistoryFor(null)} />}
            {searching && (
                <SearchPanel target={current?.needs_decision ? current : null} onClose={() => setSearching(false)} />
            )}
        </div>
    );
}
