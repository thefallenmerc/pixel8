import type { Metadata } from 'next';
import './globals.css';

export const metadata: Metadata = {
  title: 'Pixel8 — Screen control',
  description: 'Manage Pixel8 displays, campaigns, and media.',
};

export default function RootLayout({ children }: Readonly<{ children: React.ReactNode }>) {
  return <html lang="en"><body>{children}</body></html>;
}
