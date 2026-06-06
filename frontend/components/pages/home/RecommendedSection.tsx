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
        <Container bg="white" py="50px" rounded={"50px"} overflow={"hidden"}>
            <HStack justifyContent={"space-between"} mb="48px">
                <Heading as={"h2"} fontWeight={"700"} fontSize={"36px"}>{t("recommendedTiresForYou")}</Heading>
                <Button variant={"ghost"} color={'fg'} _hover={{ bg: "transparent" }}>{t("filterBy")}<FilterIcon /></Button>
            </HStack>
            <HStack flexWrap={"wrap"} gap="18px" justifyContent={"center"} alignItems={"stretch"}>
                {data.map(product => <ProductCard key={product.id} product={product} />)}
            </HStack>
        </Container>
    )
}

export default RecommendedSection