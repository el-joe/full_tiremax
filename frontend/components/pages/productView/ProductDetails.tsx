import CurrencySymbol from "@/components/ui/CurrencySymbol";
import { IProduct, IProductReviewMeta, IReview } from "@/types";
import {
  Box,
  Center,
  Heading,
  HStack,
  Image,
  RatingGroup,
  Span,
  Text,
  VStack,
} from "@chakra-ui/react";
import { getLocale, getTranslations } from "next-intl/server";
import React from "react";
import { FaRegCheckCircle } from "react-icons/fa";
import { MdOutlineLocalShipping } from "react-icons/md";
import { RiShieldCheckLine } from "react-icons/ri";
import { FaStoreAlt } from "react-icons/fa";
import ProductReviews from "./ProductReviews";
type Props = {
  product: IProduct;
  reviews: { data: IReview[]; meta: IProductReviewMeta };
};

const ProductDetails = async ({ product, reviews }: Props) => {
  const t = await getTranslations("productView");
  const locale = await getLocale();
  return (
    <VStack
      gap={{ base: "16px", lg: "26px", xl: "32px" }}
      align={"stretch"}
      flex={1}
    >
      {/* product name */}
      <Heading
        as={"h2"}
        fontSize={{ base: "16px", md: "26px", lg: "32px", xl: "48px" }}
        lineHeight={{ base: "16px", md: "26px", lg: "32px", xl: "48px" }}
        fontWeight={"bold"}
      >
        {product?.name}
      </Heading>
      {/* product description */}
      <Text fontSize={{ base: "12px", md: "14px", lg: "16px", xl: "18px" }}>
        {product?.description ?? product?.short_description}
      </Text>
      {/* price card */}
      <Box
        bg="gray-4"
        p={{ base: "12px", lg: "16px", xl: "24px" }}
        rounded={"16px"}
        borderStart={"4px solid {colors.primary}"}
      >
        {/* price */}
        <Text
          fontSize={{ base: "22px", lg: "28px", xl: "36px" }}
          fontWeight={"bold"}
          color={"primary"}
          mb={"16px"}
        >
          {product.effective_price.toLocaleString()}
          <CurrencySymbol
            fontSize={{ base: "12px", xl: "18px" }}
            color={"black"}
            type="long"
          />
        </Text>
        <HStack mb={"8px"}>
          <FaRegCheckCircle className="text-primary" />
          <Text fontSize={{ base: "11px", xl: "14px" }}>
            {t("priceIncludesInstallationAndBalancing")}
          </Text>
        </HStack>
        <HStack>
          <MdOutlineLocalShipping className="text-primary" />
          <Text fontSize={{ base: "11px", xl: "14px" }}>
            {t("shippingAvailableAllGovernorates")}
          </Text>
        </HStack>
      </Box>
      {/* details cards  */}
      <HStack
        flexWrap={"wrap"}
        gap={{ base: "11px", xl: "16px" }}
        align={"stretch"}
      >
        <DetailsByType product={product} />
      </HStack>
      {/* warranty */}
      <Box>
        <Heading
          fontSize={{ base: "12px", md: "14px", lg: "16px", xl: "18px" }}
          fontWeight={"semibold"}
          mb={"16px"}
        >
          {t("dualWarrantySystem")}
        </Heading>
        <HStack gap={{ base: "11px", xl: "16px" }} align={"stretch"}>
          {/* manufacture warranty card */}
          {product.manufacturer_warranty_months > 0 && (
            <Box
              p={{ base: "8px", lg: "12px", xl: "16px" }}
              rounded={"16px"}
              border={"2px solid {colors.primary}"}
              w={{
                base: "calc((100% - 11px) / 2)",
                xl: "calc((100% - 16px) / 2)",
              }}
            >
              <HStack gap={"8px"} align={"start"}>
                <Center
                  minW={{ base: "26px", lg: "40px" }}
                  h={{ base: "22px", lg: "40px" }}
                  rounded={"full"}
                  bg="#FDB60433"
                  color={"#7C5800"}
                >
                  <RiShieldCheckLine />
                </Center>
                <Box>
                  <Text
                    fontSize={{ base: "12px", lg: "14px" }}
                    fontWeight={"semibold"}
                    mb="4px"
                  >
                    {t("manufacture'sWarranty")}
                  </Text>
                  <Text fontSize={{ base: "9px", lg: "12px" }} color={"gray-2"}>
                    {t("manufacture'sWarrantyDescription")}{" "}
                    {product?.manufacturer_warranty_months} {t("months")}
                  </Text>
                </Box>
              </HStack>
            </Box>
          )}
          {/* agency warranty card */}
          <Box
            p={{ base: "8px", lg: "12px", xl: "16px" }}
            rounded={"16px"}
            border={"2px solid #E5E7EB"}
            w={{
              base: "calc((100% - 11px) / 2)",
              xl: "calc((100% - 16px) / 2)",
            }}
          >
            <HStack gap={"8px"} align={"start"}>
              <Center
                minW={{ base: "26px", lg: "40px" }}
                h={{ base: "22px", lg: "40px" }}
                rounded={"full"}
                bg="#F4F4F5"
                color={"#6B7280"}
              >
                <FaStoreAlt />
              </Center>
              <Box>
                <Text
                  fontSize={{ base: "12px", lg: "14px" }}
                  fontWeight={"semibold"}
                  mb="4px"
                >
                  {t("authorizedWarranty")}
                </Text>
                <Text fontSize={{ base: "9px", lg: "12px" }} color={"gray-2"}>
                  {t("tireMaxExclusiveMaintenance")}
                </Text>
              </Box>
            </HStack>
          </Box>
        </HStack>
      </Box>
      {/* reviews */}
      <ProductReviews
        reviews={{ reviews: reviews.data, meta: reviews?.meta }}
      />
    </VStack>
  );
};

