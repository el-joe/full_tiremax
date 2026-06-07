import { ChevronLeftIcon } from '@/components/Icons'
import ProductCard from '@/components/shared/ProductCard'
import { Link } from '@/i18n/navigation'
import { IProduct } from '@/types'
import { Container, Heading, HStack } from '@chakra-ui/react'
import { getLocale, getTranslations } from 'next-intl/server'
import React from 'react'

type props = {
    data: IProduct[]
}

const RecommendedOffersSection = async ({ data }: props) => {
    const t = await getTranslations("home")
    const locale = await getLocale()
    return (
        <Container bg="white" py={{ base: "24px", md: "50px" }} rounded={"50px"} overflow={"hidden"}>
            <HStack justifyContent={"space-between"} mb={{ base: "19px", md: "34px", xl: "48px" }}>
                <Heading as={"h2"} fontWeight={"700"} fontSize={{ base: "18px", md: "36px" }}>{t("recommendedOffersForYou")}</Heading>
                <Link href={"/"} ><HStack>{t("showAll")}<ChevronLeftIcon rotate={locale === "en" ? "180deg" : "0deg"} size={"md"} /></HStack></Link>
            </HStack>
            <HStack flexWrap={"wrap"} gap={{ base: "14px", md: "14px", xl: "22px", "2xl": "32px" }} alignItems={"stretch"}>
                {data.map(product => <ProductCard key={product.id} product={product} />)}
            </HStack>
        </Container>
    )
}

export default RecommendedOffersSection