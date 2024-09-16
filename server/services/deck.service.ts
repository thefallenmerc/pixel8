import { prisma } from "../lib/prisma";

export async function getAllDecks() {
    return prisma.deck.findMany({});
}

export async function getTilesByDeckId(deckId: string) {
    return prisma.tile.findMany({
        where: {
            deckId
        },
    });
}