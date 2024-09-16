import {
    Dialog as DialogPrimitive,
    DialogContent,
    DialogDescription,
    DialogFooter,
    DialogHeader,
    DialogTitle,
} from "@/components/ui/dialog"

export function Dialog({
    open = false,
    title,
    description,
    toggleOpen,
    body,
    footerElement,
}: {
    open: boolean,
    title?: string,
    description?: string,
    toggleOpen?: (open: boolean) => void,
    body?: React.ReactNode,
    footerElement?: React.ReactNode,
}) {
    return (
        <DialogPrimitive open={open} onOpenChange={toggleOpen}>
            <DialogContent className="sm:max-w-[425px]">
                <DialogHeader>
                    <DialogTitle>{title}</DialogTitle>
                    <DialogDescription>{description}</DialogDescription>
                </DialogHeader>
                {body}
                <DialogFooter>{footerElement}</DialogFooter>
            </DialogContent>
        </DialogPrimitive>
    )
}
