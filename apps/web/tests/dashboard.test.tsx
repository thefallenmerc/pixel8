// @vitest-environment jsdom
import '@testing-library/jest-dom/vitest';
import { cleanup, fireEvent, render, screen, waitFor, within } from '@testing-library/react';
import { afterEach, beforeEach, describe, expect, it, vi } from 'vitest';
import { CampaignEditor, LibraryView, PairDialog, ScreensView } from '../components/dashboard';
import { api, type Asset, type Campaign, type Screen } from '../lib/api';

vi.mock('../lib/api', async (importOriginal) => {
  const actual = await importOriginal<typeof import('../lib/api')>();
  return { ...actual, api: vi.fn() };
});

const mockedApi = vi.mocked(api);
const app = { id: 'app-1', name: 'Hotel', description: null, createdAt: '2026-01-01' };
const assets: Asset[] = [
  { id: 'image-1', appId: app.id, name: 'Lobby image', mimeType: 'image/png', sizeBytes: 1024, status: 'ready' },
  { id: 'video-1', appId: app.id, name: 'Lobby video', mimeType: 'video/mp4', sizeBytes: 2048, status: 'ready' },
];
const campaign: Campaign = {
  id: 'campaign-1', appId: app.id, name: 'Welcome loop', description: '', revision: 1,
  currentRevision: 1, status: 'ready', items: [
    { assetId: 'image-1', durationSeconds: 10, fit: 'contain' },
    { assetId: 'video-1', durationSeconds: 10, fit: 'cover' },
  ],
};

function makeScreen(overrides: Partial<Screen> = {}): Screen {
  return {
    id: 'screen-1', name: 'Lobby display', campaignId: campaign.id, orientation: 0, muted: false,
    volume: 50, desiredVersion: 4, playingVersion: 3, status: 'playing', ...overrides,
  };
}

function renderEditor(onError = vi.fn()) {
  mockedApi.mockImplementation(async (path) => {
    if (path === `/v1/campaigns/${campaign.id}`) return campaign;
    if (String(path).includes('/preview')) return { url: 'https://media.test/preview' };
    return campaign;
  });
  return render(<CampaignEditor campaign={campaign} apps={[app]} assets={assets} screens={[]}
    onClose={vi.fn()} onError={onError} onAssigned={vi.fn()} />);
}

describe('dashboard campaign and screen components', () => {
  beforeEach(() => mockedApi.mockReset());
  afterEach(() => cleanup());

  it('reorders playlist items with the keyboard controls', async () => {
    renderEditor();
    const imageRow = await screen.findByText('Lobby image').then((node) => node.closest('.playlist-item') as HTMLElement);
    fireEvent.click(within(imageRow).getByRole('button', { name: 'Move Lobby image down' }));
    const rows = document.querySelectorAll('.playlist-item');
    expect(rows[0]).toHaveTextContent('Lobby video');
    expect(rows[1]).toHaveTextContent('Lobby image');
  });

  it('previews the next item, advances when a full video ends, and shows image duration controls only', async () => {
    renderEditor();
    await screen.findByRole('button', { name: 'Next preview item' });
    expect(document.querySelector('.preview-stage-label')?.textContent).toContain('1 of 2');
    fireEvent.click(screen.getByRole('button', { name: 'Next preview item' }));
    expect(document.querySelector('.preview-stage-label')?.textContent).toContain('2 of 2');
    expect(screen.getByText('Full video')).toBeInTheDocument();
    await waitFor(() => expect(document.querySelector('.preview-stage video')).not.toBeNull());
    const previewVideo = document.querySelector('.preview-stage video')!;
    expect(previewVideo).toHaveAttribute('autoplay');
    expect(screen.getByRole('combobox', { name: 'Duration in seconds' })).toHaveValue('10');
  });

  it('shows pairing failures inside the active dialog', async () => {
    const onPair = vi.fn().mockRejectedValue(new Error('Pairing code expired'));
    render(<PairDialog open onOpenChange={vi.fn()} onPair={onPair} />);
    fireEvent.change(screen.getByPlaceholderText('ABCD1234'), { target: { value: 'EXPIRED1' } });
    fireEvent.change(screen.getByPlaceholderText('Lobby display'), { target: { value: 'Lobby' } });
    fireEvent.click(screen.getByRole('button', { name: 'Pair screen' }));
    expect(await screen.findByRole('alert')).toHaveTextContent('Pairing code expired');
  });

  it('shows upload progress and the processing state after upload completes', () => {
    const callbacks = {
      onChooseApp: vi.fn(), onNewCampaign: vi.fn(), onOpenCampaign: vi.fn(), onUpload: vi.fn(),
      onDeleteAsset: vi.fn(), onRetryUpload: vi.fn(), onAbortUpload: vi.fn(), onRefresh: vi.fn(),
    };
    const { rerender } = render(<LibraryView apps={[app]} appId={app.id} assets={[]} campaigns={[]}
      upload={{ name: 'lobby.png', progress: 0.42 }} fileRef={{ current: null }} {...callbacks} />);
    expect(screen.getByText('42%')).toBeInTheDocument();
    expect(screen.getByText('lobby.png')).toBeInTheDocument();
    rerender(<LibraryView apps={[app]} appId={app.id} assets={[{ ...assets[0], status: 'processing' }]}
      campaigns={[]} upload={null} fileRef={{ current: null }} {...callbacks} />);
    expect(screen.getByText('Preparing preview')).toBeInTheDocument();
    expect(screen.getByText('processing')).toBeInTheDocument();
  });

  it('reports playing, offline, and version state from the server fields', () => {
    const screens = [makeScreen(), makeScreen({ id: 'screen-2', name: 'Offline display', status: 'offline', playingVersion: null }), makeScreen({ id: 'screen-3', name: 'Ready display', status: 'ready', playingVersion: 4 })];
    render(<ScreensView screens={screens} allCount={3} onPair={vi.fn()} onOpen={vi.fn()} onRefresh={vi.fn()} />);
    expect(screen.getByText('playing')).toBeInTheDocument();
    expect(screen.getByText('offline')).toBeInTheDocument();
    expect(screen.getByText(/Version 3 \/ 4/)).toBeInTheDocument();
    expect(document.querySelectorAll('.screen-live-meta')[1]?.textContent).toContain('— / 4');
    expect(screen.getByText('Up to date')).toBeInTheDocument();
    expect(screen.getByText('Offline display')).toBeInTheDocument();
  });
});
