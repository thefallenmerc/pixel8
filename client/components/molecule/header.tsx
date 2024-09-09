"use client";
import { signOut } from 'next-auth/react';
import Link from 'next/link';
import React from 'react';

export function DashboardHeader() {
    return (
        <div className="sticky top-0 z-50 w-full border-border/40 bg-background/95 backdrop-blur supports-[backdrop-filter]:bg-background/60">
            <div className="flex h-14 items-center px-4">
                <div className="mr-4 hidden md:flex">
                    <Link href="/" className="mr-4 flex items-center space-x-2 lg:mr-6">Home</Link>
                </div>
                {/* links */}
                <nav className="flex items-center gap-4 text-sm lg:gap-6">
                    <Link href="/app/my" className="transition-colors hover:text-foreground/80 text-foreground/60">Apps</Link>
                </nav>
                <div className="flex flex-1 items-center justify-between space-x-2 md:justify-end">
                    <div onClick={() => {
                        signOut();
                    }} className="transition-colors hover:text-foreground/80 text-red-500 text-xs cursor-pointer">Signout</div>
                </div>
            </div>
        </div>
    )
}