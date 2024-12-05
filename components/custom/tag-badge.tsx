import React from 'react';
import { X } from 'lucide-react';

interface TagBadgeProps {
    tag: string;
    onRemove: (id: string) => void;
}

export function TagBadge({ tag, onRemove }: TagBadgeProps) {
    return (
        <span className="inline-flex items-center rounded-md border px-2.5 py-0.5 text-xs font-semibold transition-colors focus:outline-none focus:ring-2 focus:ring-ring focus:ring-offset-2 border-transparent bg-primary text-primary-foreground shadow hover:bg-primary/80">
            {tag}
            <button
                onClick={() => onRemove(tag)}
                className="ml-2 focus:outline-none hover:text-red-500"
                aria-label={`Remove ${tag} tag`}>
                <X size={14} />
            </button>
        </span>
    );
}