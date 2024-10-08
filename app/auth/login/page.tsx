"use client";

import React, { FormEvent, useEffect, useState } from "react";
// import { validateEmail } from "@/lib/utils";
import { signIn } from "next-auth/react";
import { useRouter, useSearchParams } from "next/navigation";
import Link from "next/link";
import { Card, CardContent, CardDescription } from "@/components/ui/card";
import { Form, getFormSchemaFromFields } from "@/client/components/ui/form";
import { Button } from "@/components/ui/button";
import { z } from "zod";
import { useToast } from "@/hooks/use-toast";

const formFields = {
    email: {
        label: "Email",
        placeholder: "Enter your email",
        defaultValue: "",
        validation: z.string().min(2).max(50),
    },
    password: {
        label: "Password",
        placeholder: "Enter your password",
        defaultValue: "",
        validation: z.string().min(2).max(50),
    },
};

function LoginPage() {
    const [isLoading, setIsLoading] = useState(false);

    const router = useRouter();
    const searchParams = useSearchParams();
    const { toast } = useToast();
    const origin = searchParams.get("origin");


    const formSchema = getFormSchemaFromFields(formFields);

    async function onSubmit(values: z.infer<typeof formSchema>) {
        const { email, password } = values;
        // call next auth
        let res = await signIn("credentials", {
            email,
            password,
            callbackUrl: `/`,
            redirect: false,
        });

        if (res?.ok) {
            // toast success
            router.push(origin || "/");
            return;
        } else {
            // Toast failed
            toast({
                title: "Credentials incorrect.",
                variant: "destructive",
            });
            // return;
            console.log("Failed", res);
        }
        return res;
    }

    return (
        <Card className="md:w-[400px] w-full">
            <CardContent>
                <div className="pt-6 pb-2">
                    <div className="font-semibold tracking-tight text-2xl">Login</div>
                    <CardDescription>Enter your credentials to resume your journey</CardDescription>
                </div>
                <Form
                    fields={formFields}
                    onSubmit={onSubmit}
                    submitLabel="Login"
                    additionalCTAElement={(
                        <>
                            <div className="px-2">or</div>
                            <Button variant="secondary" onClick={() => {
                                router.push("/auth/register" + (origin ? `?origin=${origin}` : ""));
                            }} type="button">
                                Register
                            </Button>
                        </>
                    )}
                />
                {/* forgot password button */}
                <div className="pt-4">
                    <Link href={
                        "/auth/forgot-password" + (origin ? `?origin=${origin}` : "")
                    } className="block text-sm text-foreground/60 hover:underline">Forgot password?</Link>
                </div>
            </CardContent>
        </Card>
    );
}

export default LoginPage;