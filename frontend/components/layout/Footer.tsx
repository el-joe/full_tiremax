import { Box, Button, Container, Heading, HStack, Image, Text, VStack } from '@chakra-ui/react'
import { getTranslations } from 'next-intl/server'
import React from 'react'
import { CalenderIcon, FacebookLogoIcon, InstagramLogoIcon, LocationPinIcon, PhoneSignalIcon, WhatsappLogoIcon } from '../Icons'
import { Link } from '@/i18n/navigation'

const Footer = async () => {
    const t = await getTranslations("footer")
    return (
        <Container px={"46px"} pt="80px" pb={"32px"} color={"white"}>
            <HStack justify={"space-between"} align={"start"}>
                <Box>
                    <Image src="/images/logo.svg" mb={"16px"} alt='logo' />
                    <Text fontSize={"14px"} maxW={"315px"}>{t("footerCompanyDescription")}</Text>
                    <HStack px="24px" gap="24px" py={"10px"}>
                        <WhatsappLogoIcon size={"xl"} />
                        <FacebookLogoIcon size={"xl"} />
                        <InstagramLogoIcon size={"xl"} />
                    </HStack>
                </Box>
                <Box>
                    <Heading as={"h4"} fontSize={"16px"} fontWeight={"bold"} mb={"16px"}>{t("quickLinks")}</Heading>
                    <VStack align={"start"} color={"#CBCBCB"} fontSize={"14px"} gap={"8px"}>
                        <Link href={"/"}> <Text _hover={{ color: "white" }}> {t("home")}</Text></Link>
                        <Link href={"/"}> <Text _hover={{ color: "white" }}> {t("aboutUs")}</Text></Link>
                        <Link href={"/"}> <Text _hover={{ color: "white" }}> {t("store")}</Text></Link>
                        <Link href={"/"}> <Text _hover={{ color: "white" }}> {t("offers")}</Text></Link>
                    </VStack>
                </Box>
                <Box>
                    <Heading as={"h4"} fontSize={"16px"} fontWeight={"bold"} mb={"16px"}>{t("services")}</Heading>
                    <VStack align={"start"} color={"#CBCBCB"} fontSize={"14px"} gap={"8px"}>
                        <Link href={"/"}> <Text _hover={{ color: "white" }}> {t("batteries")}</Text></Link>
                        <Link href={"/"}> <Text _hover={{ color: "white" }}> {t("tires")}</Text></Link>
                        <Link href={"/"}> <Text _hover={{ color: "white" }}> {t("serviceCenter")}</Text></Link>
                    </VStack>
                </Box>
                <Box fontSize={"14px"}>
                    <Heading as={"h4"} fontSize={"16px"} fontWeight={"bold"}>{t("contactUs")}</Heading>
                    <HStack gap={"12px"} color={"#CBCBCB"} my={"16px"}>
                        <PhoneSignalIcon color={"primary"} size={"sm"} />
                        <Text dir='ltr'>+964 770 000 0000</Text>
                    </HStack>
                    <HStack gap={"12px"} color={"#CBCBCB"}>
                        <LocationPinIcon size={"sm"} color={"primary"} />
                        <Text>{t("footerAddress")}</Text>
                    </HStack>
                </Box>
                <Box fontSize={"14px"} maxW={"337px"}>
                    <Heading as={"h4"} fontSize={"16px"} fontWeight={"bold"}>{t("serviceBooking")}</Heading>
                    <Text color={"#CBCBCB"} my={"16px"}>{t("footerServiceBookingDescription")}</Text>
                    <Button>{t("bookYourAppointmentNow")}<CalenderIcon /></Button>
                </Box>
            </HStack>
            <Box h={"1px"} bg={"white"} w={"97%"} mx={"auto"} my={"61px"} />
            <HStack justify={"space-around"}>
                <Link href={"/"}>
                    <Text color={"gray-2"} fontSize={"14px"} _hover={{ color: "white" }}>{t("privacyPolicy")}</Text>
                </Link>
                <Text color={"gray-2"} fontSize={"14px"}>{t("allRightsReserved")}</Text>
                <Link href={"/"}>
                    <Text color={"gray-2"} fontSize={"14px"} _hover={{ color: "white" }}>{t("termsAndConditions")}</Text>
                </Link>
            </HStack>
        </Container>
    )
}

export default Footer




// "": "We are committed to delivering the highest standards of quality in tire and vehicle maintenance services to our customers across Iraq, offering world-class brands and guaranteed performance.",
// "": "Quick links",
// "home": "Home",
// "": "About us",
// "": "Store",
// "": "Offers",
// "": "Services",
// "batteries": "Batteries",
// "": "Tires",
// "": "Service center",
// "": "Contact Us",
// "": "Baghdad, Karrada, Al-Saadoun Street",
// "": "Service Booking",
// "": "Book your appointment with ease and choose the time that suits you best—no waiting required.",
// "": "Book Your Appointment Now",
// "privacyPolicy": "Privacy policy",
// "allRightsReserved": "© 2024 TiraMax Iraq. All rights reserved",
// "": "Terms and conditions"