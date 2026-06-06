import { Box, Container, Heading, Highlight, HStack, Image, RatingGroup, Text, VStack } from '@chakra-ui/react'
import { getTranslations } from 'next-intl/server'
import React from 'react'

const WhyUsSection = async () => {
    const t = await getTranslations("home")
    return (
        <Container py="80px" color={"white"} >
            <Heading textAlign={"center"} fontSize={"36px"} fontWeight={"bold"} mb={"64px"}><Highlight query={t("tireMax")} styles={{ color: "primary" }}>{t("whyChooseTireMax")}</Highlight></Heading>
            <HStack gap="24px">
                <VStack h="334px" flex="1" position={"relative"} rounded="48px" overflow={"hidden"} zIndex={1} justifyContent={"end"} alignItems={"start"} p="32px">
                    <Image src={"/images/whyUsBg1.png"} alt="bg" position={"absolute"} inset={"0"} h="full" w={"full"} zIndex={-1} opacity={"40%"} />
                    <Box position={"absolute"} inset="0" bg="#353534" zIndex={-2} />
                    <Heading fontSize={"24px"} fontWeight={"semibold"}>{t("genuineWarranty")}</Heading>
                    <Text fontSize={"14px"}>{t("genuineWarrantyDescription")}</Text>
                </VStack>
                <VStack h="334px" flex="1" position={"relative"} rounded="48px" overflow={"hidden"} zIndex={1} justifyContent={"end"} alignItems={"start"} p="32px">
                    <Image src={"/images/whyUsBg2.jpg"} alt="bg" position={"absolute"} inset={"0"} h="full" w={"full"} zIndex={-1} opacity={"40%"} />
                    <Box position={"absolute"} inset="0" bg="#353534" zIndex={-2} />
                    <Heading fontSize={"24px"} fontWeight={"semibold"}>{t("routineMaintenance")}</Heading>
                    <Text fontSize={"14px"}>{t("genuineWarrantyDescription")}</Text>
                </VStack>
                <VStack h="334px" flex="1" position={"relative"} rounded="48px" overflow={"hidden"} zIndex={1} justifyContent={"end"} alignItems={"start"} p="32px">
                    <Image src={"/images/whyUsBg3.jpg"} alt="bg" position={"absolute"} inset={"0"} h="full" w={"full"} zIndex={-1} opacity={"40%"} />
                    <Box position={"absolute"} inset="0" bg="#353534" zIndex={-2} />
                    <Heading fontSize={"24px"} fontWeight={"semibold"}>{t("quickTurnaround")}</Heading>
                    <Text fontSize={"14px"}>{t("fastServiceDescription")}</Text>
                </VStack>
            </HStack>
            <VStack mt={"120px"} mb={"64px"} gap={"16px"}>
                <Heading textAlign={"center"} fontSize={"36px"} fontWeight={"bold"}>{t("whatOurCustomersSay")}</Heading>
                <RatingGroup.Root readOnly colorPalette={"yellow"} count={5} defaultValue={5} size="lg">
                    <RatingGroup.HiddenInput />
                    <RatingGroup.Control />
                </RatingGroup.Root>
            </VStack>
            <HStack gap={"32px"} >
                <Box p="32px" flex="1" bg="white" color={"black"} rounded={"24px"}>
                    <HStack mb={"24px"} justifyContent={"space-between"}>
                        <Box>
                            <Heading fontSize={"16px"} fontWeight={"semibold"}>{t("testimonialName1")}</Heading>
                            <Text fontSize={"12px"}>{t("testimonialCity1")}</Text>
                        </Box>
                        <Image src="/images/testimonialUserAvatar.jpg" alt='avatar' w="48px" h={"48px"} rounded={"12px"} outline={"2px solid {colors.primary}"} outlineOffset={"1px"} />
                    </HStack>
                    <Text color={"gray-2"}>&quot;{t("testimonial1")}&quot;</Text>
                </Box>
                <Box p="32px" flex="1" bg="white" color={"black"} rounded={"24px"}>
                    <HStack mb={"24px"} justifyContent={"space-between"}>
                        <Box>
                            <Heading fontSize={"16px"} fontWeight={"semibold"}>{t("testimonialName2")}</Heading>
                            <Text fontSize={"12px"}>{t("testimonialCity2")}</Text>
                        </Box>
                        <Image src="/images/testimonialUserAvatar.jpg" alt='avatar' w="48px" h={"48px"} rounded={"12px"} outline={"2px solid {colors.primary}"} outlineOffset={"1px"} />
                    </HStack>
                    <Text color={"gray-2"}>&quot;{t("testimonial2")}&quot;</Text>
                </Box>
                <Box p="32px" flex="1" bg="white" color={"black"} rounded={"24px"}>
                    <HStack mb={"24px"} justifyContent={"space-between"}>
                        <Box>
                            <Heading fontSize={"16px"} fontWeight={"semibold"}>{t("testimonialName3")}</Heading>
                            <Text fontSize={"12px"}>{t("testimonialCity3")}</Text>
                        </Box>
                        <Image src="/images/testimonialUserAvatar.jpg" alt='avatar' w="48px" h={"48px"} rounded={"12px"} outline={"2px solid {colors.primary}"} outlineOffset={"1px"} />
                    </HStack>
                    <Text color={"gray-2"}>&quot;{t("testimonial3")}&quot;</Text>
                </Box>
            </HStack>
        </Container>
    )
}

export default WhyUsSection




//     "testimonialName1": "Ahmad Mohamed",
//     "testimonialCity1": "Baghdad",
//     "testimonial1": "The best tire service in Baghdad. Punctual appointments, highly competitive prices, and the laser wheel balancing made a noticeable difference in my driving experience.",
//     "testimonialName2": "Ahmad Mohamed",
//     "testimonialCity2": "Baghdad",
//     "testimonial2": "The warranty is truly genuine. I had a minor issue with one of the tires, and it was replaced immediately with no hassle at all. I highly recommend them.",
//     "testimonialName3": "Ahmad Mohamed",
//     "testimonialCity3": "Baghdad",
//     "testimonial3": "A very smooth purchase experience on the website. I booked an appointment and went to the branch, and my tires were installed in less than 15 minutes. Thank you, TiraMax."