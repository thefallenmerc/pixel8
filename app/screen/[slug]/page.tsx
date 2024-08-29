import { Screen } from '@/client/components/screen';
import { prisma } from '@/server/lib/prisma';
import { getScreenBySlug } from '@/server/services/screen.service';
import React from 'react';

export default async function ScreenPage({
    params
}: {
    params: {
        slug: string
    }
}) {

    const screen = await getScreenBySlug(params.slug);


    return (
        <Screen screen={screen} />
    )
}