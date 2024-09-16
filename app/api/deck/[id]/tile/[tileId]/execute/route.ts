import { prisma } from "@/server/lib/prisma";
import { response } from "@/server/lib/response";
import { NextRequest } from "next/server";

export const POST = async (req: NextRequest, context: any) => {
    // get id from params
    const id = context.params.tileId;

    // check if tile exists
    const tile = await prisma.tile.findFirst({
        where: {
            id
        }
    });

    if (!tile) {
        return response.status404({ message: "Failed to execute" });
    }

    switch (tile.type) {
        case "get-api": {
            const resp = await fetch(tile.command!);
            const result = await resp.json();
            if (resp.status === 200) {
                return response.status200({
                    message: "Success",
                });
            } else {
                return response.status500(result);
            }
        }
    }

    return response.status404({ message: "Failed to execute" });
}