"use client"
import { CartIcon, CartPlusIcon, HeartIcon } from '@/components/Icons'
import CurrencySymbol from '@/components/ui/CurrencySymbol'
import { IProduct } from '@/types'
import { Box, Button, HStack, IconButton, Text } from '@chakra-ui/react'
import { useTranslations } from 'next-intl'
import React from 'react'

type Props = {
    product: IProduct
}

const Actions = ({ product }: Props) => {
    const t = useTranslations("productView")
    return (
        <HStack justify={"space-between"} py={"16px"} bg={"gray-4"} position={"absolute"} bottom={0} insetX={0} px={"24px"}>
            <Box>
                <Text fontSize={{ base: "9px", md: "12px" }} color={"gray-2"} fontWeight={"semibold"}>{t("total")}</Text>
                <Text fontSize={{ base: "16px", md: "20px", xl: "28px" }} lineHeight={"28px"} fontWeight="bold" letterSpacing="tight">
                    {product.effective_price.toLocaleString()}
                    <CurrencySymbol />
                </Text>
            </Box>
            <HStack gap={"12px"}>
                <Button rounded={"8px"} fontSize={{ base: "11px", md: "16px" }} p={{ base: "8px", md: "11px", xl: "16px" }} h={"auto"}><CartPlusIcon />{t("addToCart")}</Button>
                <IconButton rounded={"8px"} fontSize={{ base: "11px", md: "16px" }} p={{ base: "8px", md: "11px", xl: "16px" }} h={"auto"}><HeartIcon /></IconButton>
            </HStack>
        </HStack>
    )
}

export default Actions