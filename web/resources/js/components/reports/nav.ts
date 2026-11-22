import { LayoutGrid, List, Presentation, Users } from 'lucide-react';
import type { LucideIcon } from 'lucide-react';
import type { Viewer } from '@/types/reports';

export type ReportsNavItem = { title: string; icon: LucideIcon; href?: string };

export const NAV: Record<Viewer['role'], ReportsNavItem[]> = {
    faculty: [
        { title: 'Dashboard', icon: LayoutGrid, href: '/dashboard/faculty' },
        { title: 'View Classes', icon: Presentation },
        { title: 'Record List', icon: List },
        { title: 'Event Attendance', icon: Users },
    ],
    admin: [], // filled in with the admin dashboard (Stage 4)
};
