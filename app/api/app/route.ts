import { prisma } from "@/server/lib/prisma";
import { response } from "@/server/lib/response";
import { resolveSession } from "@/server/lib/session";
import { NextRequest } from "next/server";

export const POST = async (req: NextRequest) => {
    // Parse the incoming form data
    const {
        name,
        description,
        tags,
        slug,
        screenId,
        isPublished } = await req.json();

    // get user session
    const session = await resolveSession();
    const userId = session?.token?.sub as string;

    if (!userId) {
        return response.status401({
            message: "Unauthenticated"
        });
    }

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
            tags,
            slug,
            screenId,
            isPublished,
            createdById: userId,
        }
    });

    return response.status201(app);
}