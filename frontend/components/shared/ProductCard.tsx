"use client"
import { IProduct } from '@/types'
import { Badge, Box, Button, Card, FormatNumber, HStack, IconButton, Image, RatingGroup, Text, VStack } from '@chakra-ui/react'
import React from 'react'
import { BadgeBestIcon, BestPriceCircleIcon, CartPlusIcon, HeartIcon, NewIcon, PercentageCircleIcon } from '../Icons'
import { Tooltip } from '../ui/tooltip'
import { useLocale, useTranslations } from 'next-intl'

type Props = {
    product: IProduct
}

const ProductCard = ({ product }: Props) => {
    const t = useTranslations()
    const locale = useLocale()
    return (
        <Card.Root w="306px" overflow="hidden" bg={"#F9F9F9"} rounded={"32px"} p="24px" border="none" className='shadow-[0px_8px_10px_-6px_rgba(26,28,28,0.05)] shadow-[0px_20px_25px_-5px_rgba(26,28,28,0.05)]' h={"auto"} >
            <Box p="16px" bg={"#EEEEEE"} rounded={"16px"} position={"relative"}>
                <IconButton variant="ghost" color={"primary"} fontWeight={"bold"} position={"absolute"} top="2" left="2" _hover={{ color: "white" }}><HeartIcon strokeWidth={"4"} /></IconButton>
                <CustomBadge content={product.badges[0]} />
                <Image src={product.images[0] || "/images/product-image.jpg"} alt={product.name} />
            </Box>
            <Card.Body gap="8px" alignItems={"start"} p="0" pt={"24px"}>
                <Badge size={"md"} color={"gray-2"} fontSize={"10px"} rounded="12px" fontWeight={"bold"} textTransform={"uppercase"} bg={"myGray"}>{product.brand.name}</Badge>
                <Card.Title lineClamp={"1"} fontSize={"18px"} lineHeight={"28px"}>{product.name}</Card.Title>
                {product?.tire_spec?.size_string && <Badge fontSize={"10px"} fontWeight={"bold"} rounded="12px" bg="myGray">{product?.tire_spec?.size_string}</Badge>}
                <HStack alignItems={"center"}>
                    <RatingGroup.Root readOnly allowHalf count={5} defaultValue={product.expert_rating} size="sm" colorPalette={"yellow"}>
                        <RatingGroup.HiddenInput />
                        <RatingGroup.Control dir={locale === "en" ? "ltr" : "rtl"} />
                    </RatingGroup.Root>
                    <Text color="gray-2" fontSize={"12px"} lineHeight={"16px"}>({product.views_count})</Text>
                </HStack>
            </Card.Body>
            <Card.Footer gap="2" justifyContent={"space-between"} p="0" pt={"20px"}>
                <VStack alignItems="start" gap="0">
                    <Text fontSize={"28px"} lineHeight={"28px"} fontWeight="bold" letterSpacing="tight" mt="2">
                        {product.effective_price.toLocaleString()}
                        {t("iqd")}
                    </Text>
                    {!product.has_discount && <Text fontSize={"12px"} fontWeight="bold" textDecoration={"line-through"} color="gray-2">
                        {product.price.toLocaleString()}
                        {t("iqd")}
                    </Text>}
                </VStack>
                <IconButton variant="solid" rounded={"8px"}><CartPlusIcon /></IconButton>
            </Card.Footer>
        </Card.Root>
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
        fontSize: "10px",
        fontWeight: "800",
        rounded: "12px",
        px: "8px",
        py: "4px",
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