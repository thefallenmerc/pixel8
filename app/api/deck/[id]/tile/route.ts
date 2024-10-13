import { prisma } from "@/server/lib/prisma";
import { response } from "@/server/lib/response";
import { NextRequest } from "next/server";

export const GET = async (req: NextRequest, context: any) => {

    // get id from params
    const id = context.params.id;

    // check if deck exists
    const deck = await prisma.deck.findFirst({
        where: {
            id
        }
    });

    if (!deck) {
        return response.status404({ message: "Deck not found" });
    }

    const tiles = await prisma.tile.findMany({
        where: {
            deckId: id
        },
        orderBy: {
            order: "asc"
        }
    });

    return response.status200(tiles);
}

export const POST = async (req: NextRequest, context: any) => {

    const payload = await req.json();

    // get id from params
    const id = context.params.id;

    // check if deck exists
    const deck = await prisma.deck.findFirst({
        where: {
            id
        }
    });

    if (!deck) {
        return response.status404({ message: "Deck not found" });
    }

    // create tile
    const createdTile = await prisma.tile.create({
        data: {
            deckId: id,
            ...payload
        }
    });

    // TODO: call socket endpoint

    return response.status200(createdTile);
}