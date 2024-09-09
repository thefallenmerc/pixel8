"use client";

import React, { useMemo } from 'react';
import { useEffect, useState } from "react";
import { io, Socket } from 'socket.io-client';
import { getAppBySlug } from '../services/app.service';
import { AppType } from '@/types/app.type';
import { Screen } from './screen';
import { connectSocket } from '../lib/socket';

// Define the type for the socket state
let socket: Socket;

export function AppScreen({ slug, app }: { slug: string, app: AppType }) {

    const [activeApp, setApp] = useState<AppType>(app);

    // Function to send a message to the server
    const sendMessage = () => {
        socket.emit('message', "Hi, I'm connecting");
    };

    // Connect to the Socket.IO server when the component mounts
    useEffect(() => {
        socket = connectSocket();

        // Listen for 'message' events from the server
        socket.on('app-updated', (stringifiedApp: AppType) => {
            console.log("App Updated: ", stringifiedApp);
            setApp(stringifiedApp);
        });
        sendMessage();

        // Cleanup the connection when the component unmounts
        return () => {
            socket.disconnect();
        };
    }, []);

    const stringifiedActiveApp = useMemo(() => JSON.stringify(activeApp), [activeApp]);

    // refresh at intervals
    useEffect(() => {
        const interval = setInterval(() => {
            setApp(JSON.parse(JSON.stringify({
                ...JSON.parse(stringifiedActiveApp),
                updatedAt: new Date(),
            })));
            console.log("refreshing...");
        }, 10000);
        console.log("interval refreshed");
        return () => clearInterval(interval);
    }, [stringifiedActiveApp]);

    // get latest app using slug?
    // useEffect(() => {
    //     getAppBySlug(slug).then((app) => {
    //         console.log(app);
    //     });
    // }, [slug]);

    return (
        activeApp?.screen ? <Screen screen={activeApp.screen} /> : <>No Screen</>
    )
}