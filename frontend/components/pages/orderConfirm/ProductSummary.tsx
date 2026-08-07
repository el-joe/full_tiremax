import CurrencySymbol from "@/components/ui/CurrencySymbol";
import { Link } from "@/i18n/navigation";
import { IOrder } from "@/types";
import {
  Box,
  Heading,
  HStack,
  Icon,
  Image,
  Text,
  VStack,
} from "@chakra-ui/react";
import { getTranslations } from "next-intl/server";
import React from "react";
import { BiBasket } from "react-icons/bi";

type Props = {
  data: IOrder;
};

export default async function ProductSummary({ data }: Props) {
  const t = await getTranslations("cartAndPayment");
  return (
    <VStack
      align={"stretch"}
      gap={"24px"}
      p="32px"
      rounded={"8px"}
      boxShadow={"0 12px 24px 0 #1A1C1C0F"}
    >
      <HStack justify={"space-between"} mb={"24px"}>
        {/* order id */}
        <Box>
          <Text fontSize={"12px"} color={"gray-2"}>
            ORDER ID
          </Text>
          <Text fontSize={"24px"} fontWeight={"black"}>
            #{data.reference}
          </Text>
        </Box>
        {/* order data */}
        <Box>
          <Text fontSize={"12px"} color={"gray-2"}>
            {t("date")}
          </Text>
          <Text fontSize={"18px"} fontWeight={"bold"}>
            {new Date(data.placed_at).toLocaleDateString()}
          </Text>
        </Box>
      </HStack>
      <Text fontSize={"20px"} fontWeight={"bold"}>
        <Icon me="8px" color={"primary"}>
          <BiBasket />
        </Icon>
        {t("productSummary")}
      </Text>
      {data.items.map((item) => (
        <Link key={item.id} href={`store/${item.product_id}`}>
          <HStack gap="16px" align={"stretch"} justify={"stretch"}>
            <Image
              src={"/images/product-image.jpg"}
              alt={item.product_name}
              w={{ base: "44px", md: "56px", lg: "62px", xl: "74px" }}
              h={{ base: "44px", md: "56px", lg: "62px", xl: "74px" }}
              rounded={"4px"}
            />
            <VStack justify={"space-between"} align={"stretch"} flex={1}>
              <Heading
                fontSize={{ base: "9px", md: "14px", xl: "16px" }}
                fontWeight={"bold"}
              >
                {item.product_name}
              </Heading>
              <Text
                mt="auto"
                fontSize={"16px"}
                fontWeight={"bold"}
                textAlign={"end"}
                color={"primary"}
              >
                {item.unit_price.toLocaleString()}
                <CurrencySymbol />
              </Text>
            </VStack>
          </HStack>
        </Link>
      ))}
    </VStack>
  );
}
