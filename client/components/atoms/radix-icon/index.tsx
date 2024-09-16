import React from 'react';
import {
    PlayIcon,
    ResumeIcon,
    PlusIcon,
    ComponentPlaceholderIcon,
} from "@radix-ui/react-icons";

export type IconName = "play" | "resume" | "plus" | "default";

export function RadixIcon({
    icon,
    size,
}: {
    icon: IconName,
    size?: number,
}) {

    const Icon = getIcon(icon);

    return (
        <Icon width={size} height={size} />
    )
}

function getIcon(icon: IconName) {
    switch (icon) {
        case "play": return PlayIcon;
        case "resume": return ResumeIcon;
        case "plus": return PlusIcon;
        default: return ComponentPlaceholderIcon;
    }
}
