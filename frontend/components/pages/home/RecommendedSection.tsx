import { FilterIcon } from '@/components/Icons'
import ProductCard from '@/components/shared/ProductCard'
import { IProduct } from '@/types'
import { Button, Container, Heading, HStack } from '@chakra-ui/react'
import { getTranslations } from 'next-intl/server'
import React from 'react'

type props = {
    data: IProduct[]
}

const RecommendedSection = async ({ data }: props) => {
    const t = await getTranslations("home")

    return (
        <Container bg="white" py={{ base: "24px", md: "50px" }} rounded={"50px"} overflow={"hidden"} mb={"24px"}>
            {/* header section */}
            <HStack justifyContent={"space-between"} mb={{ base: "19px", md: "34px", xl: "48px" }}>
                <Heading as={"h2"} fontWeight={"700"} fontSize={{ base: "18px", md: "36px" }}>{t("recommendedTiresForYou")}</Heading>
                <Button variant={"ghost"} color={'fg'} _hover={{ bg: "transparent" }}>{t("filterBy")}<FilterIcon /></Button>
            </HStack>
            <HStack flexWrap={"wrap"} gap={{ base: "14px", md: "14px", xl: "22px", "2xl": "32px" }} alignItems={"stretch"}>
                {data.map(product => <ProductCard key={product.id} product={product} />)}
            </HStack>
        </Container>
    )
}

export default RecommendedSection