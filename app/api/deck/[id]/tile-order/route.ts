import { NextRequest } from "next/server";
import { prisma } from "@/server/lib/prisma";
import { response } from "@/server/lib/response";

export const POST = async (req: NextRequest, context: any) => {
    // get id from params
    const id = context.params.id;
    const tileIds = await req.json();
    // check if deck exists
    const deck = await prisma.deck.findFirst({
        where: {
            id,
        },
    });

    if (!deck) {
        return response.status404({ message: "Failed to execute" });
    }

    // get all the tiles and update order value accordingly
    const tiles = await prisma.tile.findMany({
        where: {
            deckId: id
        }
    });
    for (let i = 0; i < tiles.length; i++) {
        const order = tileIds.indexOf(tiles[i].id);
        // update order
        await prisma.tile.update({
            where: {
                id: tiles[i].id
            },
            data: {
                order,
            }
        });
    }

    return response.status200({ message: "Success" });
}