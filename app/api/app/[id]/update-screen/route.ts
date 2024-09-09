import { prisma } from "@/server/lib/prisma";
import { response } from "@/server/lib/response";
import { NextRequest, } from "next/server";

export const POST = async (req: NextRequest, context: any) => {
    // get json data
    const payload = await req.json();

    const { screenId } = payload;

    // get id from params
    const id = context.params.id;

    // check if app exists
    const app = await prisma.app.findFirst({
        where: {
            id
        }
    });

    if (!app) {
        return response.status404({ message: "App not found" });
    }

    // update app
    const updatedApp = await prisma.app.update({
        where: {
            id
        },
        data: {
            screenId: screenId ? screenId : null,
        },
        include: {
            screen: true
        }
    });

    // call socket endpoint
    await fetch("http://192.168.11.207:5000/emit-event", {
        method: "POST",
        headers: {
            "Content-Type": "application/json",
        },
        body: JSON.stringify({ eventName: "app-updated", data: updatedApp }),
    });

    return response.status200(updatedApp);
}