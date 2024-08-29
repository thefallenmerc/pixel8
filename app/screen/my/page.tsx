import { prisma } from '@/server/lib/prisma';
import { resolveSession } from '@/server/lib/session';
import { getScreenByCreatedById } from '@/server/services/screen.service';
import React from 'react';

export default async function ScreenList() {

    const session = await resolveSession();

    const screens = await getScreenByCreatedById(session?.token?.sub ?? "");

    return (
        <div className="Component">
            Yo {screens.length}
        </div>
    )
}