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

export async function getAppByCreatedById(createdById: string) {
    return prisma.app.findMany({
        where: {
            createdById,
        },
        include: {
            screen: true,
        },
    });
}

export async function getAllAppsPaginated(page: number) {
    return prisma.app.findMany({
        skip: (page - 1) * 10,
        take: 10,
        include: {
            screen: true,
        }
    });
}