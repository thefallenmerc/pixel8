import { hashPassword } from "@/server/lib/password";
import { prisma } from "@/server/lib/prisma";
import { response } from "@/server/lib/response";
import { NextRequest, NextResponse } from "next/server";

export const POST = async (req: NextRequest, res: NextResponse) => {
    const credentials = await req.json();
    const { email, password } = credentials;
    if (!email || !password) {
        return response.status400({ message: "Please provide email and password" });
    }

    const user = await prisma.user.findUnique({
        where: {
            email,
        },
    });

    if (!user) {
        return response.status401({ message: "Invalid credentials" });
    }

    if (user.password !== hashPassword(password)) {
        return response.status401({ message: "Invalid credentials" });
    }

    return response.status200(user);
}