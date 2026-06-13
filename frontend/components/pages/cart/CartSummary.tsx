"use client"
import CurrencySymbol from '@/components/ui/CurrencySymbol'
import { Link } from '@/i18n/navigation'
import { useCartContext } from '@/providers/CartProvider'
import { Box, Button, Center, Heading, HStack, Text, VStack } from '@chakra-ui/react'
import { useTranslations } from 'next-intl'
import { GoShieldCheck } from "react-icons/go";
import React from 'react'
import { MdOutlineHandshake } from 'react-icons/md'

const CartSummary = () => {
    const t = useTranslations("cartAndPayment")
    const { cart, totalQuantity } = useCartContext()
    if (!totalQuantity) {
        return <></>
    }
    return (
        <VStack py={{ base: "14px", lg: "26px", "2xl": "40px" }} px={{ base: "14px", md: "8px", lg: "22px", "2xl": "32px" }} rounded={"16px"} gap={{ base: "8px", lg: "22px", "2xl": "31px" }} shadow={"0px 40px 80px -20px #00000014"} borderTop={"3px solid {colors.primary}"} flex={1} align={"start"} maxW={"422px"}>
            <Heading fontSize={{ base: "18px", lg: "20px", "2xl": "24px" }} fontWeight={"extrabold"} pb={{ base: "8px", lg: "18px", "2xl": "24px" }}>{t("orderSummary")}</Heading>
            <Box>
                <Heading fontSize={{ base: "18px", lg: "20px", "2xl": "24px" }} fontWeight={"extrabold"}>{t("subtotal")}</Heading>
                <Text fontSize={{ base: "18px", lg: "20px", "2xl": "24px" }} fontWeight={"bold"} color={"primary"} ps={"12px"}>{cart.subtotal.toLocaleString()} <CurrencySymbol /></Text>
            </Box>
            <Link href={"checkout"} className='w-full' ><Button w={"full"} shadow={"0px 15px 30px 0px #FFB80040"} py={{ base: "18px", lg: "20px", "2xl": "24px" }} rounded={"16px"} fontSize={{ base: "14px", lg: "16px", "2xl": "18px" }} fontWeight={"extrabold"}>{t("proceedToCheckout")}</Button></Link>
            <VStack gap={"24px"} align={"start"}>
                <HStack gap={{ base: "14px", lg: "18px", "2xl": "20px" }}>
                    <Center minW={{ base: "28px", lg: "32px", "2xl": "46px" }} h={{ base: "30px", lg: "34px", "2xl": "48px" }} bg={"primary"} rounded={"16px"} color={"white"} fontSize={{ base: "18px", lg: "20px", "2xl": "24px" }}><GoShieldCheck strokeWidth={"1px"} /></Center>
                    <Box>
                        <Heading fontSize={{ base: "8px", md: "10px", lg: "14px" }} fontWeight={"extrabold"} lineHeight={"unset"}>{t("flexible72HourReturnGuarantee")}</Heading>
                        <Text fontSize={{ base: "6px", md: "7px", lg: "10px" }} color={"gray-2"}>{t("easyReturnsAndExchangesDescription")}</Text>
                    </Box>
                </HStack>
                <HStack gap={"20px"}>
                    <Center minW={{ base: "28px", lg: "32px", "2xl": "46px" }} h={{ base: "30px", lg: "34px", "2xl": "48px" }} bg={"primary"} rounded={"16px"} color={"white"} fontSize={{ base: "18px", lg: "20px", "2xl": "24px" }}><MdOutlineHandshake /></Center>
                    <Box>
                        <Heading fontSize={{ base: "8px", md: "10px", lg: "14px" }} fontWeight={"extrabold"} lineHeight={"unset"}>{t("sixMonthAfterSalesSupport")}</Heading>
                        <Text fontSize={{ base: "6px", md: "7px", lg: "10px" }} color={"gray-2"}>{t("afterSalesSupportDescription")}</Text>
                    </Box>
                </HStack>
            </VStack>
        </VStack>
    )
}

export default CartSummary

{/* <MdOutlineHandshake /> */ }