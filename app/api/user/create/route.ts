// We impot our prisma client
import { prisma } from "@/server/lib/prisma";
// Prisma will help handle and catch errors
import { Prisma } from "@prisma/client";
import { NextRequest, NextResponse } from "next/server";
import { response } from "@/server/lib/response";
import { handleError } from "@/server/lib/error-handler";
import { hashPassword } from "@/server/lib/password";
export async function GET(req: NextRequest, res: NextResponse) {
    return response.status405({ message: "Method Not allowed" });
}

export async function POST(req: NextRequest, res: NextResponse) {
    // create user
    return await createUserHandler(req, res);
}
// function to create user in our database
async function createUserHandler(req: NextRequest, res: NextResponse) {
    let errors = [];
    const payload = await req.json();
    const { name, email, password } = payload;

    if (password.length < 6) {
        errors.push("password length should be more than 6 characters");
        return response.status400({ errors });
    }
    try {
        const user = await prisma.user.create({
            data: { ...payload, password: hashPassword(password) },
        });
        return response.status201({ user });
    } catch (e) {
        return handleError(e);
    }
}