"use client"
import { SearchIcon } from '@/components/Icons'
import DropSelectList from '@/components/ui/DropSelectList'
import Input from '@/components/ui/Input'
import { Button, Group, HStack } from '@chakra-ui/react'
import { useTranslations } from 'next-intl'
import React from 'react'

const Search = () => {
    const t = useTranslations("store")
    return (
        <HStack justify={"space-between"} align={"start"}>
            <Group attached minW={"672px"} align="stretch">
                <Input roundedEnd={"0"} placeholder={t("searchPlaceholder")} py={"19px"} h="auto" />
                <Button roundedEnd={"16px"} h="auto"><SearchIcon />{t("search")}</Button>
            </Group>
            <DropSelectList list={[{ label: "option1", value: "option1" }]} placeholder='select option' name='' containerProps={{ w: "190px" }} triggerProps={{ h: "36px" }} />
        </HStack>
    )
}

export default Search