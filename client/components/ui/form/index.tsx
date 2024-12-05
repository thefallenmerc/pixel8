import React from 'react';
import { DefaultValues, FieldValues, Path, SubmitHandler, UseFormReturn, useForm } from 'react-hook-form';
import {
    Form as FormProvider,
} from "@/components/ui/form"
import { FormInput } from './form-input';
import { Button } from '@/components/ui/button';
import { zodResolver } from '@hookform/resolvers/zod';
import { z } from 'zod';
import { InputType } from 'zlib';

interface FieldConfig {
    label: string,
    labelTrail?: React.ReactNode,
    type?: string,
    options?: { value: string, label: string }[],
    placeholder?: string,
    defaultValue?: string | number | undefined,
    validation: z.ZodSchema,
    render?: () => React.ReactNode,
    tagSuggestions?: string[],
}

export function Form<T extends { [K: string]: FieldConfig }>({
    fields,
    onSubmit,
    submitLabel,
    additionalCTAElement,
}: {
    fields: T,
    onSubmit: SubmitHandler<{ [K in keyof T]: string }>,
    submitLabel?: string,
    additionalCTAElement?: React.ReactNode
}) {
    // Create a schema object based on the fields
    const formSchema = getFormSchemaFromFields(fields);

    const defaultValues = Object.keys(fields).reduce((acc, name: string) => {
        const field = fields[name];
        acc[name as keyof T] = field.defaultValue ?? "";
        return acc;
        // }, {} as Record<string, string | number>);
    }, {} as { [K in keyof T]: string | number | undefined });

    // form object
    const form = useForm<z.infer<typeof formSchema>>({
        resolver: zodResolver(formSchema),
        // fix the use of any
        defaultValues: defaultValues as any,
    });

    return (
        <FormProvider {...form}>
            <form onSubmit={form.handleSubmit(onSubmit)} className="space-y-2">
                {Object.keys(formSchema.shape).map((field) => (
                    fields[field].type === "custom" && fields[field].render
                        ? <div key={field}>{fields[field].render()}</div>
                        : <FormInput
                            key={field}
                            label={fields[field].label}
                            labelTrail={fields[field].labelTrail}
                            placeholder={fields[field].placeholder}
                            name={field as any}
                            type={(fields[field].type ?? "input")}
                            options={fields[field].options}
                            tagSuggestions={fields[field].tagSuggestions}
                            form={form} />
                ))}
                <div className="flex items-center pt-2">
                    <Button className={additionalCTAElement ? "" : "flex-grow"} type="submit">{submitLabel ?? "Submit"}</Button>
                    {additionalCTAElement}
                </div>
            </form>
        </FormProvider>
    )
}

// Define a utility type to transform FieldConfig to ZodSchema
type FormSchema<T extends { [key: string]: FieldConfig }> = {
    [K in keyof T]: T[K]['validation'];
};

export function getFormSchemaFromFields<T extends { [key: string]: FieldConfig }>(fields: T) {

    const schemaMap = Object.keys(fields).reduce((acc, name) => {
        const field = fields[name];
        acc[name as keyof T] = field.validation;
        return acc;
    }, {} as FormSchema<T>);

    const formSchema = z.object(schemaMap)
    return formSchema;
}
