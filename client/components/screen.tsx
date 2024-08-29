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
            document.documentElement.requestFullscreen();
        }
    }

    return (
        screen ?
            <div
                className={
                    `w-screen h-screen bg-cover bg-center p-4 bg-red-400`
                }
                style={{
                    backgroundImage: `url('${"/" + screen.uri}')`
                }}
                onClick={toggleFullscreen} />
            : <>No Screen</>
    );
}