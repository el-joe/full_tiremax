"use client"
import { Button, CloseButton, Dialog, Portal } from '@chakra-ui/react'
import React, { useState } from 'react'
import Filters from './Filters'
import { useLocale, useTranslations } from 'next-intl'

const SmallScreenFilters = () => {
    const t = useTranslations("store")
    const locale = useLocale()
    const dir = locale === "ar" ? "rtl" : "ltr"
    const [open, setOpen] = useState(false)
    return (
        <Dialog.Root open={open} onOpenChange={(e) => setOpen(e.open)}>
            <Dialog.Trigger asChild>
                <Button size="sm" roundedRight={"0"} >
                    {t('filters')}
                </Button>
            </Dialog.Trigger>
            <Portal>
                <Dialog.Backdrop />
                <Dialog.Positioner>
                    <Dialog.Content>
                        <Dialog.Body dir={dir}>
                            <Filters setDialog={setOpen} />
                        </Dialog.Body>
                        <Dialog.CloseTrigger asChild>
                            <CloseButton size="md" color={"black"} />
                        </Dialog.CloseTrigger>
                    </Dialog.Content>
                </Dialog.Positioner>
            </Portal>
        </Dialog.Root>
    )
}

export default SmallScreenFilters