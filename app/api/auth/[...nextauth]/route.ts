import NextAuth, { AuthOptions, Session } from "next-auth";
import { PrismaAdapter } from "@next-auth/prisma-adapter";
import CredentialsProvider from "next-auth/providers/credentials";
import { prisma } from "@/server/lib/prisma";
import { NextApiRequest, NextApiResponse } from "next";
import { JWT } from "next-auth/jwt";
import { AdapterUser } from "next-auth/adapters";

export const authOptions = {
    providers: [
        CredentialsProvider({
            name: "Credentials",
            credentials: {
                email: { label: "Email", type: "text" },
                password: { label: "Password", type: "password" },
            },
            async authorize(credentials) {
                const res = await fetch(
                    `${process.env.NEXT_PUBLIC_NEXTAUTH_URL}/api/user/login`,
                    {
                        method: "POST",
                        body: JSON.stringify(credentials),
                        headers: {
                            "Content-Type": "application/json",
                        },
                    }
                );

                const user = await res.json();

                if (res.ok && user) {
                    return user;
                } else {
                    return null;
                }
            }
        }),
    ],

    adapter: PrismaAdapter(prisma),
    secret: process.env.NEXTAUTH_SECRET,
    session: { strategy: "jwt", maxAge: 24 * 60 * 60 },

    jwt: {
        secret: process.env.NEXTAUTH_SECRET,
        maxAge: 60 * 60 * 24 * 30,
        encryption: true,
    },

    pages: {
        signIn: "/login",
        signOut: "/login",
        error: "/login",
    },

    callbacks: {
        async signIn({ account, profile, user }) {
            // console.log("user signed in: " + user.email);
            return true;
        },
        async session({
            session,
            user,
            token
        }: {
            session: Session,
            user: AdapterUser,
            token: JWT
        }) {
            return ({
                ...session,
                user: {
                    ...session.user,
                    id: token.sub,
                },
                token,
            });
        },

        async jwt({
            token,
            user
        }: {
            token: JWT,
            user: AdapterUser
        }) {
            return token;
        },
    },
} as AuthOptions;

const handler = (req: NextApiRequest, res: NextApiResponse) => NextAuth(req, res, authOptions);

export { handler as GET, handler as POST }