import { ChevronRight } from 'lucide-react';
import { GRAY, GREEN } from '@/components/reports/colors';
import type { EventStatus } from '@/types/reports';

export default function EventStatusCard({ event }: { event: EventStatus }) {
    return (
        <section className="rounded-2xl border border-neutral-300 bg-white p-8">
            <h2 className="text-2xl font-semibold">Event Status</h2>

            {event.active ? (
                <div className="mt-4 flex flex-wrap items-start justify-between gap-4">
                    <div>
                        <div className="text-2xl font-semibold">
                            {event.name}
                        </div>
                        <div className="text-lg" style={{ color: GRAY }}>
                            {event.date}
                        </div>
                    </div>
                    <div className="text-right">
                        <div className="text-2xl font-semibold">
                            Current Attendees
                        </div>
                        <div className="text-2xl">
                            {(event.attendees ?? 0).toLocaleString('en-US')} /{' '}
                            {(event.capacity ?? 0).toLocaleString('en-US')}
                        </div>
                    </div>
                </div>
            ) : (
                <p className="mt-4 text-2xl" style={{ color: GRAY }}>
                    Currently no active events
                </p>
            )}

            <div className="mt-6 flex justify-end">
                <button
                    type="button"
                    disabled
                    title="The Event module is not built yet"
                    className="flex items-center gap-1 text-xl font-semibold opacity-60"
                    style={{ color: GREEN }}
                >
                    View Past Events
                    <ChevronRight className="size-5" />
                </button>
            </div>
        </section>
    );
}
