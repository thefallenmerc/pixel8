import crypto from "crypto";

// We hash the user entered password using crypto.js
export const hashPassword = (password: string) => {
    return crypto.createHash("sha256").update(password).digest("hex");
};