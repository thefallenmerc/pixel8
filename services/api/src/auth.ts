import { betterAuth } from "better-auth";
import { bearer, emailOTP } from "better-auth/plugins";
import { prismaAdapter } from "better-auth/adapters/prisma";
import { Resend } from "resend";
import nodemailer from "nodemailer";
import { prisma } from "@pixel8/database";
import { config } from "./config.js";

const resend = process.env.RESEND_API_KEY
  ? new Resend(process.env.RESEND_API_KEY)
  : undefined;
const smtp =
  process.env.NODE_ENV !== "production"
    ? nodemailer.createTransport({
        host: process.env.SMTP_HOST ?? "127.0.0.1",
        port: Number(process.env.SMTP_PORT ?? 11025),
        secure: false,
      })
    : undefined;
async function deliver(email: string, otp: string) {
  const from = process.env.EMAIL_FROM ?? "Pixel8 <noreply@pixel8.local>";
  if (resend) {
    const result = await resend.emails.send({
      from,
      to: email,
      subject: "Your Pixel8 sign-in code",
      text: `Your Pixel8 verification code is ${otp}. It expires in 5 minutes.`,
    });
    if (result.error) throw new Error(result.error.message);
    return;
  }
  if (smtp) {
    await smtp.sendMail({
      from,
      to: email,
      subject: "Your Pixel8 sign-in code",
      text: `Your Pixel8 verification code is ${otp}. It expires in 5 minutes.`,
    });
    return;
  }
  throw new Error(
    "Configure RESEND_API_KEY and EMAIL_FROM for production email delivery",
  );
}
export const auth: any = betterAuth({
  appName: "Pixel8",
  baseURL: config.publicUrl,
  secret: config.authSecret,
  database: prismaAdapter(prisma, { provider: "postgresql" }),
  rateLimit: { enabled: true, window: 60, max: 10, storage: "database" },
  trustedOrigins: (
    process.env.TRUSTED_ORIGINS ?? "http://localhost:3000,http://localhost:3001"
  )
    .split(",")
    .map((x) => x.trim()),
  plugins: [
    bearer(),
    emailOTP({
      sendVerificationOTP: async ({ email, otp }) => deliver(email, otp),
      otpLength: 6,
      expiresIn: 300,
      allowedAttempts: 5,
    }),
  ],
  emailAndPassword: { enabled: false },
});
