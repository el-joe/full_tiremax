"use client"
import { SearchIcon } from '@/components/Icons'
import DropSelectList from '@/components/ui/DropSelectList'
import Input from '@/components/ui/Input'
import useApiFilter from '@/hooks/useApiFilter'
import { Button, CloseButton, Group, HStack } from '@chakra-ui/react'
import { useTranslations } from 'next-intl'
import React from 'react'

const Search = () => {
    const t = useTranslations("store")
    const { filters, setFilter, applyFilter } = useApiFilter()
    return (
        <HStack justify={"space-between"} align={"start"}>
            <Group attached minW={"672px"} align="stretch">
                <Input roundedEnd={"0"}
                    placeholder={t("searchPlaceholder")}
                    py={"19px"}
                    h="auto"
                    value={filters.find(f => f.filterBy === "search")?.query}
                    onChange={(e) => { setFilter({ targetEndpoint: "products", filterBy: "search", query: e.target.value }) }}
                    endElement={<CloseButton
                        size="xs"
                        onClick={() => {
                            setFilter({ targetEndpoint: "products", filterBy: "search", query: "" })
                            applyFilter()
                        }}
                        me="-2"
                        color={"black"}
                    />}
                />
                <Button roundedEnd={"16px"} h="auto" onClick={applyFilter}><SearchIcon />{t("search")}</Button>
            </Group>
            <DropSelectList list={[{ label: "option1", value: "option1" }]} placeholder='select option' name='' containerProps={{ w: "190px" }} triggerProps={{ h: "36px" }} />
        </HStack>
    )
}

export default Search