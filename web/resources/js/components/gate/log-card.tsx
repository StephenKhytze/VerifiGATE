import { Check, Clock, ExternalLink, LogOut, Shirt, X } from 'lucide-react';
import type { LogCard } from '@/lib/gate-api';

const TONE: Record<LogCard['tone'], string> = {
    green: '#2B8132',
    orange: '#FF9831',
    gray: '#6B7280',
    amber: '#EAB308',
    red: '#C52F37',
};
const ICON = { exit: LogOut, clock: Clock, check: Check, shirt: Shirt, x: X };

export default function LogCardView({ card, onOpen }: { card: LogCard; onOpen: (id: number) => void }) {
    const Icon = ICON[card.icon];
    return (
        <div
            className="flex items-center gap-3 rounded-2xl border-2 bg-white px-4 py-3"
            style={{ borderColor: TONE[card.tone] }}
        >
            <div className="min-w-0 flex-1">
                <div className="flex items-center gap-1 text-sm">
                    <Icon className="h-4 w-4" style={{ color: TONE[card.tone] }} />
                    {card.label}
                </div>
                <div className="truncate text-lg font-bold">{card.name}</div>
                <div className="text-sm">
                    {card.identifier ? `${card.identifier} || ` : ''}
                    {card.time}
                </div>
            </div>
            <button
                type="button"
                onClick={() => onOpen(card.id)}
                className="rounded p-2 hover:bg-neutral-100"
                aria-label="Open entry and exit details"
            >
                <ExternalLink className="h-5 w-5" />
            </button>
        </div>
    );
}
