import {
    Contact,
    LayoutGrid,
    List,
    Presentation,
    User,
    Users,
} from 'lucide-react';
import type { LucideIcon } from 'lucide-react';
import type { Viewer } from '@/types/reports';

export type ReportsNavItem = { title: string; icon: LucideIcon; href?: string };
export type ReportsNavGroup = { heading?: string; items: ReportsNavItem[] };

export const NAV: Record<Viewer['role'], ReportsNavGroup[]> = {
    faculty: [
        {
            items: [
                {
                    title: 'Dashboard',
                    icon: LayoutGrid,
                    href: '/dashboard/faculty',
                },
                { title: 'View Classes', icon: Presentation },
                { title: 'Record List', icon: List },
                { title: 'Event Attendance', icon: Users },
            ],
        },
    ],
    admin: [
        {
            items: [
                {
                    title: 'Dashboard',
                    icon: LayoutGrid,
                    href: '/dashboard/admin',
                },
                { title: 'School Logs', icon: Presentation },
                { title: 'Record List', icon: List },
            ],
        },
        {
            heading: 'Management',
            items: [
                { title: 'Event', icon: Users },
                { title: 'Student', icon: Contact },
                { title: 'Accounts', icon: User },
            ],
        },
    ],
};
