"use client";

import { GridCard } from '@/client/components/atoms/grid-card';
import { Form, getFormSchemaFromFields } from '@/client/components/ui/form';
import { convertStringToTimestamp } from '@/client/lib/server-response-helper';
import { Button } from '@/components/ui/button';
import { Drawer, DrawerContent, DrawerTrigger } from '@/components/ui/drawer';
import { DrawerDialog } from '@/components/ui/drawer-dialog';
import { Input } from '@/components/ui/input';
import { Label } from '@/components/ui/label';
import { Sheet, SheetClose, SheetContent, SheetDescription, SheetFooter, SheetHeader, SheetTitle, SheetTrigger } from '@/components/ui/sheet';
import { Dialog, DialogContent, DialogHeader, DialogTitle, DialogTrigger } from "@/components/ui/dialog";
import { toast, useToast } from '@/hooks/use-toast';
import { cn } from '@/lib/utils';
import { AppType, AppTypeArray } from '@/types/app.type';
import { useRouter } from 'next/navigation';
import React, { useMemo, useState } from 'react';
import { z } from "zod";
import { ScreenTypeArray } from '@/types/screen.type';
import { ScrollArea } from '@/components/ui/scroll-area';
import { Separator } from '@/components/ui/separator';
import { FormInput } from '@/client/components/ui/form/form-input';
import Link from 'next/link';
import { ExternalLink } from 'lucide-react';

const filterSensitive = false;

type Prop = {
    apps: AppTypeArray,
    screens: ScreenTypeArray
};

export function MyAppListClientComponent({
    apps: appsProp,
    screens,
}: Prop) {

    const router = useRouter();

    const [apps, setApp] = useState(appsProp);

    const [selectedApp, setSelectedApp] = useState<AppType>(null);
    const [isEditMode, setIsEditMode] = useState(false);
    const [isScreenSelectorVisible, setIsScreenSelectorVisible] = useState(false);
    const [isQuickSelectorVisible, setIsQuickScreenSelectorVisible] = useState(false);

    const allTags = useMemo(() => {
        return [
            ...Array.from(new Set(apps.flatMap(a => a.tags?.split(",")).filter(t => t))),
            ...Array.from(new Set(screens.flatMap(s => s.tags?.split(",")).filter(t => t)))
        ] as string[];
    }, [screens, apps]);

    const updateApp = (updatedApp: AppType) => {
        setApp(apps.map(app => app.id === updatedApp?.id ? updatedApp : app));
    }

    const changeScreen = async (screenId: string, unselectSelectedApp = false) => {
        if (selectedApp) {
            const response = await fetch(`/api/app/${selectedApp.id}/update-screen`, {
                method: "POST",
                headers: {
                    "Content-Type": "application/json",
                },
                body: JSON.stringify({
                    screenId,
                }),
            });

            if (response.status !== 200) {
                const result = await response.json() as any;
                toast({
                    title: result.message,
                    variant: "destructive",
                });
            } else {
                toast({
                    title: "App updated",
                });
                setIsScreenSelectorVisible(false);
            }
            const updatedApp = await response.json();
            if (updatedApp.createdAt) {
                updatedApp.createdAt = new Date(updatedApp.createdAt);
            }
            updateApp(updatedApp);
            if (unselectSelectedApp) {
                setSelectedApp(null)
            } else {
                setSelectedApp(updatedApp)
            }
        }
    };

    return (
        <div>
            {/* grid */}
            <div className="grid grid-cols-1 sm:grid-cols-2 md:grid-cols-3 lg:grid-cols-4 xl:grid-cols-5 gap-3 p-4 flex-grow">
                {apps.map((app) => {
                    return (
                        <div className="flex w-full"
                            key={app.id}>
                            <GridCard
                                onClick={() => {
                                    setSelectedApp(app);
                                    // router.push("/app/my/" + app.slug);
                                }}
                                onImgClick={() => {
                                    setIsQuickScreenSelectorVisible(true);
                                    setSelectedApp(app);
                                }}
                                title={app.name}
                                imgUrl={app.screen?.uri ? "/" + app.screen?.uri : "/sample-image.jpg"}
                            />
                        </div>
                    )
                })}


                <DrawerDialog
                    title="Add App"
                    description="Add a new app"
                    triggerElement={
                        <GridCard
                            key="new"
                            onClick={() => {
                                // setSelectedApp(app);
                                // router.push("/app/my/" + app.slug);
                            }}
                            title="Add new"
                            imgUrl={"/sample-image.jpg"}
                        />
                    }>
                    <CreateAppForm
                        className="px-4"
                        setSelectedApp={setSelectedApp}
                        isScreenSelectorVisible={isScreenSelectorVisible}
                        showScreenSelector={() => {
                            setIsScreenSelectorVisible(true);
                        }}
                        hideScreenSelector={() => {
                            setIsScreenSelectorVisible(false);
                        }}
                        screens={screens}
                        changeScreen={changeScreen}
                        allTags={allTags}
                        updateApp={updateApp} />
                </DrawerDialog>
            </div>

            {/* app details */}
            <AppDetails
                selectedApp={selectedApp}
                setSelectedApp={setSelectedApp}
                showScreenSelector={() => {
                    setIsScreenSelectorVisible(true);
                }}
                hideScreenSelector={() => {
                    setIsScreenSelectorVisible(false);
                }}
                isScreenSelectorVisible={isScreenSelectorVisible}
                screens={screens}
                changeScreen={changeScreen}
                allTags={allTags}
                updateApp={updateApp} />

            {/* screen selector modal */}
            <ScreenSelectorModal
                screens={screens}
                changeScreen={(screenId: string) => {
                    changeScreen(screenId, true);
                    // close quick select and unselect app;
                    setIsQuickScreenSelectorVisible(false);
                }}
                selectedApp={selectedApp}
                isQuickSelectorVisible={isQuickSelectorVisible}
                setIsQuickScreenSelectorVisible={setIsQuickScreenSelectorVisible} />
        </div>
    )
}

