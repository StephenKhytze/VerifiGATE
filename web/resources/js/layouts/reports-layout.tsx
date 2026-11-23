import '@fontsource/afacad/400.css';
import '@fontsource/afacad/500.css';
import '@fontsource/afacad/600.css';
import '@fontsource/afacad/700.css';
import { Link, router, usePage } from '@inertiajs/react';
import { CircleUser, LogOut } from 'lucide-react';
import type { ReactNode } from 'react';
import { GRAY, GREEN, RED } from '@/components/reports/colors';
import { NAV } from '@/components/reports/nav';
import { logout } from '@/routes';
import type { Viewer } from '@/types/reports';

const FONT = "'Afacad', ui-sans-serif, system-ui, sans-serif";

export default function ReportsLayout({ children }: { children: ReactNode }) {
    const page = usePage<{ viewer: Viewer }>();
    const { viewer } = page.props;
    const path = page.url.split('?')[0];
    const groups = NAV[viewer.role];
    const row = 'flex h-14 w-full items-center gap-3 px-8 text-xl';

    return (
        <div
            className="flex min-h-screen bg-[#F2F2F2] text-black"
            style={{ fontFamily: FONT }}
        >
            <aside className="sticky top-0 hidden h-screen w-64 shrink-0 flex-col bg-white shadow-[6px_0_16px_rgba(0,0,0,0.08)] md:flex">
                <div className="px-8 pt-10 pb-8 text-4xl leading-none">
                    <span className="font-light">Verifi</span>
                    <span className="font-bold">GATE</span>
                </div>

                <nav className="flex-1 overflow-y-auto" aria-label="Main">
                    {groups.map((group, index) => (
                        <div key={group.heading ?? index}>
                            {group.heading && (
                                <p className="px-8 pt-6 pb-2 text-2xl">
                                    {group.heading}
                                </p>
                            )}
                            {group.items.map(({ title, icon: Icon, href }) =>
                                href ? (
                                    <Link
                                        key={title}
                                        href={href}
                                        className={row}
                                        style={
                                            path === href
                                                ? {
                                                      backgroundColor: GREEN,
                                                      color: '#fff',
                                                  }
                                                : undefined
                                        }
                                    >
                                        <Icon className="size-5" />
                                        {title}
                                    </Link>
                                ) : (
                                    <span
                                        key={title}
                                        aria-disabled="true"
                                        title="Coming soon"
                                        className={`${row} cursor-not-allowed text-neutral-400`}
                                    >
                                        <Icon className="size-5" />
                                        {title}
                                    </span>
                                ),
                            )}
                        </div>
                    ))}
                </nav>

                <div className="border-t border-neutral-200">
                    <div className="flex items-center gap-3 px-6 py-4">
                        <CircleUser
                            className="size-10 shrink-0"
                            strokeWidth={1.5}
                        />
                        <div className="min-w-0">
                            <div className="truncate text-lg leading-tight font-semibold">
                                {viewer.name}
                            </div>
                            <div
                                className="text-sm leading-tight"
                                style={{ color: GRAY }}
                            >
                                {viewer.title}
                            </div>
                        </div>
                    </div>
                    <div className="border-t border-neutral-200">
                        <Link
                            href={logout()}
                            as="button"
                            onClick={() => router.flushAll()}
                            className={`${row} font-medium`}
                            style={{ color: RED }}
                        >
                            <LogOut className="size-5" />
                            Log Out
                        </Link>
                    </div>
                </div>
            </aside>

            <main className="min-w-0 flex-1 px-6 py-6 lg:px-10">
                {children}
            </main>
        </div>
    );
}
