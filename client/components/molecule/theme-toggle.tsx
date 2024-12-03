'use client';

import { useTheme } from '@/server/context/theme.context';
export default function ThemeToggle() {
    const { theme, toggleTheme } = useTheme();
    return (
        <button
            onClick={toggleTheme}
            className="p-2 border rounded text-sm"
        >
            {theme === 'light' ? 'Dark' : 'Light'}
        </button>
    )
}