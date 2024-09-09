"use client";

import { GridCard } from "@/client/components/atoms/grid-card";
import { convertStringToTimestamp } from "@/client/lib/server-response-helper";
import { AppType } from "@/types/app.type";
import { ScreenTypeArray } from "@/types/screen.type";
import { useState } from "react";

const filterSensitive = true;

export default function MyAppDetailPageClientComponent({
    app,
    screens,
}: {
    app: AppType,
    screens: ScreenTypeArray
}) {

    const [selectedApp, setSelectedApp] = useState(app);

    const changeScreen = async (screenId: string) => {
        if (selectedApp) {
            const response = await fetch(`/api/app/${selectedApp.id}/update-screen`, {
                method: "POST",
                headers: {
                    "Content-Type": "application/json",
                },
                body: JSON.stringify({
                    screenId
                }),
            });
            const updatedApp = await response.json();
            setSelectedApp(convertStringToTimestamp(updatedApp));
        }
    };

    return (
        <div className="MyAppDetailPage">
            {/* details */}
            <div className={`flex-shrink-0 transition-all p-4`}>
                {/* content */}
                <div className={`rounded bg-white shadow-md shadow-slate-200 transition-all ${app ? "p-4 d-block" : "hidden"}`}>
                    {/* header */}
                    <div className="flex justify-between items-center pb-2 border-b">
                        <div className="text-xl">Details - {app?.name}</div>
                        {/* updated At */}
                        <div className="flex">
                            <div className="font-semibold pr-2">Updated At:</div>
                            <div className="text-slate-500">{app?.updatedAt.toDateString() ?? "-"}</div>
                        </div>
                    </div>
                    {/* body */}
                    <div className="">

                        {/* tags */}
                        <div className="flex gap-2 py-2">
                            {
                                app?.tags?.split(",").map((tag) => {
                                    return <div className="text-slate-500 bg-slate-50 px-4 py-2 rounded text-xs">{tag}</div>
                                }) ?? <>No tags</>
                            }
                        </div>

                        {/* description */}
                        {/* <div className="flex">
                            <div className="font-semibold pr-2">Description:</div>
                            <div className="text-slate-500">{app?.description ?? "-"}</div>
                        </div> */}
                    </div>
                </div>
            </div>
            {/* available screens */}
            <div className="grid grid-cols-5 transition-all p-4 gap-4">
                {
                    screens.filter(s => filterSensitive ? !s.isSensitive : true).map(screen => (
                        <GridCard
                            title={screen.name}
                            subtitle={screen.description ?? ""}
                            imgUrl={"/" + screen.uri}
                            key={screen.id}
                            onClick={() => {
                                changeScreen(screen.id);
                            }}
                            isSelected={screen.id === selectedApp?.screen?.id}
                            width="w-auto"
                            isSensitive={screen.isSensitive} />
                    ))
                }
            </div>
        </div>
    )
}