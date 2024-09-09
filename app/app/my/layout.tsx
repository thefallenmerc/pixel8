import { DashboardHeader } from '@/client/components/molecule/header';
import React, { ReactNode } from 'react';

export default function MyDashboardLayout({
    children
}: {
    children: ReactNode;
}) {
    return (
        <div className="MyDashboardLayout">
            {/* header */}
            <DashboardHeader />
            {/* children */}
            {children}
        </div>
    )
}