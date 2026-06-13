"use client"
import { IProduct } from '@/types'
import { Badge, Box, Button, Card, FormatNumber, HStack, IconButton, Image, RatingGroup, Text, VStack } from '@chakra-ui/react'
import React from 'react'
import { BadgeBestIcon, BestPriceCircleIcon, CartPlusIcon, HeartIcon, NewIcon, PercentageCircleIcon } from '../Icons'
import { Tooltip } from '../ui/tooltip'
import { useLocale, useTranslations } from 'next-intl'
import CurrencySymbol from '../ui/CurrencySymbol'
import { Link } from '@/i18n/navigation'
import { useFavContext } from '@/providers/FavProvider'
import { useCartContext } from '@/providers/CartProvider'

type Props = {
    product: IProduct
}
const ProductCard = ({ product }: Props) => {
    const t = useTranslations()
    const locale = useLocale()
    const { isFavorite, toggleFavorite } = useFavContext()
    const { addOrUpdateItem } = useCartContext()
    return (
        <Link href={`/store/${product.id}`}>
            <Card.Root
                //  minW={"137px"}
                //     maxW={"306px"}
                w={{ base: "calc(100% / 2 - 14px)", sm: "140px", md: "230px", lg: "215px", xl: "273px", "2xl": "306px" }}
                // w={{ base: "calc(100% / 2 - 14px)", md: "calc(100% / 3 - 14px)", lg: "calc(100% / 4 - 14px)", xl: "calc(100% / 4 - 22px)", "2xl": "calc(100% / 4 - 32px)" }}
                overflow="hidden" bg={"#F9F9F9"}
                rounded={{ base: "12px", md: "19px", xl: "26px", "2xl": "32px" }}
                p={{ base: "9px", md: "14px", xl: "19px", "2xl": "24px" }}
                border="none"
                className='shadow-[0px_8px_10px_-6px_rgba(26,28,28,0.05)] shadow-[0px_20px_25px_-5px_rgba(26,28,28,0.05)]'
                h={"full"} >
                <Box p={{ base: "6px", md: "9px", xl: "12px", "2xl": "16px" }}
                    bg={"#EEEEEE"}
                    rounded={{ base: "6px", md: "12px", xl: "16px" }}
                    h={{ base: "106px", md: "160px", "2xl": "249px" }}
                    position={"relative"}>
                    {/* favorite button */}
                    <IconButton variant="ghost"
                        color={"primary"}
                        fontWeight={"bold"}
                        position={"absolute"}
                        top="2" left="2"
                        _hover={{ color: "white" }}
                        p={{ base: "4px" }}
                        minW={"auto"}
                        minH={"auto"}
                        onClick={(e) => {
                            e.preventDefault()
                            toggleFavorite(product)
                        }}
                        h={"auto"}><HeartIcon strokeWidth={"4"} fill={isFavorite(product.id) ? "primary" : "none"} size={{ base: "xs", md: "md" }} /></IconButton>
                    {/* badge */}
                    {!!product.badges.length &&
                        <CustomBadge content={product.badges[0]} />
                    }
                    <Image src={product.images[0] || "/images/product-image.jpg"} alt={product.name} w={"full"} objectFit={"cover"} />
                </Box>
                <Card.Body gap="8px" alignItems={"start"} p="0" pt={{ base: "12px", md: "16px", xl: "20px", "2xl": "24px" }}>
                    <Badge size={{ base: "xs", md: "sm", xl: "md" }} color={"gray-2"} fontSize={{ base: "6px", md: "8px", xl: "10px" }} rounded="12px" fontWeight={"bold"} textTransform={"uppercase"} bg={"myGray"}>{product.brand.name}</Badge>
                    <Tooltip content={product.name}>
                        <Card.Title lineClamp={"1"} fontSize={{ base: "12px", md: "15px", xl: "18px" }} lineHeight={{ base: "14px", md: "20px", xl: "28px" }}>{product.name}</Card.Title>
                    </Tooltip>
                    <HStack>
                        {product?.battery_spec?.battery_type && <Badge fontSize={{ base: "6px", md: "8px", xl: "10px" }} fontWeight={"bold"} rounded="12px" bg="myGray">{product?.battery_spec?.battery_type}</Badge>}
                        {product?.tire_spec?.size_string && <Badge fontSize={{ base: "6px", md: "8px", xl: "10px" }} fontWeight={"bold"} rounded="12px" bg="myGray">{product?.tire_spec?.size_string}</Badge>}
                        {product?.category?.name && <Badge fontSize={{ base: "6px", md: "8px", xl: "10px" }} fontWeight={"bold"} rounded="12px" bg="myGray">{product?.category?.name}</Badge>}
                    </HStack>
                    <HStack alignItems={"center"}>
                        <RatingGroup.Root readOnly allowHalf count={5} defaultValue={product.expert_rating} size={{ base: "xs", md: "sm" }} colorPalette={"yellow"}>
                            <RatingGroup.HiddenInput />
                            <RatingGroup.Control dir={locale === "en" ? "ltr" : "rtl"} />
                        </RatingGroup.Root>
                        <Text color="gray-2" fontSize={{ base: "8px", md: "12px" }} lineHeight={"16px"}>({product.views_count})</Text>
                    </HStack>
                </Card.Body>
                <Card.Footer gap="2" justifyContent={"space-between"} p="0" pt={{ base: "6px", md: "12px", xl: "20px" }}>
                    <VStack alignItems="start" gap="0">
                        <Text fontSize={{ base: "16px", md: "20px", xl: "28px" }} lineHeight={"28px"} fontWeight="bold" letterSpacing="tight" mt="2">
                            {product.effective_price.toLocaleString()}
                            {/* {t("iqd")} */}
                            <CurrencySymbol />
                        </Text>
                        {product.has_discount && <Text fontSize={"12px"} fontWeight="bold" textDecoration={"line-through"} color="gray-2">
                            {product.price.toLocaleString()}
                            {t("iqd")}
                        </Text>}
                    </VStack>
                    {/* add to cart button */}
                    <IconButton variant="solid" rounded={"8px"} p={{ base: "8px" }} minW={"auto"} minH={"auto"} h={"auto"} onClick={(e) => { e.preventDefault(); addOrUpdateItem(product, 1) }}><CartPlusIcon size={{ base: "xs", md: "sm", xl: "xl" }} /></IconButton>
                </Card.Footer>
            </Card.Root>
        </Link>
    )
}

