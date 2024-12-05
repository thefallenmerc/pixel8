import { prisma } from "@/server/lib/prisma";
import { response } from "@/server/lib/response";
import { NextRequest } from "next/server";

export const POST = async (req: NextRequest, context: any) => {
    // get id from params
    const id = context.params.id;

    // get payload
    const payload = await req.json();
    const { name, tags, description, slug } = payload;

    // check if app exists
    const app = await prisma.app.findFirst({
        where: {
            id
        }
    });

    if (!app) {
        return response.status404({ message: "App not found" });
    }

    // if slug is different, check if the slug taken by another app
    const anotherApp = await prisma.app.findFirst({
        where: {
            id: {
                not: id
            },
            slug,
        }
    });

    if (anotherApp) {
        return response.status400({ message: "Slug already taken" });
    }

    // update app
    const updatedApp = await prisma.app.update({
        where: {
            id
        },
        data: {
            name,
            tags,
            description,
            slug,
        },
        include: {
            screen: true
        }
    });

    // call socket endpoint
    await fetch("http://192.168.2.1:5000/emit-event", {
        method: "POST",
        headers: {
            "Content-Type": "application/json",
        },
        body: JSON.stringify({ eventName: "app-updated", data: updatedApp }),
    });

    return response.status200(updatedApp);
}