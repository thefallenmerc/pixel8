// middleware.ts
import { NextResponse } from 'next/server';
import type { NextRequest } from 'next/server';

const protectedUIRoutes = [
    '/app/my',
];

function isRouteProtected(pathname: string): boolean {
    return protectedUIRoutes.includes(pathname);
}

// Middleware function to handle route protection
export function middleware(req: NextRequest) {
    const { pathname } = req.nextUrl;

    // Apply middleware only to protected routes (example: /dashboard)
    if (isRouteProtected(pathname)) {
        // Example: checking for a token in cookies (customize as needed)
        const token = req.cookies.get('next-auth.session-token')?.value;

        // If no token is found, redirect to the login page
        if (!token) {
            return NextResponse.redirect(new URL('/auth/login?origin=' + pathname, req.url));
        }
    }

    // Continue if the user is authenticated or accessing a public route
    return NextResponse.next();
}

// Configuration to specify which routes to apply middleware to
export const config = {
    matcher: ['/app/my'], // Apply middleware to /dashboard and all sub-routes
};
