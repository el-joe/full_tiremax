"use client"
import { CartPlusIcon, HeartIcon } from '@/components/Icons'
import CurrencySymbol from '@/components/ui/CurrencySymbol'
import { ICustomerCart, IProduct } from '@/types'
import axiosInstance from '@/utils/axiosInstance'
import { Box, Button, HStack, IconButton, Text } from '@chakra-ui/react'
import { useMutation } from '@tanstack/react-query'
import { AxiosError } from 'axios'
import { useTranslations } from 'next-intl'
import React from 'react'
import toast from 'react-hot-toast'

type Props = {
    product: IProduct
}

const Actions = ({ product }: Props) => {
    const t = useTranslations("productView")
    // add to cart mutation
    const { mutate: addToCart, isPending: isAddingToCart } = useMutation({
        mutationKey: ['addToCart'],
        mutationFn: async (body: { product_id: number, quantity: number }) => {
            await axiosInstance.post<{ data: ICustomerCart }>('cart/items', body)
        },
        onError: (err: AxiosError) => {
            toast.error("Oops! something want wrong")
        }
    })
    // add to fav mutation
    const { mutate: addToFav, isPending: isAddingToFav } = useMutation({
        mutationKey: ['addToCart'],
        mutationFn: async (productId: number) => {
            await axiosInstance.post<{ data: ICustomerCart }>(`favorites/${productId}/toggle`)
        },
        onError: (err: AxiosError) => {
            toast.error("Oops! something want wrong")
        }
    })
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
                {/* add to cart button */}
                <Button loading={isAddingToCart} rounded={"8px"} fontSize={{ base: "11px", md: "16px" }} p={{ base: "8px", md: "11px", xl: "16px" }} h={"auto"} onClick={() => addToCart({ product_id: product.id, quantity: 1 })}><CartPlusIcon />{t("addToCart")}</Button>
                {/* add to fav button */}
                <IconButton loading={isAddingToFav} rounded={"8px"} fontSize={{ base: "11px", md: "16px" }} p={{ base: "8px", md: "11px", xl: "16px" }} h={"auto"} onClick={() => addToFav(product.id)}><HeartIcon /></IconButton>
            </HStack>
        </HStack>
    )
}

export default Actions