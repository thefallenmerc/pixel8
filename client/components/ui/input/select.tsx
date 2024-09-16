import React from 'react';
import {
    Select,
    SelectContent,
    SelectItem,
    SelectTrigger,
    SelectValue,
} from "@/components/ui/select"

type Option = {
    value: string,
    label: string
}

export function SelectInput({
    placeholder = "",
    options = [],
    defaultValue = "",
    onValueChange,
}: {
    placeholder?: string,
    options?: Option[],
    defaultValue?: string,
    onValueChange?: (value: string) => void
}) {
    return (
        <Select onValueChange={onValueChange} defaultValue={defaultValue}>
            <SelectTrigger className="w-[180px]">
                <SelectValue placeholder={defaultValue ? defaultValue : placeholder} />
            </SelectTrigger>
            <SelectContent>
                {
                    options.map((option) => (
                        <SelectItem key={option.value} value={option.value}>
                            {option.label}
                        </SelectItem>
                    ))
                }
            </SelectContent>
        </Select>
    )
}