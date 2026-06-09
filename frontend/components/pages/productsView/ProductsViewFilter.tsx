"use client"
import { Box, Button, Heading, HStack, Text, VStack } from '@chakra-ui/react'
import { useTranslations } from 'next-intl'
import React from 'react'
import TabsFilterBy from '../../shared/TabsFilterBy'
import RangeSlider from '@/components/ui/RangeSlider'
import { SearchIcon } from '@/components/Icons'
import { useProductFilterContext } from '@/providers/ProductFilterProvider'

const ProductsViewFilter = () => {
    const t = useTranslations('store')
    const { applyFilter, removeAllFilters } = useProductFilterContext()
    return (

        <VStack gap={"32px"} w={"320px"}>
            <Box w={"full"}>
                <HStack justify={"space-between"} alignItems={"center"}>
                    <Heading as="h3" fontSize={"24px"} fontWeight={"semibold"}>{t("filters")}</Heading>
                    <Button variant={"ghost"} fontSize={"12px"} fontWeight={"semibold"} color={"black"} _hover={{ color: "white" }} onClick={removeAllFilters}>{t("clearFilters")}</Button>
                </HStack>
                <Text fontSize={"10px"} lineHeight={"28px"} color={"gray-3"}>{t('filtersDescription')}</Text>
            </Box>
            <TabsFilterBy triggerListProps={{ rounded: "16px", overflow: "hidden", borderBottomWidth: "0", borderTopWidth: "2px" }} tabsRootProps={{ rounded: "0" }} tabsContentProps={{ p: "0", pt: "32px" }} />
            <RangeSlider label={t("priceRange")} maxVal={500} />
            <Button w="full" rounded={"16px"} fontSize={"18px"} fontWeight={"bold"} p="16px" onClick={applyFilter}><SearchIcon />{t("applyFilters")}</Button>
        </VStack>

    )
}

export default ProductsViewFilter


// "": "Find Your Tire Now",