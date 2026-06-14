"use client";
import CurrencySymbol from "@/components/ui/CurrencySymbol";
import { useCartContext } from "@/providers/CartProvider";
import {
  Box,
  Button,
  Center,
  Heading,
  HStack,
  Image,
  Text,
  VStack,
} from "@chakra-ui/react";
import { useTranslations } from "next-intl";
import { GoShieldCheck } from "react-icons/go";
import { MdOutlineHandshake } from "react-icons/md";

const CheckoutSummary = () => {
  const t = useTranslations("cartAndPayment");
  const { cart } = useCartContext();
  return (
    <VStack
      py={{ base: "14px", lg: "26px", "2xl": "40px" }}
      px={{ base: "14px", md: "8px", lg: "22px", "2xl": "32px" }}
      rounded={"16px"}
      gap={{ base: "8px", lg: "22px", "2xl": "31px" }}
      shadow={"0px 40px 80px -20px #00000014"}
      borderTop={"3px solid {colors.primary}"}
      flex={1}
      align={"start"}
      maxW={"422px"}
    >
      {/* order summary title */}
      <Heading
        fontSize={{ base: "18px", lg: "20px", "2xl": "24px" }}
        fontWeight={"extrabold"}
        pb={{ base: "8px", lg: "18px", "2xl": "24px" }}
      >
        {t("orderSummary")}
      </Heading>
      {/* products list */}
      <VStack align={"stretch"} w={"full"}>
        {cart.items.map((item) => (
          <HStack
            key={item.id}
            gap="16px"
            align={"stretch"}
            justify={"stretch"}
          >
            <Image
              src={item.product.primary_image ?? "/images/product-image.jpg"}
              alt={item.product.name}
              w="74px"
              rounded={"4px"}
            />
            <VStack justify={"space-between"} align={"stretch"} flex={1}>
              <Heading fontSize={"16px"} fontWeight={"bold"}>
                {item.product.name}
              </Heading>
              <Text
                mt="auto"
                fontSize={"16px"}
                fontWeight={"bold"}
                textAlign={"end"}
              >
                {item.product.effective_price.toLocaleString()}
                <CurrencySymbol />
              </Text>
            </VStack>
          </HStack>
        ))}
      </VStack>
      {/* total */}
      <HStack justify={"space-between"} w={"full"}>
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
          {cart.subtotal.toLocaleString()} <CurrencySymbol />
        </Text>
      </HStack>
      {/* processed button */}
      <Button
        w={"full"}
        shadow={"0px 15px 30px 0px #FFB80040"}
        py={{ base: "18px", lg: "20px", "2xl": "24px" }}
        rounded={"16px"}
        fontSize={{ base: "14px", lg: "16px", "2xl": "18px" }}
        fontWeight={"extrabold"}
        form="checkoutForm"
        type="submit"
      >
        {t("confirmOrder")}
      </Button>
      {/* warranties list */}
      <VStack gap={"24px"} align={"start"}>
        <HStack gap={{ base: "14px", lg: "18px", "2xl": "20px" }}>
          <Center
            minW={{ base: "28px", lg: "32px", "2xl": "46px" }}
            h={{ base: "30px", lg: "34px", "2xl": "48px" }}
            bg={"primary"}
            rounded={"16px"}
            color={"white"}
            fontSize={{ base: "18px", lg: "20px", "2xl": "24px" }}
          >
            <GoShieldCheck strokeWidth={"1px"} />
          </Center>
          <Box>
            <Heading
              fontSize={{ base: "8px", md: "10px", lg: "14px" }}
              fontWeight={"extrabold"}
              lineHeight={"unset"}
            >
              {t("flexible72HourReturnGuarantee")}
            </Heading>
            <Text
              fontSize={{ base: "6px", md: "7px", lg: "10px" }}
              color={"gray-2"}
            >
              {t("easyReturnsAndExchangesDescription")}
            </Text>
          </Box>
        </HStack>
        <HStack gap={"20px"}>
          <Center
            minW={{ base: "28px", lg: "32px", "2xl": "46px" }}
            h={{ base: "30px", lg: "34px", "2xl": "48px" }}
            bg={"primary"}
            rounded={"16px"}
            color={"white"}
            fontSize={{ base: "18px", lg: "20px", "2xl": "24px" }}
          >
            <MdOutlineHandshake />
          </Center>
          <Box>
            <Heading
              fontSize={{ base: "8px", md: "10px", lg: "14px" }}
              fontWeight={"extrabold"}
              lineHeight={"unset"}
            >
              {t("sixMonthAfterSalesSupport")}
            </Heading>
            <Text
              fontSize={{ base: "6px", md: "7px", lg: "10px" }}
              color={"gray-2"}
            >
              {t("afterSalesSupportDescription")}
            </Text>
          </Box>
        </HStack>
      </VStack>
      {/* confirm order disclaimer */}
      <Text fontSize={"12px"} color={"gray-2"}>
        {t("confirmOrderDisclaimer")}
      </Text>
    </VStack>
  );
};

export default CheckoutSummary;

{
  /* <MdOutlineHandshake /> */
}
