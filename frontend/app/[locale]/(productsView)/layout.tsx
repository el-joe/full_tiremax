import ProductsViewFilter from '@/components/pages/productsView/ProductsViewFilter'
import Search from '@/components/pages/productsView/Search'
import Container from '@/components/ui/Container'
import { ProductFilterProvider } from '@/providers/ProductFilterProvider'
import { Heading, HStack, Text, VStack } from '@chakra-ui/react'
import { getTranslations } from 'next-intl/server'
import { headers } from 'next/headers'
import React from 'react'

type Props = {
    children: React.ReactNode
}

const layout = async ({ children }: Props) => {
    const pathname = (await headers()).get("x-pathname")?.split("/")
    const currentPageTitle = pathname?.[2] as string
    const t = await getTranslations("store")

    return (
        <Container>
            <Heading textAlign={"center"} fontSize={"38px"} fontWeight={"extrabold"}>{t(currentPageTitle)}</Heading>
            <Text textAlign={"center"} mt={"16px"} mb={"70px"} color={"gray"} fontSize={"18px"}>{t("productCatalogDescription")}</Text>
            <HStack gap={"32px"} align="start">
                <ProductFilterProvider>
                    <ProductsViewFilter />
                </ProductFilterProvider>
                <VStack flex={1} align={"stretch"} gap="48px">
                    <Search />
                    {children}
                </VStack>
            </HStack>
        </Container>
    )
}

export default layout

