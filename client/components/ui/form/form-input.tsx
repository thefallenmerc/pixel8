import { FormControl, FormDescription, FormField, FormItem, FormLabel, FormMessage } from '@/components/ui/form';
import { Input } from '@/components/ui/input';
import React from 'react';
import { FieldValues, UseFormReturn, Path } from 'react-hook-form';

export function FormInput<T extends FieldValues>({
    form,
    name,
    label,
    placeholder,
    description,
}: {
    form: UseFormReturn<T>,
    name: Path<T>,
    label?: string,
    placeholder?: string,
    description?: string,
}) {
    return (
        <FormField
            control={form.control}
            name={name}
            render={({ field }) => (
                <FormItem>
                    {
                        label ? (
                            <FormLabel>{label}</FormLabel>
                        ) : <></>
                    }
                    <FormControl>
                        <Input placeholder={placeholder ?? ""} {...field} />
                    </FormControl>
                    {
                        description ? (
                            <FormDescription>
                                {description}
                            </FormDescription>
                        ) : <></>
                    }
                    <FormMessage />
                </FormItem>
            )}
        />
    );
}