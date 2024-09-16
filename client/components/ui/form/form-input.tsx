import { FormControl, FormDescription, FormField, FormItem, FormLabel, FormMessage } from '@/components/ui/form';
import { Input } from '@/components/ui/input';
import React from 'react';
import { FieldValues, UseFormReturn, Path } from 'react-hook-form';
import { SelectInput } from '../input/select';
import { Select } from '@/components/ui/select';

export type InputType = "input" | "select";


export function FormInput<T extends FieldValues>({
    form,
    name,
    label,
    type,
    options,
    placeholder,
    description,
}: {
    form: UseFormReturn<T>,
    name: Path<T>,
    label?: string,
    type?: string,
    options?: { value: string, label: string }[],
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
                        {
                            type === "select" ? (
                                <SelectInput
                                    placeholder={placeholder ?? ""}
                                    options={options}
                                    {...field}
                                    onValueChange={field.onChange}
                                />
                            ) : (
                                <Input
                                    placeholder={placeholder ?? ""}
                                    {...field} />
                            )
                        }
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