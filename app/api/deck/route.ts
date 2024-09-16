import { response } from "@/server/lib/response";
import { prisma } from "@/server/lib/prisma";
import { NextRequest, NextResponse } from "next/server";

export const GET = async (req: NextRequest, res: NextResponse) => {
    const decks = await prisma.deck.findMany();
    return response.status200(decks);
}

export const POST = async (req: NextRequest, res: NextResponse) => {
    // Parse the incoming form data
    const {
        slug,
        name,
        description,
        createdById,
    } = await req.json();

    // get additional data from the form
    const data = {
        slug,
        name,
        description,
        createdById,
    };
    const createdDeck = await prisma.deck.create({
        data
    });
    return response.status200(createdDeck);
}