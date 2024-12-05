import React, { useState, KeyboardEvent, useEffect } from 'react';
import { X } from 'lucide-react';
import { TagBadge } from './tag-badge';
import { Input } from '../ui/input';
import { AutofillSuggestion } from './autofill-tag-suggestion';
import { useTagSuggestions } from './use-tag-suggestion-hook';

export const generateId = (): string => {
    return Math.random().toString(36).substring(2) + Date.now().toString(36);
}

export function TagInput({
    placeholder,
    value = "",
    onValueChange,
    tagSuggestions = [],
}: {
    placeholder?: string,
    value?: string,
    onValueChange: (...event: any[]) => void,
    tagSuggestions?: string[],
}) {
    const [tags, setTags] = useState<string[]>(value.split(",").filter(t => t));
    const [input, setInput] = useState('');

    const addTag = (text: string) => {
        const trimmedText = text.trim();
        if (trimmedText && !tags.find(tag => tag.toLowerCase() === trimmedText.toLowerCase())) {
            const newTags = [...tags, trimmedText];
            setTags(newTags);
            onValueChange(newTags.join(","));
            setInput('');
        }
    };

    // const handleKeyDown = (e: KeyboardEvent<HTMLInputElement>) => {
    //     if (e.key === ',' || e.key === 'Enter') {
    //         e.preventDefault();
    //         const trimmedInput = input.trim();

    //         if (trimmedInput && !tags.find(tag => tag.toLowerCase() === trimmedInput.toLowerCase())) {
    //             setTags([...tags, trimmedInput]);
    //             setInput('');
    //         }
    //     }
    // };

    const removeTag = (tagToRemove: string) => {
        const newTags = tags.filter(tag => tag !== tagToRemove);
        setTags(newTags);
        onValueChange(newTags.join(","));
    };

    const { currentSuggestion, handleKeyDown } = useTagSuggestions(input, tagSuggestions, addTag);

    return (
        <div>
            <div className="mb-2 relative">
                <Input
                    value={input}
                    onChange={(e) => setInput(e.target.value)}
                    placeholder={placeholder}
                    onKeyDown={handleKeyDown} />
                <AutofillSuggestion suggestion={currentSuggestion ?? ""} inputValue={input} />
            </div>

            <div className="flex flex-wrap gap-2">
                {tags.map(tag => (
                    <TagBadge key={tag} tag={tag} onRemove={removeTag} />
                ))}
            </div>
        </div>
    );
}