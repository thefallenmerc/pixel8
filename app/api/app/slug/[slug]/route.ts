import { prisma } from "@/server/lib/prisma";
import { response } from "@/server/lib/response";
import { NextRequest } from "next/server";

export const GET = async (req: NextRequest, context: any) => {
    // get id from params
    const slug = context.params.slug;

    // check if app exists
    const app = await prisma.app.findFirst({
        where: {
            slug
        }
    });

    if (!app) {
        return response.status404({ message: "App not found" });
    }

    return response.status200(app);
}