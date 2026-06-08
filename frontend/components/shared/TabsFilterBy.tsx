"use client"
import { SearchIcon } from '@/components/Icons'
import DropSelectList from '@/components/ui/DropSelectList'
import { Button, HStack, Tabs, TabsContentProps, TabsListProps, TabsRootProps } from '@chakra-ui/react'
import { useLocale, useTranslations } from 'next-intl'
import React from 'react'
import { useForm } from 'react-hook-form'

type props = {
    showButton?: boolean;
    triggerListProps?: TabsListProps
    tabsContentProps?: Omit<TabsContentProps, "value">
    tabsRootProps?: TabsRootProps
}

const TabsFilterBy = ({ showButton, triggerListProps, tabsContentProps, tabsRootProps }: props) => {
    const t = useTranslations("home")
    const locale = useLocale()
    const dir = locale === "ar" ? "rtl" : "ltr"
    return (
        <Tabs.Root defaultValue="foundByVehicle" maxW={"1214px"} bg={"bg"} rounded={"24px"} overflow={"hidden"} {...tabsRootProps}>
            <Tabs.List dir={dir} bg="primary" borderTop={"3px solid {colors.primary}"} {...triggerListProps}>
                <Tabs.Trigger value="foundByVehicle" bg="white" flex="1" justifyContent={"center"} h={"auto"} py={{ base: "2px", md: "8px", xl: "12px" }} _selected={{ bg: "primary", color: "white", "--indicator-color": "transparent" }}>
                    {t("searchByVehicle")}
                </Tabs.Trigger>
                <Tabs.Trigger value="foundBySize" bg="white" flex="1" justifyContent={"center"} h={"auto"} py={{ base: "2px", md: "8px", xl: "12px" }} _selected={{ bg: "primary", color: "white", "--indicator-color": "transparent" }}>
                    {t("searchBySize")}
                </Tabs.Trigger>
            </Tabs.List>
            <Tabs.Content value="foundByVehicle" p={{ base: "8px", md: "19px", xl: "31px" }} dir={dir} {...tabsContentProps}><FoundByVehicle showButton={showButton} /></Tabs.Content>
            <Tabs.Content value="foundBySize" p={{ base: "8px", md: "19px", xl: "31px" }} dir={dir} {...tabsContentProps}><FoundBySize showButton={showButton} /></Tabs.Content>
        </Tabs.Root>
    )
}

export default TabsFilterBy

const FoundByVehicle = ({ showButton }: { showButton?: boolean }) => {
    const t = useTranslations("home")

    return (

        <HStack gapX={{ base: "4px", md: "12px", xl: "24px" }} alignItems="end" flexWrap={"wrap"}>
            <DropSelectList list={[{ label: "option1", value: "option1" }]}
                label={t("category")}
                placeholder={t("selectCategory")}
                name="category"
                containerProps={{ flex: 1 }}
                minW={"200px"}
                triggerProps={{ rounded: "12px" }} />
            <DropSelectList list={[{ label: "option1", value: "option1" }]} label={t("year")} placeholder={t("selectYear")} name="year" containerProps={{ flex: 1 }} minW={"200px"} triggerProps={{ rounded: "12px" }} />
            <DropSelectList list={[{ label: "option1", value: "option1" }]} label={t("make")} placeholder={t("selectMake")} name="make" containerProps={{ flex: 1 }} minW={"200px"} triggerProps={{ rounded: "12px" }} />
            {showButton &&
                <Button rounded={"12px"} type='submit' fontSize={{ base: "12px" }} w={{ base: "full", md: "auto" }}>{t("findYourTireNow")} <SearchIcon /></Button>
            }
        </HStack>
    )
}
const FoundBySize = ({ showButton }: { showButton?: boolean }) => {
    const t = useTranslations("home")
    return (
        <HStack gapX={{ base: "4px", md: "12px", xl: "24px" }} alignItems="end" flexWrap={"wrap"}>
            <DropSelectList list={[{ label: "option1", value: "option1" }]} label={t("height")} placeholder={t("selectHeight")} name="height" containerProps={{ flex: 1 }} minW={"200px"} triggerProps={{ rounded: "12px" }} />
            <DropSelectList list={[{ label: "option1", value: "option1" }]} label={t("width")} placeholder={t("selectWidth")} name="width" containerProps={{ flex: 1 }} minW={"200px"} triggerProps={{ rounded: "12px" }} />
            <DropSelectList list={[{ label: "option1", value: "option1" }]} label={t("diameter")} placeholder={t("selectDiameter")} name="diameter" containerProps={{ flex: 1 }} minW={"200px"} triggerProps={{ rounded: "12px" }} />
            {showButton &&
                <Button rounded={"12px"} type='submit' fontSize={{ base: "12px" }} w={{ base: "full", md: "auto" }}>{t("findYourTireNow")} <SearchIcon /></Button>
            }
        </HStack>
    )
}