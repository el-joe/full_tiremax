"use client"
import { SearchIcon } from '@/components/Icons'
import DropSelectList from '@/components/ui/DropSelectList'
import { Button, HStack, Tabs } from '@chakra-ui/react'
import { useTranslations } from 'next-intl'
import React from 'react'
import { useForm } from 'react-hook-form'

const FoundTireBox = () => {
    const t = useTranslations("home")
    return (
        <Tabs.Root defaultValue="members" maxW={"1214px"} bg={"bg"} rounded={"24px"} overflow={"hidden"}>
            <Tabs.List bg="primary" pt="4px">
                <Tabs.Trigger value="members" bg="white" flex="1" justifyContent={"center"} _selected={{ bg: "primary", color: "white", "--indicator-color": "transparent" }}>
                    {t("searchByVehicle")}
                </Tabs.Trigger>
                <Tabs.Trigger value="projects" bg="white" flex="1" justifyContent={"center"} _selected={{ bg: "primary", color: "white", "--indicator-color": "transparent" }}>
                    {t("searchBySize")}
                </Tabs.Trigger>
            </Tabs.List>
            <Tabs.Content value="members" py={"32px"} px={"31px"}><FoundByVehicle /></Tabs.Content>
            <Tabs.Content value="projects" py={"32px"} px={"31px"}><FoundByVehicle /></Tabs.Content>
        </Tabs.Root>
    )
}

export default FoundTireBox

const FoundByVehicle = () => {
    const t = useTranslations("home")
    const { handleSubmit } = useForm()
    const onSubmit = handleSubmit((data) => {
        console.log(data)
    })

    return (
        <form onSubmit={onSubmit}>
            <HStack gap={"24px"} alignItems="end">
                <DropSelectList list={[{ label: "option1", value: "option1" }]} label={t("category")} placeholder={t("selectCategory")} name="category" containerProps={{ flex: 1 }} triggerProps={{ rounded: "12px" }} />
                <DropSelectList list={[{ label: "option1", value: "option1" }]} label={t("year")} placeholder={t("selectYear")} name="year" containerProps={{ flex: 1 }} triggerProps={{ rounded: "12px" }} />
                <DropSelectList list={[{ label: "option1", value: "option1" }]} label={t("brand")} placeholder={t("selectBrand")} name="brand" containerProps={{ flex: 1 }} triggerProps={{ rounded: "12px" }} />
                <Button flex={1} rounded={"12px"} type='submit'>{t("findYourTireNow")} <SearchIcon /></Button>
            </HStack></form>)
}