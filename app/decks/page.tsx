import { DeckView } from '@/client/components/client-views/deck';
import { SelectInput } from '@/client/components/ui/input/select';
import React from 'react';
import { prisma } from "@/server/lib/prisma";

export default async function Decks() {

    const decks = await prisma.deck.findMany();

    return (
        <div className="Decks container mx-auto p-2">
            <DeckView decks={decks} />
        </div>
    )
}
