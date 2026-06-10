import CurrencySymbol from '@/components/ui/CurrencySymbol'
import { IProduct } from '@/types'
import { Box, Center, Heading, HStack, Image, RatingGroup, Span, Text, VStack } from '@chakra-ui/react'
import { getLocale, getTranslations } from 'next-intl/server'
import React from 'react'
import { FaRegCheckCircle } from "react-icons/fa";
import { MdOutlineLocalShipping } from "react-icons/md";
import { RiShieldCheckLine } from "react-icons/ri";
import { FaStoreAlt } from "react-icons/fa";
type Props = {
  product: IProduct
}

const ProductDetails = async ({ product }: Props) => {
  const t = await getTranslations("productView")
  const locale = await getLocale()
  return (
    <VStack gap={"32px"} align={"stretch"}>
      <Heading as={"h2"} fontSize={"48px"} lineHeight={"48px"} fontWeight={"bold"}>{product?.name}</Heading>
      <Text fontSize={"18px"}>{product?.description ?? product?.short_description}</Text>
      <Box bg="gray-4" p="24px" rounded={"16px"} borderStart={"4px solid {colors.primary}"}>
        <Text fontSize={"36px"} fontWeight={'bold'} color={"primary"} mb={"16px"}>{product.effective_price.toLocaleString()}<CurrencySymbol fontSize={"18px"} color={"black"} type='long' /></Text>
        <HStack mb={"8px"}><FaRegCheckCircle className='text-primary' /><Text>{t("priceIncludesInstallationAndBalancing")}</Text></HStack>
        <HStack><MdOutlineLocalShipping className='text-primary' /><Text>{t("shippingAvailableAllGovernorates")}</Text></HStack>
      </Box>
      {/* details cards  */}
      <HStack flexWrap={"wrap"} gap={"16px"}>
        <DetailCard title={t("size")} body={product?.tire_spec?.size_string} />
        <DetailCard title={t("countryOfOrigin")} body={product?.tire_spec?.size_string} />
        <DetailCard title={t("make")} body={product?.brand?.name} />
        <DetailCard title={t("treadPattern")} body={product?.pattern_name} />
        <DetailCard title={t("manufactureYear")} body={product?.manufacture_year.toString()} />
        <DetailCard title={t("usageType")} body={product?.tire_spec?.usage_type} />
        <DetailCard title={t("loadAndSpeed")} body={`${product?.tire_spec?.load_index}(${product?.tire_spec?.speed_rating})`} />
        <DetailCard title={t("availability")} body={product?.in_stock ? t("availableNow") : t("notAvailable")} bodyColor={product?.in_stock ? "green" : "red"} />
      </HStack>
      <Box>
        <Heading fontSize={"18px"} fontWeight={"semibold"} mb={"16px"}>{t("dualWarrantySystem")}</Heading>
        <HStack gap={"16px"}>
          {/* manufacture warranty card */}
          {product.manufacturer_warranty_months > 0 &&
            <Box p={"20px"} rounded={"16px"} border={"2px solid {colors.primary}"} w="calc((100% - 16px) / 2)">
              <HStack gap={"8px"} align={"start"}>
                <Center w="40px" h="40px" rounded={"full"} bg="#FDB60433" color={"#7C5800"}>
                  <RiShieldCheckLine />
                </Center>
                <Box>
                  <Text fontSize={"14px"} fontWeight={"semibold"} mb="4px">{t("manufacture'sWarranty")}</Text>
                  <Text fontSize={"12px"} color={"gray-2"}>{t("manufacture'sWarrantyDescription")} {product?.manufacturer_warranty_months} {t("months")}</Text>
                </Box>
              </HStack>
            </Box>
          }
          {/* agency warranty card */}
          <Box p={"20px"} rounded={"16px"} border={"2px solid #E5E7EB"} w="calc((100% - 16px) / 2)">
            <HStack gap={"8px"} align={"start"}>
              <Center w="40px" h="40px" rounded={"full"} bg="#F4F4F5" color={"#6B7280"}>
                <FaStoreAlt />
              </Center>
              <Box>
                <Text fontSize={"14px"} fontWeight={"semibold"} mb="4px">{t("authorizedWarranty")}</Text>
                <Text fontSize={"12px"} color={"gray-2"}>{t("tireMaxExclusiveMaintenance")}</Text>
              </Box>
            </HStack>
          </Box>
        </HStack>
      </Box>
      {/* reviews */}
      <Box>
        <HStack mb={"16px"} justify={"space-between"}>
          <Text fontSize={"18px"} fontWeight={"semibold"}>{t("userReviews")}</Text>
          <HStack>
            <RatingGroup.Root readOnly allowHalf count={5} defaultValue={product.expert_rating} size={{ base: "sm", md: "lg" }} colorPalette={"yellow"}>
              <RatingGroup.HiddenInput />
              <RatingGroup.Control dir={locale === "en" ? "ltr" : "rtl"} />
            </RatingGroup.Root>
            <Text fontWeight={"bold"}>{product?.views_count}</Text>
          </HStack>
        </HStack>
        <Box p={"20px"} rounded={"16px"} border={"2px solid {colors.primary}"} >
          <HStack gap={"8px"} align={"start"} justify={"space-between"}>
            <Box>
              <Text fontSize={"14px"} fontWeight={"semibold"} mb="4px">Saeed Sayed</Text>
              <Text fontSize={"12px"} color={"gray-2"}>منذ يومين</Text>
            </Box>
            <Image src={"/images/testimonialUserAvatar.jpg"} alt='avatar' w="48px" h={"48px"} rounded={"12px"} outline={"2px solid {colors.primary}"} outlineOffset={"1px"} />
          </HStack>
          <Text fontSize={"14px"} color={"gray-2"}>أفضل إطارات جربتها على الإطلاق، هدوء تام وثبات عالي جداً في المنعطفات.</Text>
        </Box>
      </Box>
    </VStack>
  )
}

export default ProductDetails

const DetailCard = ({ title, body, bodyColor }: { title: string, body: string, bodyColor?: string }) => {
  return <Box bg={"gray-4"} p={"16px"} rounded={"16px"} w="calc((100% - 16px)/ 2)">
    <Text fontSize={"10px"} mb={"4px"} fontWeight={"semibold"} color={"gray-2"}>{title}</Text>
    <Text fontWeight={"semibold"} color={bodyColor ?? "black"}>{body}</Text>
  </Box>
}
