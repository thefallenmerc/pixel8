import React, { useEffect, useRef, useState } from 'react';
import ColorThief from 'colorthief';
import tinycolor from 'tinycolor2';

if (!(window as any).colorData) {
    (window as any).colorData = {};
}

type Props = {
    onClick?: () => void,
    onImgClick?: () => void,
    imgUrl?: string,
    title: string,
    subtitle?: string,
    width?: string,
    isSelected?: boolean,
    isSensitive?: boolean,
}

export function GridCard(props: Props) {

    const imageRef = useRef<HTMLImageElement>(null)
    const [accentColor, setAccentColor] = useState<string>("#ffffff")
    const [textColor, setTextColor] = useState<string>('#000000')


    useEffect(() => {
        if (props.imgUrl && imageRef.current) {
            const colorThief = new ColorThief()
            const img = imageRef.current

            // check in global
            if ((window as any).colorData[props.imgUrl]) {
                const { accentColor, textColor } = (window as any).colorData[props.imgUrl];
                setAccentColor(accentColor as string);
                setTextColor(textColor as string);
                return;
            }

            if (img.complete) {
                extractColor(img, colorThief)
            } else {
                img.onload = () => extractColor(img, colorThief)
            }
        }
    }, [props.imgUrl])


    const extractColor = (img: HTMLImageElement, colorThief: ColorThief) => {
        try {
            const dominantColor = colorThief.getColor(img)
            const colorHex = rgbToHex(dominantColor[0], dominantColor[1], dominantColor[2])
            setAccentColor(colorHex)

            const color = tinycolor(colorHex)
            const newTextColor = color.isLight() ? '#000000' : '#ffffff'
            setTextColor(newTextColor);

            // save to global
            (window as any).colorData[props.imgUrl!] = {
                accentColor: colorHex,
                textColor: newTextColor,
            }

            // document.body.style.backgroundColor = colorHex
            // document.body.style.color = newTextColor
        } catch (error) {
            console.error('Error extracting color:', error)
        }
    }

    const rgbToHex = (r: number, g: number, b: number) => {
        return '#' + [r, g, b].map(x => {
            const hex = x.toString(16)
            return hex.length === 1 ? '0' + hex : hex
        }).join('')
    }

    return (
        <div
            onClick={props.onClick}
            className={`grid-card group overflow-hidden relative rounded-xl shadow-md shadow-slate-200 ${props.onClick ? "cursor-pointer" : ""} ${props.isSelected ? "border-sky-500" : ""} border-2`} style={{
                backgroundColor: accentColor,
                color: "#fff"
            }}>
            <figure>
                <img
                    ref={imageRef}
                    src={props.imgUrl}
                    alt="card image"
                    className={`aspect-video w-full transform-gpu transition-transform duration-300 ease-in-out group-hover:scale-110 ${props.isSensitive ? "blur-sm hover:blur-none transition-all" : ""}`}
                    onClick={e => {
                        if (props.onImgClick) {
                            e.stopPropagation();
                            props.onImgClick();
                        }
                    }}
                />
                <div className={`
                    p-2 absolute w-full
                    bottom-0 right-0 flex flex-col
                    items-end rounded-xl
                    transform-gpu transition-all duration-300
                    opacity-50 group-hover:opacity-100`}>
                    <header className="max-w-full">
                        <h3 className="truncate">
                            {props.title}
                        </h3>
                    </header>
                </div>
            </figure>
        </div>
    )
}