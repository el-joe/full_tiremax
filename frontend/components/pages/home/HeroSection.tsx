import { LeftArrowIcon, PlayCircleIcon } from '@/components/Icons'
import { Box, Button, Container, HStack, Span, Text, VStack } from '@chakra-ui/react'
import { getLocale, getTranslations } from 'next-intl/server'
import React from 'react'
import FoundTireBox from './FoundTireBox'

const HeroSection = async () => {
    const t = await getTranslations("home")
    const local = await getLocale()
    return (
        <Box rounded={"50px"} bgSize={"cover"} bgImage={"url(/images/heroBg.png)"} overflow={"hidden"} pt={"83px"} pb={"22px"} position={"relative"}>
            <Box className={`inset-0 absolute ${local === "en" ? "bg-linear-to-r" : "bg-linear-to-l"} from-black via-black/40 to-black/0`} />
            <Container ps={"80px"}>
                <VStack gap={"39px"} alignItems={"start"} maxW={"575px"} mb="156px">
                    <Text fontSize={local === "en" ? "75px" : "123px"} fontWeight={"800"} color={"white"} lineHeight={local === "en" ? "85px" : "144px"}>{t("controlStartsWith")} <Span color={"primary"}>{t("theRightTire")}</Span></Text>
                    <Text fontSize={"20px"} color={"white"} maxW={"530px"}>{t("shop,book,andInstall—allInOnePlace,PoweredByTheLatestGlobalTireServiceTechnologies")}</Text>
                    <HStack gap={"16px"}>
                        <Button variant={"outline"} fontSize={"18px"} py={"20px"} h={"auto"}>{t("watchVideo")}<PlayCircleIcon /></Button>
                        <Button fontSize={"18px"} py={"20px"} h={"auto"}>{t("chooseYourTireNow")}<LeftArrowIcon rotate={local === "en" ? "180deg" : ""} /></Button>
                    </HStack>
                </VStack>
                <FoundTireBox />
            </Container>
        </Box>
    )
}

export default HeroSection