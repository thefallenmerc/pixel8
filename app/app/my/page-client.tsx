"use client";

import { GridCard } from '@/client/components/atoms/grid-card';
import { convertStringToTimestamp } from '@/client/lib/server-response-helper';
import { AppType, AppTypeArray } from '@/types/app.type';
import { useRouter } from 'next/navigation';
import React, { useState } from 'react';

type Prop = {
    apps: AppTypeArray
};

export function MyAppListClientComponent({
    apps: appsProp
}: Prop) {

    const router = useRouter();

    const [apps, setApp] = useState(appsProp);

    const [selectedApp, setSelectedApp] = useState<AppType>(null);

    const changeScreen = async () => {
        if (selectedApp) {
            const response = await fetch(`/api/app/${selectedApp.id}/update-screen`, {
                method: "POST",
                headers: {
                    "Content-Type": "application/json",
                },
                body: JSON.stringify({
                    screenId: selectedApp.screen?.id === "c7dcae5e-551c-44ac-8e14-82e19e293028" ? "6243b5fc-426a-4bf5-8358-63156ebc3f44" : "c7dcae5e-551c-44ac-8e14-82e19e293028"
                }),
            });
            const updatedApp = await response.json();
            setSelectedApp(convertStringToTimestamp(updatedApp));
            setApp(apps.map(app => app.id === updatedApp.id ? updatedApp : app));
        }
    };

    return (
        <div className="flex">
            {/* grid */}
            <div className="gap-4 p-4 flex-grow flex">
                {apps.map((app) => {
                    return (
                        <GridCard
                            key={app.id}
                            onClick={() => {
                                // setSelectedApp(app);
                                router.push("/app/my/" + app.slug);
                            }}
                            title={app.name}
                            imgUrl={"/" + app.screen?.uri}
                            width="w-1/4"
                        />
                    )
                })}
            </div>
            {/* details */}
            <div className={`flex-shrink-0 ${selectedApp ? "w-1/3" : "w-0"} transition-all p-4`}>
                {/* content */}
                <div className={`rounded bg-white shadow-md shadow-slate-200 transition-all ${selectedApp ? "p-4 d-block" : "hidden"}`}>
                    {/* header */}
                    <div className="flex justify-between items-center pb-2 border-b">
                        <div className="text-xl">Details - {selectedApp?.name}</div>
                        <div
                            onClick={() => setSelectedApp(null)}
                            className="text-xs text-red-400 rounded px-4 py-2 bg-red-50 transition-all hover:bg-red-100 cursor-pointer">
                            Close
                        </div>
                    </div>
                    {/* body */}
                    <div className="py-2">
                        {/* slug */}
                        <div className="flex">
                            <div className="font-semibold pr-2">Slug:</div>
                            <div className="text-blue-500 underline">{selectedApp?.slug}</div>
                        </div>

                        {/* tags */}
                        <div className="flex gap-2 py-2">
                            {
                                selectedApp?.tags?.split(",").map((tag) => {
                                    return <div className="text-slate-500 bg-slate-50 px-4 py-2 rounded text-xs">{tag}</div>
                                }) ?? <>No tags</>
                            }
                        </div>

                        {/* description */}
                        <div className="flex">
                            <div className="font-semibold pr-2">Description:</div>
                            <div className="text-slate-500">{selectedApp?.description ?? "-"}</div>
                        </div>

                        {/* screen */}
                        <div className="flex items-center gap-2">
                            <div className="font-semibold">Screen:</div>
                            <div className="text-blue-500 underline">{selectedApp?.screen?.name ?? "-"}</div>
                            {/* change screen button */}
                            <div
                                onClick={() => changeScreen()}
                                className="text-xs text-blue-400 rounded px-4 py-2 bg-blue-50 transition-all hover:bg-blue-100 cursor-pointer">
                                Change
                            </div>
                        </div>

                        {/* created At */}
                        <div className="flex">
                            <div className="font-semibold pr-2">Created At:</div>
                            <div className="text-slate-500">{selectedApp?.createdAt.toDateString() ?? "-"}</div>
                        </div>
                        {/* updated At */}
                        <div className="flex">
                            <div className="font-semibold pr-2">Updated At:</div>
                            <div className="text-slate-500">{selectedApp?.updatedAt.toDateString() ?? "-"}</div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    )
}