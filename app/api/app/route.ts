import { prisma } from "@/server/lib/prisma";
import { response } from "@/server/lib/response";
import { NextRequest } from "next/server";

export const POST = async (req: NextRequest) => {
    // Parse the incoming form data
    const {
        name,
        description,
        slug,
        screenId,
        isPublished,
        createdById } = await req.json();

    // check if slug already taken
    const existingApp = await prisma.app.findFirst({
        where: {
            slug
        }
    });

    if (existingApp) {
        return response.status400({ message: "Slug already taken" });
    }

    // create app
    const app = await prisma.app.create({
        data: {
            name,
            description,
            slug,
            screenId,
            isPublished,
            createdById
        }
    });

    return response.status201(app);
}