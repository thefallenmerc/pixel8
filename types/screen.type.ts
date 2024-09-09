import { getScreenByCreatedById } from "@/server/services/screen.service";

export type ScreenTypeArray = Awaited<ReturnType<typeof getScreenByCreatedById>>;