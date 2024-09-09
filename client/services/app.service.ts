import { AppType } from "@/types/app.type";

export async function getAppBySlug(slug: string) {
    console.log("`/api/app/slug/${slug}`", `/api/app/slug/${slug}`);
    const response = await fetch(`/api/app/slug/${slug}`);
    return response.json() as Promise<AppType>;
}