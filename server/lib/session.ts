import { authOptions } from "@/app/api/auth/[...nextauth]/route";
import { getServerSession } from "next-auth";

type Session = {
    user: {
        name: string;
        email: string;
        image: string | null;
        id: string;
    },
    token: {
        name: string;
        email: string;
        image: string | null;
        sub: string;
        iat: number;
        exp: number;
        jti: string;
    }
}

export async function resolveSession() {
    const session = await getServerSession(authOptions);

    return session as Session | null;
}