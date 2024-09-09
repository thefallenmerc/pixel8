interface Timestamp {
    createdAt: string;
    updatedAt: string;
    [key: string]: any;
}

export function convertStringToTimestamp<T extends Timestamp>(obj: T): T & {
    createdAt: Date;
    updatedAt: Date;
} {
    return {
        ...obj,
        createdAt: new Date(obj.createdAt),
        updatedAt: new Date(obj.updatedAt),
    };
}