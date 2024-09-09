"use client";

import { getScreenBySlug } from '@/server/services/screen.service';
import React from 'react';

export function Screen({
    screen
}: {
    screen: Awaited<ReturnType<typeof getScreenBySlug>>
}) {

    const toggleFullscreen = () => {
        // if we are in full screen, go out
        if (document.fullscreenElement) {
            document.exitFullscreen();
        } else {
            // if we are not in full screen, go in
            document.documentElement.requestFullscreen({ navigationUI: 'hide' });
        }
    }

    return (
        screen ?
            (
                screen.fitType === "contain" ? (
                    <div
                        onClick={toggleFullscreen}>
                        <div className="absolute inset-0">
                            <img src={"/" + screen.uri} alt="Background" className="w-full h-full object-cover blur-md scale-110" />
                        </div>
                        <div className="relative flex justify-center items-center w-screen h-screen">
                            <img src={"/" + screen.uri} alt="Contained" className="object-contain max-w-full max-h-full" />
                        </div>
                    </div>
                ) :
                    < div
                        className={
                            `w-screen h-screen bg-cover bg-center p-4 bg-red-400`
                        }
                        style={{
                            backgroundImage: `url('${"/" + screen.uri}')`
                        }}
                        onClick={toggleFullscreen} />
            )
            : <>No Screen</>
    );
}