import React from 'react';

interface AutofillSuggestionProps {
    suggestion: string;
    inputValue: string;
}

export function AutofillSuggestion({ suggestion, inputValue }: AutofillSuggestionProps) {
    if (!suggestion || !inputValue) return null;

    const remainingText = suggestion.slice(inputValue.length);

    return (
        <div className="absolute inset-0 flex items-center pointer-events-none">
            <div className="pl-4 flex items-center w-full text-sm">
                <span className="invisible">{inputValue}</span>
                <span className="text-gray-300">{remainingText}</span>
            </div>
        </div>
    );
}