import { Screen } from "@/client/components/screen";
import { getAppBySlug } from "@/server/services/app.service";

export default async function ({ params }: { params: { slug: string } }) {

    const app = await getAppBySlug(params.slug);


    return (
        app?.screen ? <Screen screen={app.screen} /> : <>No Screen</>
    )
}