function AppDetails({
    selectedApp,
    setSelectedApp,
    isScreenSelectorVisible,
    showScreenSelector,
    hideScreenSelector,
    screens,
    changeScreen,
    allTags,
    updateApp,
}: {
    selectedApp: AppType,
    setSelectedApp: any,
    isScreenSelectorVisible: boolean | undefined,
    showScreenSelector: any,
    hideScreenSelector: any,
    screens: ScreenTypeArray,
    changeScreen: any,
    allTags: string[],
    updateApp: any,
}) {

    const selectedScreenName = selectedApp?.screen?.name;

    return (

        <Sheet open={Boolean(selectedApp)} onOpenChange={open => {
            if (isScreenSelectorVisible) {
                hideScreenSelector();
            } else {
                if (!open) {
                    setSelectedApp(null);
                }
            }
        }}>
            <SheetContent style={{
                // maxWidth: "100vw"
            }}>
                <SheetHeader>
                    <SheetTitle>
                        {
                            isScreenSelectorVisible ? "Select Screen" : selectedApp?.name
                        }
                    </SheetTitle>
                    {
                        isScreenSelectorVisible ? <></> : (
                            <SheetDescription>
                                {selectedApp?.description}
                            </SheetDescription>
                        )
                    }
                </SheetHeader>
                {
                    isScreenSelectorVisible ? (
                        <ScreenSelector
                            screens={screens}
                            changeScreen={changeScreen}
                            selectedApp={selectedApp} />
                    ) : (
                        <CreateAppForm
                            selectedApp={selectedApp}
                            setSelectedApp={setSelectedApp}
                            showScreenSelector={showScreenSelector}
                            hideScreenSelector={hideScreenSelector}
                            isScreenSelectorVisible={isScreenSelectorVisible}
                            screens={screens}
                            changeScreen={changeScreen}
                            allTags={allTags}
                            updateApp={updateApp} />
                    )
                }
            </SheetContent>
        </Sheet>
    )
}


