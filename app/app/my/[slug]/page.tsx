import { getAppBySlug } from '@/server/services/app.service';
import React from 'react';
import MyAppDetailPageClientComponent from './page-client';
import { getScreenByCreatedById } from '@/server/services/screen.service';
import type { Metadata } from 'next'

export async function generateMetadata({ params }: { params: { slug: string } }): Promise<Metadata> {
    const app = await getAppBySlug(params.slug);
    return {
        title: app?.name,
        description: app?.description
    }
}

export default async function MyAppDetailPage({ params }: { params: { slug: string } }) {

    const app = await getAppBySlug(params.slug);
    const screens = await getScreenByCreatedById(app?.createdById ?? "");

    return <MyAppDetailPageClientComponent app={app} screens={screens} />
}