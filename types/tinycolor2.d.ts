declare module 'tinycolor2' {
    interface TinyColor {
        isLight(): boolean;
        isDark(): boolean;
        toHexString(): string;
    }

    function tinycolor(color: string | object): TinyColor;

    export = tinycolor;
}
