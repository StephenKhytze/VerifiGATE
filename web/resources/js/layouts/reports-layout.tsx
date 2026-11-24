import '@fontsource/afacad/400.css';
import '@fontsource/afacad/500.css';
import '@fontsource/afacad/600.css';
import '@fontsource/afacad/700.css';
import { Link, router, usePage } from '@inertiajs/react';
import { CircleUser, LogOut, Menu, X } from 'lucide-react';
import { useState } from 'react';
import type { ReactNode } from 'react';
import { GRAY, GREEN, RED } from '@/components/reports/colors';
import { NAV } from '@/components/reports/nav';
import type { ReportsNavGroup } from '@/components/reports/nav';
import { logout } from '@/routes';
import type { Viewer } from '@/types/reports';

const FONT = "'Afacad', ui-sans-serif, system-ui, sans-serif";
const ROW = 'flex h-14 w-full items-center gap-3 px-8 text-xl';

function Logo({ className }: { className: string }) {
    return (
        <div className={className}>
            <span className="font-light">Verifi</span>
            <span className="font-bold">GATE</span>
        </div>
    );
}

function NavLinks({
    groups,
    path,
    onNavigate,
}: {
    groups: ReportsNavGroup[];
    path: string;
    onNavigate?: () => void;
}) {
    return (
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
                                onClick={onNavigate}
                                aria-current={
                                    path === href ? 'page' : undefined
                                }
                                className={ROW}
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
                                className={`${ROW} cursor-not-allowed text-neutral-400`}
                            >
                                <Icon className="size-5" />
                                {title}
                            </span>
                        ),
                    )}
                </div>
            ))}
        </nav>
    );
}

function Account({
    viewer,
    onNavigate,
}: {
    viewer: Viewer;
    onNavigate?: () => void;
}) {
    return (
        <div className="border-t border-neutral-200">
            <div className="flex items-center gap-3 px-6 py-4">
                <CircleUser className="size-10 shrink-0" strokeWidth={1.5} />
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
                    onClick={() => {
                        onNavigate?.();
                        router.flushAll();
                    }}
                    className={`${ROW} font-medium`}
                    style={{ color: RED }}
                >
                    <LogOut className="size-5" />
                    Log Out
                </Link>
            </div>
        </div>
    );
}

export default function ReportsLayout({ children }: { children: ReactNode }) {
    const page = usePage<{ viewer: Viewer }>();
    const { viewer } = page.props;
    const path = page.url.split('?')[0];
    const groups = NAV[viewer.role];
    const [menuOpen, setMenuOpen] = useState(false);
    const closeMenu = () => setMenuOpen(false);

    return (
        <div
            className="flex min-h-screen flex-col bg-[#F2F2F2] text-black md:flex-row"
            style={{ fontFamily: FONT }}
        >
            <a
                href="#main"
                className="sr-only focus:not-sr-only focus:absolute focus:top-2 focus:left-2 focus:z-50 focus:rounded focus:bg-white focus:px-3 focus:py-2"
            >
                Skip to content
            </a>

            <header className="flex items-center justify-between bg-white px-5 py-3 shadow md:hidden">
                <Logo className="text-3xl leading-none" />
                <button
                    type="button"
                    aria-expanded={menuOpen}
                    aria-controls="mobile-menu"
                    aria-label={menuOpen ? 'Close menu' : 'Open menu'}
                    onClick={() => setMenuOpen((open) => !open)}
                    className="flex size-11 items-center justify-center rounded-lg border border-neutral-300"
                >
                    {menuOpen ? (
                        <X className="size-6" />
                    ) : (
                        <Menu className="size-6" />
                    )}
                </button>
            </header>

            {menuOpen && (
                <div id="mobile-menu" className="bg-white shadow md:hidden">
                    <NavLinks
                        groups={groups}
                        path={path}
                        onNavigate={closeMenu}
                    />
                    <Account viewer={viewer} onNavigate={closeMenu} />
                </div>
            )}

            <aside className="sticky top-0 hidden h-screen w-64 shrink-0 flex-col bg-white shadow-[6px_0_16px_rgba(0,0,0,0.08)] md:flex">
                <Logo className="px-8 pt-10 pb-8 text-4xl leading-none" />
                <NavLinks groups={groups} path={path} />
                <Account viewer={viewer} />
            </aside>

            <main
                id="main"
                tabIndex={-1}
                className="min-w-0 flex-1 px-4 py-6 outline-none md:px-6 lg:px-10"
            >
                {children}
            </main>
        </div>
    );
}
