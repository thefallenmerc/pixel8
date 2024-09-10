import React from 'react';

export default function AuthLayout({
    children
}: {
    children: React.ReactNode
}) {
    return (
        <div className="flex justify-center items-center m-auto p-3 h-screen">
            {children}
        </div>
    )
}