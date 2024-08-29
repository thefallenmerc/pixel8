import { prisma } from "../lib/prisma";

export const getAppBySlug = async (slug: string) => {
    return prisma.app.findFirst({
        where: {
            slug
        },
        include: {
            screen: true,
        }
    });
}