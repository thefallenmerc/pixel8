import { Prisma } from "@prisma/client";
import { response } from "./response";

export function handleError(e: any) {
    // check for prisma error
    if (e instanceof Prisma.PrismaClientKnownRequestError) {
        // check for unique constraint fail
        if (e.code === "P2002") {
            const targets = e.meta?.target as string[];
            const firstTarget = targets[0];
            return response.status400({ message: `${firstTarget} already exists` });
        }
        // else handle other errors
        return response.status400({ message: e.message });
    }
    // else just return response
    return response.status500({ message: e.message });
}