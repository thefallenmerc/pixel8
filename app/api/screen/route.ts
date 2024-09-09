import { NextRequest, NextResponse } from "next/server";
import path from "path";
import { writeFile } from "fs/promises";
import { response } from "@/server/lib/response";
import { prisma } from "@/server/lib/prisma";
import { randomUUID } from 'crypto';

export const GET = async (req: NextRequest, res: NextResponse) => {
    const screens = await prisma.screen.findMany();
    return response.status200(screens);
}

export const POST = async (req: NextRequest, res: NextResponse) => {
    // Parse the incoming form data
    const formData = await req.formData();
    // Get the file from the form data
    const file = formData.get("file") as File;

    // Check if a file is received
    if (!file) {
        // If no file is received, return a JSON response with an error and a 400 status code
        return NextResponse.json({ error: "No files received." }, { status: 400 });
    }

    // Convert the file data to a Buffer
    const buffer = Buffer.from(await file.arrayBuffer());

    // Replace spaces in the file name with underscores
    const filename = file.name.replaceAll(" ", "_");
    console.log(filename);

    try {
        // Write the file to the specified directory (public/assets) with the modified filename
        const assetsDirName = path.join("assets", "screens");
        const newFileName = randomUUID() + "-" + filename;
        const filePath = path.join(process.cwd(), "public", assetsDirName, newFileName);
        const uri = path.join(assetsDirName, newFileName);
        await writeFile(
            filePath,
            buffer
        );

        // get additional data from the form
        const slug = formData.get("slug") as string;
        const name = formData.get("name") as string;
        const description = formData.get("description") as string;
        const fitType = formData.get("fitType") as string;
        const referenceUrl = formData.get("referenceUrl") as string;
        const isPortrait = Boolean(formData.get("isPortrait") as string);
        const data = {
            name: name || getNameFromSlug(slug),
            description: description || name || getNameFromSlug(slug),
            slug,
            uri,
            fitType,
            referenceUrl,
            isPortrait,
            createdById: formData.get("createdById") as string,
        };

        // insert into db
        const screen = await prisma.screen.create({
            data,
        });

        // Return a JSON response with a success message and a 201 status code
        return response.status201(screen);
    } catch (error) {
        // If an error occurs during file writing, log the error and return a JSON response with a failure message and a 500 status code
        console.log("Error occurred ", error);
        return response.status500({ message: "Failed" });
    }
};

function getNameFromSlug(slug: string) {
    // replace - with splaces and capitalize
    return slug.replaceAll("-", " ").split(" ").map((word) => word.charAt(0).toUpperCase() + word.slice(1)).join(" ");
}
