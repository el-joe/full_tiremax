"use client";
import CurrencySymbol from "@/components/ui/CurrencySymbol";
import { Link } from "@/i18n/navigation";
import { IOrder } from "@/types";
import { Badge, Heading, HStack, Image, Text, VStack } from "@chakra-ui/react";
import { useTranslations } from "next-intl";

type props = {
  data: IOrder;
};

const OrderSummary = ({ data }: props) => {
  const t = useTranslations("cartAndPayment");
  // const { cart } = useCartContext();
  return (
    <VStack
      py={{ base: "14px", lg: "26px", "2xl": "40px" }}
      px={{ base: "14px", md: "8px", lg: "22px", "2xl": "32px" }}
      rounded={"16px"}
      gap={{ base: "8px", lg: "22px", "2xl": "31px" }}
      shadow={"0px 40px 80px -20px #00000014"}
      borderTop={"3px solid {colors.primary}"}
      flex={1}
      align={"stretch"}
      // maxW={"422px"}
      w={"full"}
    >
      <HStack alignItems={"start"}>
        {/* order summary title */}
        <Heading
          fontSize={{ base: "18px", lg: "20px", "2xl": "24px" }}
          fontWeight={"extrabold"}
          pb={{ base: "8px", lg: "18px", "2xl": "24px" }}
        >
          {t("orderSummary")}
        </Heading>
        <Badge
          ms={"auto"}
          bg="#FFB80033"
          color={"primary"}
          p={"7px 16px"}
          rounded={"12px"}
          fontSize={"12px"}
        >
          {data.status}
        </Badge>
      </HStack>
      {/* products list */}
      <VStack align={"stretch"}>
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
                >
                  {item.unit_price.toLocaleString()}
                  <CurrencySymbol />
                </Text>
              </VStack>
            </HStack>
          </Link>
        ))}
      </VStack>
      {/* total */}
      <HStack justify={"space-between"}>
        <Heading
          fontSize={{ base: "18px", lg: "20px", "2xl": "24px" }}
          fontWeight={"extrabold"}
        >
          {t("total")}
        </Heading>
        <Text
          fontSize={{ base: "18px", lg: "20px", "2xl": "24px" }}
          fontWeight={"bold"}
          color={"primary"}
          ps={"12px"}
        >
          {data.total.toLocaleString()} <CurrencySymbol />
        </Text>
      </HStack>
      {/* track button */}
      {/* <Button
        shadow={"0px 15px 30px 0px #FFB80040"}
        py={{ base: "18px", lg: "20px", "2xl": "24px" }}
        rounded={"16px"}
        fontSize={{ base: "14px", lg: "16px", "2xl": "18px" }}
        fontWeight={"extrabold"}
        form="checkoutForm"
        type="submit"
      >
        <GiRadarSweep /> {t("trackOrder")}
      </Button> */}
      {/* home button */}
    </VStack>
  );
};

export default OrderSummary;

{
  /* <MdOutlineHandshake /> */
}