export default ProductCard

type badgeProps = {
    content: string;
}

const CustomBadge = ({ content }: badgeProps) => {
    const baseStyle = {
        position: "absolute",
        top: 0,
        right: 0,
        color: "white",
        fontSize: { base: "7px", md: "10px" },
        fontWeight: "800",
        rounded: "12px",
        px: { base: "4px", md: "8px" },
        py: { base: "2px", md: "4px" },
        lineHeight: "16px"
    }
    const formattedContent = content.split("_").join(" ")
    switch (content) {
        case "special_offer":
            return <Badge {...baseStyle} bg="#AE1819" ><PercentageCircleIcon size={"xs"} color="#FFD166" />{formattedContent}</Badge>
        case "best_seller":
            return <Badge {...baseStyle} bg={"primary"} ><BadgeBestIcon size={"xs"} color="#5C4033" />{formattedContent}</Badge>
        case "best_choice":
            return <Badge {...baseStyle} bg="#2E7D32" ><BestPriceCircleIcon size={"xs"} color="#00F40A" />{formattedContent}</Badge>
        case "new":
            return <Badge {...baseStyle} bg="#1976D2" ><NewIcon size={"xs"} color="#B4DDFF" />{formattedContent}</Badge>
        default:
            return <Badge {...baseStyle} ><BadgeBestIcon />{formattedContent}</Badge>
    }
}