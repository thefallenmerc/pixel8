import React from 'react';

type Props = {
    onClick?: () => void,
    imgUrl?: string,
    title: string,
    subtitle?: string,
    width?: string,
    isSelected?: boolean,
    isSensitive?: boolean,
}

export function GridCard(props: Props) {
    return (
        <div
            onClick={props.onClick}
            className={`overflow-hidden rounded bg-white text-slate-500 shadow-md shadow-slate-200 ${props.width ?? "w-[200px]"} ${props.onClick ? "cursor-pointer" : ""} ${props.isSelected ? "border-sky-500" : ""} border-2`}>
            <figure>
                <img
                    src={props.imgUrl}
                    alt="card image"
                    className={`aspect-video w-full ${props.isSensitive ? "blur-sm hover:blur-none transition-all" : ""}`}
                />
                <div className="p-6">
                    <header className="">
                        <h3 className="text-xl font-medium text-slate-700">
                            {props.title}
                        </h3>
                        <p className="text-sm text-slate-400">{props.subtitle}</p>
                    </header>
                </div>
            </figure>
        </div>
    )
}