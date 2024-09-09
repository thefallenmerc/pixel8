import { PrismaClient } from "@prisma/client";

let prisma: PrismaClient;


// following code is to make sure next js hot reloading 
// doesn't create a new prisma instance every hot reload:
if (process.env.NODE_ENV === "production") {
    prisma = new PrismaClient()
} else {
    if (!global.prisma) {
        global.prisma = new PrismaClient()
    }

    prisma = global.prisma
}

export { prisma };
