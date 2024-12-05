import { useState, useCallback, KeyboardEvent } from 'react';

export function useTagSuggestions(
    input: string,
    suggestions: string[],
    onSelectTag: (tag: string) => void
) {
    const [highlightedIndex, setHighlightedIndex] = useState(0);

    const getFirstSuggestion = (input: string): string | null => {
        if (!input) return null;
        return suggestions.find(tag =>
            tag.toLowerCase().startsWith(input.toLowerCase()) &&
            tag.toLowerCase() !== input.toLowerCase()
        ) || null;
    };

    const handleKeyDown = useCallback((e: KeyboardEvent<HTMLInputElement>) => {
        const suggestion = getFirstSuggestion(input);

        switch (e.key) {
            case 'Tab':
                e.preventDefault();
                if (suggestion) {
                    onSelectTag(suggestion);
                }
                break;
            case 'Enter':
            case ',':
                e.preventDefault();
                if (input.trim()) {
                    onSelectTag(input.trim());
                }
                break;
        }
    }, [input, onSelectTag, suggestions]);

    return {
        currentSuggestion: getFirstSuggestion(input),
        handleKeyDown
    };
}