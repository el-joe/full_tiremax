"use client"
import { Box, Button, Center, Heading, HStack, Spinner, Text, VStack } from '@chakra-ui/react'
import { useTranslations } from 'next-intl'
import React from 'react'
import TabsFilterBy from '../../shared/TabsFilterBy'
import RangeSlider from '@/components/ui/RangeSlider'
import { SearchIcon } from '@/components/Icons'
import { useProductFilterContext } from '@/providers/ProductFilterProvider'
import { useQuery } from '@tanstack/react-query'
import axiosInstance from '@/utils/axiosInstance'
import { IBrand } from '@/types'

const ProductsViewFilter = () => {
    const t = useTranslations('store')
    const { applyFilter, removeAllFilters, filters, setFilter } = useProductFilterContext()
    const { data: brandData, isLoading: brandIsLoading } = useQuery({
        queryKey: ["makeList"],
        queryFn: async () => {
            const { data } = await axiosInstance<{ data: IBrand[] }>("vehicles/makes")
            return data.data
        }
    })
    return (

        <VStack gap={"32px"} w={"320px"}>
            <Box w={"full"}>
                <HStack justify={"space-between"} alignItems={"center"}>
                    <Heading as="h3" fontSize={"24px"} fontWeight={"semibold"}>{t("filters")}</Heading>
                    <Button variant={"ghost"} fontSize={"12px"} fontWeight={"semibold"} color={"black"} _hover={{ color: "white" }} onClick={removeAllFilters}>{t("clearFilters")}</Button>
                </HStack>
                <Text fontSize={"10px"} lineHeight={"28px"} color={"gray-3"}>{t('filtersDescription')}</Text>
            </Box>
            <TabsFilterBy triggerListProps={{ rounded: "16px", overflow: "hidden", borderBottomWidth: "0", borderTopWidth: "2px" }} tabsRootProps={{ rounded: "0", minH: "300px" }} tabsContentProps={{ p: "0", pt: "32px" }} />
            <RangeSlider label={t("priceRange")} maxVal={500} />
            <Box w="full">
                <Heading fontSize={"14px"} fontWeight={"semibold"} mb={"16px"}>{t("brand")}</Heading>
                {brandIsLoading ? <Center> <Spinner size={"lg"} /></Center> :
                    <HStack flexWrap={"wrap"} gap={"8px"}>
                        {brandData?.map(brand => <Button key={brand.id} w="calc(100% / 2 - 8px)" variant={filters.find(f => f.filterBy === "brand_id")?.query === brand.id.toString() ? "solid" : "outline"} onClick={() => setFilter({ targetEndpoint: "products", filterBy: "brand_id", query: brand.id.toString() })} color={"black"} _hover={{ color: "white" }} >{brand.name}</Button>)}
                    </HStack>
                }
            </Box>
            <Button w="full" rounded={"16px"} fontSize={"18px"} fontWeight={"bold"} p="16px" onClick={applyFilter}><SearchIcon />{t("applyFilters")}</Button>
        </VStack>

    )
}

export default ProductsViewFilter