export default ProductDetails;

const DetailsByType = async ({ product }: { product: IProduct }) => {
  const t = await getTranslations("productView");
  if (product?.type === "battery") {
    return (
      <>
        <DetailCard
          title={t("cca")}
          body={product?.battery_spec?.cca.toString()}
        />
        <DetailCard
          title={t("countryOfOrigin")}
          body={product?.brand?.country}
        />
        <DetailCard title={t("make")} body={product?.brand?.name} />
        <DetailCard
          title={t("sizeCode")}
          body={product?.battery_spec?.size_code}
        />
        <DetailCard
          title={t("manufactureYear")}
          body={product?.manufacture_year.toString()}
        />
        <DetailCard
          title={t("batteryType")}
          body={product?.battery_spec?.battery_type}
        />
        <DetailCard
          title={t("voltageAndCapacity")}
          body={`${product?.battery_spec?.voltage} V (${product?.battery_spec?.ampere_hour} A/H)`}
          bodyDir="ltr"
        />
        <DetailCard
          title={t("availability")}
          body={product?.in_stock ? t("availableNow") : t("notAvailable")}
          bodyColor={product?.in_stock ? "green" : "red"}
        />
      </>
    );
  } else {
    return (
      <>
        <DetailCard title={t("size")} body={product?.tire_spec?.size_string} />
        <DetailCard
          title={t("countryOfOrigin")}
          body={product?.brand?.country}
        />
        <DetailCard title={t("make")} body={product?.brand?.name} />
        <DetailCard title={t("treadPattern")} body={product?.pattern_name} />
        <DetailCard
          title={t("manufactureYear")}
          body={product?.manufacture_year.toString()}
        />
        <DetailCard
          title={t("usageType")}
          body={product?.tire_spec?.usage_type}
        />
        <DetailCard
          title={t("loadAndSpeed")}
          body={`${product?.tire_spec?.load_index}(${product?.tire_spec?.speed_rating})`}
        />
        <DetailCard
          title={t("availability")}
          body={product?.in_stock ? t("availableNow") : t("notAvailable")}
          bodyColor={product?.in_stock ? "green" : "red"}
        />
      </>
    );
  }
};

const DetailCard = async ({
  title,
  body,
  bodyColor,
  bodyDir,
}: {
  title: string;
  body: string;
  bodyColor?: string;
  bodyDir?: string;
}) => {
  const locale = await getLocale();
  return (
    <Box
      bg={"gray-4"}
      p={{ base: "8px", lg: "12px", xl: "16px" }}
      rounded={"16px"}
      w={{ base: "calc((100% - 11px) / 2)", xl: "calc((100% - 16px) / 2)" }}
    >
      <Text
        fontSize={"10px"}
        mb={"4px"}
        fontWeight={"semibold"}
        color={"gray-2"}
      >
        {title}
      </Text>
      <Text
        fontWeight={"semibold"}
        color={bodyColor ?? "black"}
        textAlign={locale === "ar" && bodyDir === "ltr" ? "end" : "start"}
        dir={bodyDir}
      >
        {body}
      </Text>
    </Box>
  );
};
