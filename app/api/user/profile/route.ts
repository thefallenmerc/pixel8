import { response } from "@/server/lib/response";
import { NextRequest, NextResponse } from "next/server";
import { resolveSession } from "@/server/lib/session";
import { prisma } from "@/server/lib/prisma";
import { UserResource } from "@/server/resources/user-resource";

export const GET = async (req: NextRequest, res: NextResponse) => {
    // Session info
    const session = await resolveSession();

    if (!session) {
        return response.status401({ message: "Unauthorized" });
    }

    const userId = session?.token?.sub;

    const user = await prisma.user.findFirst({
        where: {
            id: userId
        }
    });

    if (!user) {
        return response.status404({ message: "User not found" });
    }

    return response.status200(UserResource(user));
}