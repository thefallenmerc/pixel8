import { GridCard } from '@/client/components/atoms/grid-card';
import { prisma } from '@/server/lib/prisma';
import { resolveSession } from '@/server/lib/session';
import { getAppByCreatedById } from '@/server/services/app.service';
import { getScreenByCreatedById } from '@/server/services/screen.service';
import Link from 'next/link';
import React from 'react';
import { MyAppListClientComponent } from './page-client';

export default async function MyAppList() {

    const session = await resolveSession();

    const apps = await getAppByCreatedById(session?.token?.sub ?? "");

    return (
        <MyAppListClientComponent apps={apps} />
    )
}