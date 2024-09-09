import { getAllAppsPaginated } from "@/server/services/app.service";
import { getAllScreensPaginated } from "@/server/services/screen.service";
import Link from "next/link";

export default async function AllAppHomePage() {
    const apps = await getAllAppsPaginated(1);

    return (
        <div className="Component flex gap-4 p-4">
            {apps.map((app) => {
                return (
                    <Link
                        href={`/app/${app.slug}`}
                        target="_blank"
                        key={app.id}
                        className="overflow-hidden rounded bg-white text-slate-500 shadow-md shadow-slate-200 w-[200px]">
                        <figure>
                            <img
                                src={app.screen?.uri}
                                alt="card image"
                                className="aspect-video w-full"
                            />
                            <div className="p-6">
                                <header className="">
                                    <h3 className="text-xl font-medium text-slate-700">
                                        {app.name}
                                    </h3>
                                    <p className="text-sm text-slate-400"> On {app.createdAt.toDateString()}</p>
                                </header>
                            </div>
                        </figure>
                    </Link>
                )
            })}
        </div>
    )

}