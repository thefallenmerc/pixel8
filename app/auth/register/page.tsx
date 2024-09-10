"use client";

import React, { FormEvent, useEffect, useState } from "react";
// import { validateEmail } from "@/lib/utils";
import { signIn } from "next-auth/react";
import { useRouter, useSearchParams } from "next/navigation";
import Link from "next/link";
// form related
import { z } from "zod"
import { FieldValues, useForm } from "react-hook-form";
import { zodResolver } from "@hookform/resolvers/zod"
// ui components
import { Button } from "@/components/ui/button"
import { Form, getFormSchemaFromFields } from "@/client/components/ui/form";
import {
    Card,
    CardContent,
    CardDescription,
    CardHeader,
} from "@/components/ui/card"
import { useToast } from "@/hooks/use-toast";

const formFields = {
    name: {
        label: "Name",
        placeholder: "Enter your name",
        defaultValue: "",
        validation: z.string().min(2).max(50),
    },
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

function RegisterPage() {

    // states
    const [isLoading, setIsLoading] = useState(false);

    // get the referrer to redirect back
    const router = useRouter();
    const searchParams = useSearchParams();
    const { toast } = useToast();
    const origin = searchParams.get("origin");

    const formSchema = getFormSchemaFromFields(formFields);

    async function onSubmit(values: z.infer<typeof formSchema>) {
        // call api
        const response = await fetch('/api/user/create', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
            },
            body: JSON.stringify(values),
        });

        if (response.ok) {
            // toast success
            router.push(origin || "/");
            return;
        } else {
            const data = await response.json();
            // Toast failed
            toast({
                title: data.message ?? "Failed! Check you input and try again.",
                variant: "destructive",
            });
            // return;
            console.log("Failed", response);
        }
    }

    return (
        <Card className="md:w-[400px] w-full">
            <CardContent>
                <div className="pt-6 pb-2">
                    <div className="font-semibold tracking-tight text-2xl">Register</div>
                    <CardDescription>Enter your details to get started</CardDescription>
                </div>
                <Form
                    fields={formFields}
                    onSubmit={onSubmit}
                    submitLabel="Register"
                    additionalCTAElement={(
                        <>
                            <div className="px-2">or</div>
                            <Button variant="secondary" onClick={() => {
                                router.push("/auth/login" + (origin ? `?origin=${origin}` : ""));
                            }} type="button">
                                Login
                            </Button>
                        </>
                    )}
                />
            </CardContent>
        </Card>
    );
}

export default RegisterPage;