function CreateAppForm({
    className,
    selectedApp,
    setSelectedApp,
    isScreenSelectorVisible,
    showScreenSelector,
    hideScreenSelector,
    screens,
    changeScreen,
    allTags,
    updateApp,
}: {
    className?: string,
    selectedApp?: AppType,
    setSelectedApp: any,
    isScreenSelectorVisible: boolean | undefined,
    showScreenSelector: any,
    hideScreenSelector: any,
    screens: ScreenTypeArray,
    changeScreen: any,
    allTags?: string[],
    updateApp: any,
}) {

    const { toast } = useToast();

    const formFields = useMemo(() => ({
        name: {
            label: "Name",
            placeholder: "App name",
            defaultValue: selectedApp?.name ?? "",
            validation: z.string().min(2).max(50),
        },
        tags: {
            label: "Tags",
            placeholder: "Tags",
            defaultValue: selectedApp?.tags ?? "",
            validation: z.string(),
            type: "tags",
            tagSuggestions: allTags,
        },
        description: {
            label: "Description",
            placeholder: "App description",
            defaultValue: selectedApp?.description ?? "",
            type: "textarea",
            validation: z.string().min(2).max(250),
        },
        ...(selectedApp ? {
            screen: {
                label: "Custom",
                type: "custom",
                validation: z.string(),
                render: () => (
                    <div className="flex items-center gap-4 pt-2">
                        <Label>Screen</Label>
                        <div
                            className="col-span-3 flex items-center gap-2 max-w-full text-blue-400 cursor-pointer truncate text-xs"
                            onClick={showScreenSelector}>
                            <div className="flex-1 truncate">
                                {selectedApp?.screen?.name ?? "Select screen"}
                            </div>
                        </div>
                    </div>
                )
            },
        } : {}),
        slug: {
            label: "App Slug",
            labelTrail: selectedApp && (
                <Link
                    className="text-blue-400 ml-2"
                    href={`/app/${selectedApp?.slug}`}
                    target='_blank'>
                    <ExternalLink className="inline" size={16} />
                </Link>
            ),
            placeholder: "App Slug",
            defaultValue: selectedApp?.slug ?? "",
            validation: z.string().min(2).max(50),
        },
        ...(selectedApp ? {
            createdAt: {
                label: "Created At",
                type: "custom",
                validation: z.string(),
                render: () => (
                    <div className="flex items-center gap-4 pt-2">
                        <Label>Created</Label>
                        <div className="text-slate-500 col-span-3">{selectedApp?.createdAt.toDateString() ?? "-"}</div>
                    </div>
                )
            },
            updatedAt: {
                label: "Updated At",
                type: "custom",
                validation: z.string(),
                render: () => (
                    <div className="flex items-center gap-4 py-2">
                        <Label>Updated</Label>
                        <div className="text-slate-500 col-span-3">{selectedApp?.createdAt.toDateString() ?? "-"}</div>
                    </div>
                )
            },
        } : {})
    }), [selectedApp])

    const formSchema = getFormSchemaFromFields(formFields);

    async function onSubmit(values: z.infer<typeof formSchema>) {
        const { name, tags, description, slug } = values;
        // return console.log("vaslues", values);
        // const token = localStorage.get('token');
        if (selectedApp) {
            const response = await fetch(`/api/app/${selectedApp.id}`, {
                method: "POST",
                headers: {
                    "Content-Type": "application/json",
                },
                body: JSON.stringify({
                    name,
                    tags,
                    description,
                    slug
                }),
            });

            if (response.status !== 200) {
                const result = await response.json() as any;
                toast({
                    title: result.message,
                    variant: "destructive",
                });
            } else {
                toast({
                    title: "App updated",
                });
            }
            const updatedApp = await response.json();
            if (updatedApp.createdAt) {
                updatedApp.createdAt = new Date(updatedApp.createdAt);
            }
            updateApp(updatedApp);
            setSelectedApp(null);
            return;
        }

        const response = await fetch("/api/app", {
            method: "POST",
            body: JSON.stringify({
                name,
                description,
                slug,
                tags,
            }),
            // headers: {
            //     authorization: `Bearer ${token}`,
            // },
        });
        const result = await response.json() as any;
        if (response.status !== 201) {
            toast({
                title: result.message,
                variant: "destructive",
            });
        } else {
            toast({
                title: "Tile added",
            });
            window.location.reload();
        }
    }

    return (
        <div className={cn("gap-4", className)}>
            <Form
                fields={formFields}
                onSubmit={onSubmit}
                submitLabel={selectedApp ? "Update App" : "Add App"} />
        </div>
    );
}


