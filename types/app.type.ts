import { getAllAppsPaginated, getAppBySlug } from "@/server/services/app.service";

export type AppType = Awaited<ReturnType<typeof getAppBySlug>>;
export type AppTypeArray = Awaited<ReturnType<typeof getAllAppsPaginated>>;