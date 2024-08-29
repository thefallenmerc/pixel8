import { prisma } from "../lib/prisma";

export async function getScreenBySlug(slug: string) {
    return prisma.screen.findFirst({
        where: {
            slug
        }
    });
}

export async function getScreenByCreatedById(createdById: string) {
    return prisma.screen.findMany({
        where: {
            createdById
        }
    });
}

export async function getAllScreensPaginated(page: number) {
    return prisma.screen.findMany({
        skip: (page - 1) * 10,
        take: 10
    });
}
