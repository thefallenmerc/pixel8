import { getAllScreensPaginated } from "@/server/services/screen.service";
import Link from "next/link";

export default async function ScreenHomePage() {
    const screens = await getAllScreensPaginated(1);

    return (
        <div className="Component flex gap-4 p-4">
            {screens.map((screen) => {
                return (
                    <Link href={`/screen/${screen.slug}`} key={screen.id} className="overflow-hidden rounded bg-white text-slate-500 shadow-md shadow-slate-200 w-[200px]">
                        <figure>
                            <img
                                src={screen.uri}
                                alt="card image"
                                className="aspect-video w-full"
                            />
                            <div className="p-6">
                                <header className="">
                                    <h3 className="text-xl font-medium text-slate-700">
                                        {screen.name}
                                    </h3>
                                    <p className="text-sm text-slate-400"> On {screen.createdAt.toDateString()}</p>
                                </header>
                            </div>
                        </figure>
                    </Link>
                )
            })}
        </div>
    )

}