function ScreenSelector({
    screens,
    changeScreen,
    selectedApp,
}: {
    screens: ScreenTypeArray,
    changeScreen: any,
    selectedApp: AppType
}) {

    const [query, setQuery] = useState("");

    const filteredScreens = query
        ? screens
            .filter(s =>
                s.name.toLowerCase()
                    .includes(query.toLowerCase())
            )
        : screens;

    return (
        <ScrollArea className="h-full py-1">
            {/* search area */}
            <div className="py-2 px-1">
                <Input
                    value={query}
                    onChange={input => setQuery(input.target.value)}
                    placeholder="Type to search..." />
            </div>
            {/* Grid of images */}
            <div className="grid grid-cols-1 gap-4 mt-4">
                {
                    filteredScreens.filter(s => filterSensitive ? !s.isSensitive : true).map(screen => (
                        <GridCard
                            title={screen.name}
                            subtitle={screen.description ?? ""}
                            imgUrl={"/" + screen.uri}
                            key={screen.id}
                            onClick={() => {
                                changeScreen(screen.id);
                            }}
                            isSelected={screen.id === selectedApp?.screen?.id}
                            width="w-auto"
                            isSensitive={screen.isSensitive} />
                    ))
                }
            </div>
        </ScrollArea>
    );
};

function ScreenSelectorModal({
    screens,
    changeScreen,
    selectedApp,
    isQuickSelectorVisible,
    setIsQuickScreenSelectorVisible,
}: {
    screens: ScreenTypeArray,
    changeScreen: any,
    selectedApp: AppType,
    isQuickSelectorVisible?: boolean,
    setIsQuickScreenSelectorVisible: any,
}) {

    const [query, setQuery] = useState("");

    const filteredScreens = query
        ? screens
            .filter(s =>
                s.name.toLowerCase()
                    .includes(query.toLowerCase())
            )
        : screens;

    return (
        <Dialog
            open={isQuickSelectorVisible}
            onOpenChange={open => {
                if (!open) {
                    setIsQuickScreenSelectorVisible(open);
                }
            }}>
            <DialogContent className='sm:max-w-[90vw] h-[90vh] overflow-hidden p-0'>

                {/* search area */}
                <div className="pt-1 px-1">
                    <Input
                        value={query}
                        onChange={input => setQuery(input.target.value)}
                        placeholder="Type to search..." />
                </div>
                <ScrollArea className="h-[80vh]">
                    {/* Grid of images */}
                    <div className="grid sm:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4 gap-4 px-2 md:px-4">
                        {
                            filteredScreens.filter(s => filterSensitive ? !s.isSensitive : true).map(screen => (
                                <GridCard
                                    title={screen.name}
                                    subtitle={screen.description ?? ""}
                                    imgUrl={"/" + screen.uri}
                                    key={screen.id}
                                    onClick={() => {
                                        changeScreen(screen.id);
                                    }}
                                    isSelected={screen.id === selectedApp?.screen?.id}
                                    width="w-auto"
                                    isSensitive={screen.isSensitive} />
                            ))
                        }
                    </div>
                </ScrollArea>
            </DialogContent>
        </Dialog>
    );
};