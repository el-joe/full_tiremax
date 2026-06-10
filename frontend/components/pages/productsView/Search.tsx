"use client"
import { SearchIcon } from '@/components/Icons'
import DropSelectList from '@/components/ui/DropSelectList'
import Input from '@/components/ui/Input'
import { useProductFilterContext } from '@/providers/ProductFilterProvider'
import { Button, CloseButton, Group, HStack } from '@chakra-ui/react'
import { useTranslations } from 'next-intl'
import { useState } from 'react'
// best_seller | new | sale | featured
const badges = ["best_seller", "new", "sale", "featured"]

const Search = () => {
    const t = useTranslations("store")
    const { filters, applyFilter } = useProductFilterContext()
    const searchFilter = filters.find(f => f.filterBy === "search")
    const [value, setValue] = useState<string>(searchFilter?.query || "")
    return (
        <HStack justify={"space-between"} align={"start"}>
            <Group attached maxW={"672px"} align="stretch" flex="1">
                <Input roundedEnd={"0"}
                    placeholder={t("searchPlaceholder")}
                    py={{ base: "4px", md: "8px", xl: "19px" }}
                    h="auto"
                    value={value}
                    onChange={(e) => { setValue(e.target.value) }}
                    fontSize={{ base: "12px", md: "14px", lg: "16px" }}
                    endElement={value ? <CloseButton
                        size="xs"
                        onClick={() => {

                            applyFilter({ targetEndpoint: "products", filterBy: "search", query: "" })
                            setValue('')
                        }}
                        me="-2"
                        color={"black"}
                    /> : undefined}
                />
                <Button roundedEnd={"16px"} h="auto" onClick={() => applyFilter({ targetEndpoint: "products", filterBy: "search", query: value })} px={{ base: "4px", md: "7px", xl: "12px" }}><SearchIcon />{t("search")}</Button>
            </Group>
            <DropSelectList list={badges.map(b => ({ label: t(b), value: b }))} onValueChange={(v) => { applyFilter({ targetEndpoint: "products", filterBy: "badge", query: v.value[0] }) }} placeholder='select option' name='' containerProps={{ w: { base: "110px", md: "190px" } }} triggerProps={{ h: { base: "30px", xl: "36px" }, rounded: "16px", minH: "auto" }} />
        </HStack>
    )
}

export default Search