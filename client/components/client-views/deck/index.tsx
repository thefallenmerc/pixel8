"use client";
import { DeckType, TileType } from '@/types/deck.type';
import React, { useEffect, useState } from 'react';
import { SelectInput } from '../../ui/input/select';
import { useToast } from '@/hooks/use-toast';
import { IconName, RadixIcon } from '../../atoms/radix-icon';
import { Dialog } from '../../molecule/drawer';
import { Button } from '@/components/ui/button';
import { Form, getFormSchemaFromFields } from '../../ui/form';
import { z } from 'zod';

const formFields = {
    name: {
        label: "Name",
        placeholder: "Enter tile name",
        defaultValue: "",
        validation: z.string().min(2).max(50),
    },
    icon: {
        label: "Icon",
        placeholder: "Enter tile icon",
        defaultValue: "",
        validation: z.string(),
    },
    type: {
        label: "Command Type",
        type: "select",
        options: [
            { value: "get-api", label: "API:GET" },
        ],
        placeholder: "Select command type",
        defaultValue: "",
        validation: z.string().min(2).max(50),
    },
    command: {
        label: "Command",
        placeholder: "Enter tile command",
        defaultValue: "",
        validation: z.string().min(2).max(150),
    }
};

export function DeckView({
    decks
}: {
    decks: DeckType[]
}) {

    const { toast } = useToast();

    const [isServerHealthy, setIsServerHealthy] = useState(false);
    const [selectedDeck, setSelectedDeck] = useState<DeckType>(decks[0]);
    const [deckTiles, selectedDeckTiles] = useState<TileType[]>([]);
    const [addTileDialogOpen, setAddTileDialogOpen] = useState(false);

    const fetchTiles = async () => {
        if (selectedDeck) {
            const response = await fetch("/api/deck/" + selectedDeck.id + "/tile");
            const tiles = await response.json() as TileType[];
            selectedDeckTiles(tiles);
        }
    }

    useEffect(() => {
        // get deck tiles
        fetchTiles();
        // check for server health every 30 seconds
        if (selectedDeck?.serverAddress) {
            // initial call
            fetch(selectedDeck?.serverAddress + "/api/health-check")
                .then((response) => {
                    setIsServerHealthy(response.status === 200);
                })
                .catch(() => {
                    setIsServerHealthy(false);
                });
            // interval call
            const interval = setInterval(() => {
                fetch(selectedDeck?.serverAddress + "/api/health-check")
                    .then((response) => {
                        setIsServerHealthy(response.status === 200);
                    })
                    .catch(() => {
                        setIsServerHealthy(false);
                    });
            }, 30000);

            return () => clearInterval(interval);
        }
    }, [selectedDeck]);

    const selectDeckById = (id: string) => {
        const deck = decks.find(d => d.id === id);
        if (deck) {
            setSelectedDeck(deck);
        }
    }

    const executeTile = async (tile: TileType) => {
        const response = await fetch("/api/deck/" + selectedDeck.id + "/tile/" + tile.id + "/execute", {
            method: "POST",
        });
        const result = await response.json() as any;
        if (response.status !== 200) {
            toast({
                title: result.message ?? result.error,
                variant: "destructive",
            });
        }
    }

    const formSchema = getFormSchemaFromFields(formFields);

    async function onSubmit(values: z.infer<typeof formSchema>) {
        const { name, icon, type, command } = values;
        const response = await fetch("/api/deck/" + selectedDeck.id + "/tile", {
            method: "POST",
            body: JSON.stringify({
                name,
                icon,
                type,
                command
            }),
        });
        const result = await response.json() as any;
        if (response.status !== 200) {
            toast({
                title: result.message,
                variant: "destructive",
            });
        } else {
            toast({
                title: "Tile added",
            });
            setAddTileDialogOpen(false);
            fetchTiles();
        }
    }

    return (
        <div className="DeckView">
            <div className="flex gap-4 items-center justify-start">
                <SelectInput
                    placeholder={selectedDeck?.name ?? 'Select a deck'}
                    options={decks.map(d => ({ value: d.id, label: d.name }))}
                    onValueChange={selectDeckById} />

                <div
                    className={`w-2 h-2 rounded-full transition-all duration-300 ${!isServerHealthy ? 'bg-red-500' : 'bg-green-500'}`}
                ></div>
            </div>
            <div className="grid grid-cols-3 md:grid-cols-6 xl:grid-cols-9 gap-4 py-4">
                {
                    deckTiles.map(tile => (
                        <div
                            key={tile.id}
                            className={`aspect-square flex flex-col items-center justify-center border rounded active:border-foreground/40 cursor-pointer`}
                            onClick={() => { executeTile(tile) }}>
                            <RadixIcon icon={tile.icon as IconName} size={48} />
                            <div className="pt-2">{tile.name}</div>
                        </div>
                    ))
                }
                <div
                    className={`aspect-square flex flex-col items-center justify-center border rounded active:border-foreground/40 cursor-pointer`}
                    onClick={() => { setAddTileDialogOpen(true) }}>
                    <RadixIcon icon="plus" size={48} />
                    <div className="pt-2">Add new tile</div>
                </div>
            </div>
            <Dialog
                open={addTileDialogOpen}
                toggleOpen={setAddTileDialogOpen}
                title="Add new tile"
                body={(
                    <Form
                        fields={formFields}
                        onSubmit={onSubmit}
                        submitLabel="Add"
                    />
                )} />
        </div>
    )
}