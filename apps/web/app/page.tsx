'use client';
import * as Dialog from '@radix-ui/react-dialog';
import * as AlertDialog from '@radix-ui/react-alert-dialog';
import * as DropdownMenu from '@radix-ui/react-dropdown-menu';
import { Activity, AppWindow, ArrowDown, ArrowLeft, ArrowRight, ArrowUp, Check, ChevronDown, ChevronLeft, ChevronRight, CircleAlert, CloudUpload, Command, FileImage, Film, Grid2X2, HardDrive, LoaderCircle, LogOut, Menu, MoreHorizontal, Pencil, Play, Plus, QrCode, RefreshCcw, RotateCcw, Search, Settings, SlidersHorizontal, Sparkles, Tv, Upload, Volume2, VolumeX, Wifi, WifiOff, X } from 'lucide-react';
import { FormEvent, useCallback, useEffect, useMemo, useRef, useState } from 'react';
import { authClient } from '@/lib/auth-client';
import { api, AppRecord, Asset, Campaign, Screen, Telemetry } from '@/lib/api';
import { AppsView, AppDialog, CampaignEditor, CreateCampaignDialog, LibraryView, PairDialog, ScreenDrawer, ScreensView, SettingsView } from '@/components/dashboard';
import { abortUpload, uploadFile } from '@/lib/upload';
type Section = 'screens' | 'apps' | 'library' | 'settings';
const navItems: Array<{
    id: Section;
    label: string;
    icon: typeof Tv;
}> = [
    { id: 'screens', label: 'Screens', icon: Tv }, { id: 'apps', label: 'Apps', icon: AppWindow }, { id: 'library', label: 'Library', icon: Grid2X2 }, { id: 'settings', label: 'Settings', icon: Settings },
];
const statusTone: Record<string, string> = { playing: 'green', ready: 'green', offline: 'muted', preparing: 'amber', downloading: 'blue', error: 'red', failed: 'red', uploading: 'blue', processing: 'amber' };
const apiError = (e: unknown) => e instanceof Error ? e.message : 'Something went wrong. Please try again.';
export default function Home() {
    const session = authClient.useSession();
    const [section, setSection] = useState<Section>('screens');
    const [mobileNav, setMobileNav] = useState(false);
    const [apps, setApps] = useState<AppRecord[]>([]);
    const [screens, setScreens] = useState<Screen[]>([]);
    const [selectedApp, setSelectedApp] = useState('');
    const [assets, setAssets] = useState<Asset[]>([]);
    const [campaigns, setCampaigns] = useState<Campaign[]>([]);
    const [screenCampaigns, setScreenCampaigns] = useState<Campaign[]>([]);
    const [selectedScreen, setSelectedScreen] = useState<Screen | null>(null);
    const [screenTelemetry, setScreenTelemetry] = useState<Telemetry[]>([]);
    const [busy, setBusy] = useState(false);
    const [error, setError] = useState('');
    const [query, setQuery] = useState('');
    const [appDialog, setAppDialog] = useState(false);
    const [editingApp, setEditingApp] = useState<AppRecord | null>(null);
    const [campaignDialog, setCampaignDialog] = useState(false);
    const [editingCampaign, setEditingCampaign] = useState<Campaign | null>(null);
    const [pairDialog, setPairDialog] = useState(false);
    const [upload, setUpload] = useState<{
        name: string;
        progress: number;
        error?: string;
        appId: string;
        file: File;
        controller: AbortController;
    } | null>(null);
    const fileRef = useRef<HTMLInputElement>(null);
    const refreshCore = useCallback(async () => {
        if (!session.data?.user)
            return;
        try {
            const [appResult, screenResult] = await Promise.all([
                api<{
                    items: AppRecord[];
                }>('/v1/apps'), api<{
                    items: Screen[];
                }>('/v1/screens'),
            ]);
            setApps(appResult.items);
            setScreens(screenResult.items);
            setSelectedScreen((current) => current ? screenResult.items.find((s) => s.id === current.id) ?? null : null);
        }
        catch (e) {
            setError(apiError(e));
        }
    }, [session.data?.user]);
    const refreshLibrary = useCallback(async (appId = selectedApp) => {
        if (!appId) {
            setAssets([]);
            setCampaigns([]);
            return;
        }
        try {
            const [assetResult, campaignResult] = await Promise.all([
                api<{
                    items: Asset[];
                }>(`/v1/apps/${appId}/assets`), api<{
                    items: Campaign[];
                }>(`/v1/apps/${appId}/campaigns`),
            ]);
            setAssets(assetResult.items);
            setCampaigns(campaignResult.items);
        }
        catch (e) {
            setError(apiError(e));
        }
    }, [selectedApp]);
    useEffect(() => { if (session.data?.user)
        void refreshCore(); }, [session.data?.user, refreshCore]);
    useEffect(() => { if (session.data?.user) {
        const id = window.setInterval(() => void refreshCore(), 5000);
        return () => window.clearInterval(id);
    } }, [session.data?.user, refreshCore]);
    useEffect(() => { if (session.data?.user && selectedApp)
        void refreshLibrary(selectedApp); }, [session.data?.user, selectedApp, refreshLibrary]);
    useEffect(() => { if (!session.data?.user || !selectedApp || section !== 'library')
        return; const id = window.setInterval(() => void refreshLibrary(selectedApp), 5000); return () => window.clearInterval(id); }, [session.data?.user, selectedApp, section, refreshLibrary]);
    useEffect(() => { if (!selectedScreen || !session.data?.user) {
        setScreenTelemetry([]);
        return;
    } let active = true; const pull = async () => { try {
        const data = await api<{
            items: Telemetry[];
        }>(`/v1/screens/${selectedScreen.id}/telemetry?hours=24`);
        if (active)
            setScreenTelemetry(data.items);
    }
    catch {
        if (active)
            setScreenTelemetry([]);
    } }; void pull(); const id = window.setInterval(pull, 5000); return () => { active = false; window.clearInterval(id); }; }, [selectedScreen?.id, session.data?.user]);
    const filteredScreens = useMemo(() => screens.filter(s => `${s.name} ${s.status}`.toLowerCase().includes(query.toLowerCase())), [screens, query]);
    const filteredApps = useMemo(() => apps.filter(a => `${a.name} ${a.description ?? ''}`.toLowerCase().includes(query.toLowerCase())), [apps, query]);
    const activeLabel = navItems.find(n => n.id === section)?.label ?? 'Screens';
    async function saveApp(event: FormEvent<HTMLFormElement>) {
        event.preventDefault();
        const form = new FormData(event.currentTarget);
        setBusy(true);
        setError('');
        try {
            const body = { name: String(form.get('name') ?? '').trim(), description: String(form.get('description') ?? '').trim() };
            if (editingApp)
                await api(`/v1/apps/${editingApp.id}`, { method: 'PATCH', body: JSON.stringify(body) });
            else
                await api('/v1/apps', { method: 'POST', body: JSON.stringify(body) });
            setAppDialog(false);
            setEditingApp(null);
            await refreshCore();
        }
        catch (e) {
            setError(apiError(e));
        }
        finally {
            setBusy(false);
        }
    }
    async function deleteApp(app: AppRecord) { if (!window.confirm(`Delete “${app.name}”?`))
        return; try {
        await api(`/v1/apps/${app.id}`, { method: 'DELETE' });
        if (selectedApp === app.id)
            setSelectedApp('');
        await refreshCore();
    }
    catch (e) {
        setError(apiError(e));
    } }
    async function saveCampaign(event: FormEvent<HTMLFormElement>) {
        event.preventDefault();
        if (!selectedApp)
            return;
        const form = new FormData(event.currentTarget);
        setBusy(true);
        setError('');
        try {
            await api(`/v1/apps/${selectedApp}/campaigns`, { method: 'POST', body: JSON.stringify({ name: String(form.get('name') ?? '').trim(), description: String(form.get('description') ?? '').trim(), items: [] }) });
            setCampaignDialog(false);
            await refreshLibrary();
        }
        catch (e) {
            setError(apiError(e));
        }
        finally {
            setBusy(false);
        }
    }
    async function deleteAsset(asset: Asset) { if (!window.confirm(`Delete “${asset.name}”?`))
        return; try {
        await api(`/v1/assets/${asset.id}`, { method: 'DELETE' });
        await refreshLibrary();
    }
    catch (e) {
        setError(apiError(e));
    } }
    async function chooseFile(file?: File | null) { if (!file || !selectedApp)
        return; const controller = new AbortController(); setUpload({ name: file.name, progress: 0, appId: selectedApp, file, controller }); try {
        await uploadFile(selectedApp, file, (progress) => setUpload((u) => u ? { ...u, progress } : u), controller.signal);
        setUpload(null);
        await refreshLibrary();
    }
    catch (e) {
        if ((e as Error).name === 'AbortError') {
            try {
                await abortUpload(selectedApp, file);
            }
            catch { }
            setUpload(null);
        }
        else
            setUpload((u) => u ? { ...u, error: apiError(e) } : u);
    } }
    async function openScreen(screen: Screen) { setSelectedScreen(screen); setError(''); try {
        const lists = await Promise.all(apps.map(app => api<{
            items: Campaign[];
        }>(`/v1/apps/${app.id}/campaigns`)));
        setScreenCampaigns(lists.flatMap(x => x.items));
    }
    catch (e) {
        setError(apiError(e));
    } }
    async function assignScreen(screen: Screen, campaignId: string | null) { try {
        const result = await api<Screen>(`/v1/screens/${screen.id}`, { method: 'PATCH', body: JSON.stringify({ expectedDesiredVersion: screen.desiredVersion, campaignId }) });
        setScreens((current) => current.map(s => s.id === result.id ? result : s));
        setSelectedScreen(result);
    }
    catch (e) {
        await refreshCore();
        throw e;
    } }
    async function updateScreen(screen: Screen, patch: Partial<Pick<Screen, 'orientation' | 'muted' | 'volume' | 'name'>>) { try {
        const result = await api<Screen>(`/v1/screens/${screen.id}`, { method: 'PATCH', body: JSON.stringify({ expectedDesiredVersion: screen.desiredVersion, ...patch }) });
        setScreens((current) => current.map(s => s.id === result.id ? result : s));
        setSelectedScreen(result);
    }
    catch (e) {
        await refreshCore();
        throw e;
    } }
    async function claimScreen(code: string, name: string) { await api('/v1/screens/pair', { method: 'POST', body: JSON.stringify({ code, name }) }); setPairDialog(false); await refreshCore(); }
    async function signOut() { upload?.controller.abort(); if (upload) {
        try {
            await abortUpload(upload.appId, upload.file);
        }
        catch { }
    } await authClient.signOut(); setApps([]); setScreens([]); setAssets([]); setCampaigns([]); setScreenCampaigns([]); setScreenTelemetry([]); setSelectedApp(''); setSelectedScreen(null); setEditingCampaign(null); setUpload(null); setError(''); }
    if (session.isPending)
        return <main className="boot"><span className="brand-mark"><Tv size={22}/></span><LoaderCircle className="spin" size={20}/></main>;
    if (!session.data?.user)
        return <Login />;
    return <div className="app-shell">
    <aside className={`sidebar ${mobileNav ? 'open' : ''}`}>
      <div className="brand"><span className="brand-mark"><Tv size={20}/></span><span>pixel<span className="brand-eight">8</span></span><button className="icon-button close-nav" aria-label="Close menu" onClick={() => setMobileNav(false)}><X size={18}/></button></div>
      <div className="workspace-chip"><span className="workspace-dot"/>Workspace <ChevronDown size={14}/></div>
      <div className="nav-caption">Workspace</div>
      <nav className="main-nav" aria-label="Main navigation">{navItems.map(item => <button key={item.id} className={`nav-item ${section === item.id ? 'active' : ''}`} onClick={() => { setSection(item.id); setSelectedScreen(null); setMobileNav(false); }}><item.icon size={18}/><span>{item.label}</span>{item.id === 'screens' && screens.length > 0 && <span className="nav-count">{screens.length}</span>}</button>)}</nav>
      <div className="sidebar-bottom"><div className="help-card"><span className="help-icon"><Sparkles size={17}/></span><b>Make your screens shine</b><p>Build a playlist and bring it to life.</p><button onClick={() => setSection('library')}>Open library <ArrowRight size={14}/></button></div><div className="profile-button"><span className="avatar">{(session.data.user.name || session.data.user.email || 'P').slice(0, 1).toUpperCase()}</span><span className="profile-copy"><b>{session.data.user.name || 'Pixel8 owner'}</b><small>{session.data.user.email}</small></span><DropdownMenu.Root><DropdownMenu.Trigger asChild><button className="icon-button profile-more" aria-label="Account menu"><MoreHorizontal size={18}/></button></DropdownMenu.Trigger><DropdownMenu.Portal><DropdownMenu.Content className="menu-content" side="top" align="end"><DropdownMenu.Item className="menu-item" onSelect={() => void signOut()}><LogOut size={15}/> Sign out</DropdownMenu.Item></DropdownMenu.Content></DropdownMenu.Portal></DropdownMenu.Root></div></div>
    </aside>
    {mobileNav && <button className="nav-scrim" aria-label="Close navigation" onClick={() => setMobileNav(false)}/>}
    <main className="main-area">
      <header className="topbar"><button className="icon-button mobile-menu" aria-label="Open menu" onClick={() => setMobileNav(true)}><Menu size={20}/></button><div className="breadcrumbs"><span>Workspace</span><ChevronRight size={14}/><b>{activeLabel}</b></div><div className="top-actions"><label className="searchbox"><Search size={16}/><input value={query} onChange={e => setQuery(e.target.value)} placeholder="Search" aria-label="Search"/><kbd>⌘ K</kbd></label><button className="help-link" onClick={() => setSection('settings')}>Help</button><span className="avatar small-avatar">{(session.data.user.name || session.data.user.email || 'P').slice(0, 1).toUpperCase()}</span></div></header>
      <div className="content-wrap">
        {error && <div className="alert error-alert" role="alert"><CircleAlert size={17}/><span>{error}</span><button onClick={() => setError('')} aria-label="Dismiss"><X size={15}/></button></div>}
        {section === 'screens' && <ScreensView screens={filteredScreens} allCount={screens.length} loading={session.isPending} onPair={() => setPairDialog(true)} onOpen={openScreen} onRefresh={refreshCore}/>}
        {section === 'apps' && <AppsView apps={filteredApps} onCreate={() => { setEditingApp(null); setAppDialog(true); }} onEdit={app => { setEditingApp(app); setAppDialog(true); }} onDelete={deleteApp} onOpen={app => { setSelectedApp(app.id); setSection('library'); }}/>}
        {section === 'library' && <LibraryView apps={apps} appId={selectedApp} assets={assets} campaigns={campaigns} upload={upload} fileRef={fileRef} onChooseApp={setSelectedApp} onNewCampaign={() => setCampaignDialog(true)} onOpenCampaign={setEditingCampaign} onUpload={() => fileRef.current?.click()} onDeleteAsset={deleteAsset} onRetryUpload={chooseFile} onAbortUpload={() => upload && upload.controller.abort()} onRefresh={() => refreshLibrary()}/>}
        {section === 'settings' && <SettingsView email={session.data.user.email} onSignOut={signOut}/>}
      </div>
    </main>
    <input ref={fileRef} type="file" className="visually-hidden" accept="image/*,video/*" onChange={e => { void chooseFile(e.target.files?.[0]); e.target.value = ''; }}/>
    <AppDialog open={appDialog} initial={editingApp} busy={busy} error={error} onOpenChange={setAppDialog} onSubmit={saveApp}/>
    <CreateCampaignDialog open={campaignDialog} busy={busy} error={error} onOpenChange={setCampaignDialog} onSubmit={saveCampaign}/>
    <PairDialog open={pairDialog} onOpenChange={setPairDialog} onPair={claimScreen}/>
    {editingCampaign && <CampaignEditor campaign={editingCampaign} apps={apps} assets={assets} screens={screens} onClose={() => { setEditingCampaign(null); void refreshLibrary(); }} onError={setError} onAssigned={refreshCore}/>}
    {selectedScreen && <ScreenDrawer screen={selectedScreen} campaigns={screenCampaigns} telemetry={screenTelemetry} onClose={() => setSelectedScreen(null)} onAssign={assignScreen} onUpdate={updateScreen} onRefresh={refreshCore} onError={setError}/>}
  </div>;
}
function Login() {
    const [email, setEmail] = useState('');
    const [otp, setOtp] = useState('');
    const [sent, setSent] = useState(false);
    const [busy, setBusy] = useState(false);
    const [error, setError] = useState('');
    async function submit(event: FormEvent) { event.preventDefault(); setBusy(true); setError(''); try {
        if (!sent) {
            await authClient.emailOtp.sendVerificationOtp({ email: email.trim(), type: 'sign-in' });
            setSent(true);
        }
        else {
            const result = await authClient.signIn.emailOtp({ email: email.trim(), otp: otp.trim() });
            if (result.error)
                throw new Error(result.error.message || 'That code could not be verified.');
        }
    }
    catch (e) {
        setError(apiError(e));
    }
    finally {
        setBusy(false);
    } }
    return <main className="login-page"><div className="login-story"><div className="brand login-brand"><span className="brand-mark"><Tv size={20}/></span><span>pixel<span className="brand-eight">8</span></span></div><div className="login-story-content"><span className="eyebrow"><Sparkles size={14}/> DISPLAY, MADE SIMPLE</span><h1>Every screen,<br />in sync with you.</h1><p>Curate beautiful content, publish in a moment, and keep every display up to date from one calm workspace.</p><div className="story-art"><div className="art-orbit orbit-one"/><div className="art-orbit orbit-two"/><div className="art-screen"><div className="art-screen-top"><span /><span /><span /></div><div className="art-sun"/><div className="art-hill hill-back"/><div className="art-hill hill-front"/><div className="art-screen-label"><span className="live-dot"/> Living room <b>Playing</b></div></div><div className="art-spark spark-one">✦</div><div className="art-spark spark-two">✦</div></div></div><div className="login-foot">Pixel8 <span>·</span> Screen control, thoughtfully done</div></div><section className="login-form-panel"><div className="login-form-wrap"><div className="login-icon"><Command size={21}/></div><h2>Welcome to Pixel8</h2><p className="login-intro">Sign in to continue to your workspace.</p><form onSubmit={submit}><label className="field-label" htmlFor="login-email">Email address</label><input id="login-email" className="text-field" type="email" autoComplete="email" required value={email} onChange={e => setEmail(e.target.value)} placeholder="you@company.com"/>{sent && <><label className="field-label otp-label" htmlFor="login-otp">Verification code</label><input id="login-otp" className="text-field" inputMode="numeric" autoComplete="one-time-code" required value={otp} onChange={e => setOtp(e.target.value)} placeholder="6-digit code"/><button type="button" className="text-button resend" onClick={() => { setSent(false); setOtp(''); }}>Use a different email</button></>}{error && <div className="alert error-alert" role="alert"><CircleAlert size={16}/>{error}</div>}<button className="button primary login-submit" disabled={busy}>{busy ? <LoaderCircle size={17} className="spin"/> : sent ? 'Verify and sign in' : 'Send verification code'} {!busy && <ArrowRight size={16}/>}</button></form><div className="secure-note"><span><Check size={13}/></span> Password-free sign in. Your session stays private.</div></div></section></main>;
}
function PageHeading({ eyebrow, title, description, action }: {
    eyebrow: string;
    title: string;
    description: string;
    action?: React.ReactNode;
}) { return <div className="page-heading"><div><div className="eyebrow">{eyebrow}</div><h1>{title}</h1><p>{description}</p></div>{action && <div className="heading-action">{action}</div>}</div>; }
