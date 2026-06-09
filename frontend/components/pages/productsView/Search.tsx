"use client"
import { SearchIcon } from '@/components/Icons'
import DropSelectList from '@/components/ui/DropSelectList'
import Input from '@/components/ui/Input'
import useApiFilter from '@/hooks/useApiFilter'
import { Button, CloseButton, Group, HStack } from '@chakra-ui/react'
import { useTranslations } from 'next-intl'
import React, { useEffect, useState } from 'react'

const Search = () => {
    const t = useTranslations("store")
    const [value, setValue] = useState<string>("")
    const { filters, setFilter, applyFilter } = useApiFilter()
    useEffect(() => {
        if (filters.find(f => f.filterBy === "search")?.query === "") {
            applyFilter()
        }
    }, [applyFilter, filters])
    return (
        <HStack justify={"space-between"} align={"start"}>
            <Group attached minW={"672px"} align="stretch">
                <Input roundedEnd={"0"}
                    placeholder={t("searchPlaceholder")}
                    py={"19px"}
                    h="auto"
                    value={value}
                    onChange={(e) => { setValue(e.target.value); setFilter({ targetEndpoint: "products", filterBy: "search", query: e.target.value }) }}
                    endElement={<CloseButton
                        size="xs"
                        onClick={() => {
                            setFilter({ targetEndpoint: "products", filterBy: "search", query: "" })
                            setValue('')
                        }

                        }
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