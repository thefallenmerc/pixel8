import { getAllDecks, getTilesByDeckId } from "@/server/services/deck.service";

export type DeckType = Awaited<ReturnType<typeof getAllDecks>>[number];
export type TileType = Awaited<ReturnType<typeof getTilesByDeckId>>[number];