import { FormControl, FormDescription, FormField, FormItem, FormLabel, FormMessage } from '@/components/ui/form';
import { Input } from '@/components/ui/input';
import React from 'react';
import { FieldValues, UseFormReturn, Path } from 'react-hook-form';
import { SelectInput } from '../input/select';
import { Select } from '@/components/ui/select';
import { Textarea } from '@/components/ui/textarea';
import { TagInput } from '@/components/custom/tag-input';

export type InputType = "input" | "select";


export function FormInput<T extends FieldValues>({
    form,
    name,
    label,
    labelTrail,
    type,
    options,
    placeholder,
    description,
    tagSuggestions = [],
}: {
    form: UseFormReturn<T>,
    name: Path<T>,
    label?: string,
    labelTrail?: React.ReactNode,
    type?: string,
    options?: { value: string, label: string }[],
    placeholder?: string,
    description?: string,
    tagSuggestions?: string[],
}) {
    return (
        <FormField
            control={form.control}
            name={name}
            render={({ field }) => (
                <FormItem>
                    {
                        label ? (
                            <FormLabel>{label} {labelTrail}</FormLabel>
                        ) : <></>
                    }
                    <FormControl>
                        {
                            type === "textarea" ? (
                                <Textarea
                                    placeholder={placeholder ?? ""}
                                    {...field}
                                    onChange={field.onChange} />
                            ) : (
                                type === "select" ? (
                                    <SelectInput
                                        placeholder={placeholder ?? ""}
                                        options={options}
                                        {...field}
                                        onValueChange={field.onChange}
                                    />
                                ) : (
                                    type === "tags" ? (
                                        <TagInput
                                            placeholder={placeholder ?? ""}
                                            // {...field}
                                            value={field.value}
                                            onValueChange={field.onChange}
                                            tagSuggestions={tagSuggestions}
                                        />
                                    ) : (
                                        <Input
                                            placeholder={placeholder ?? ""}
                                            {...field} />
                                    )
                                )
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