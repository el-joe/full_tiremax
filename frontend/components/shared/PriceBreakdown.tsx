"use client";
import CurrencySymbol from "@/components/ui/CurrencySymbol";
import { Heading, HStack, Text, VStack } from "@chakra-ui/react";
import { useTranslations } from "next-intl";

type Props = {
  subtotal: number;
  discount?: number;
  // shown next to the discount label, e.g. "Discount (10%)"
  discountPercent?: number;
  shippingFee?: number;
  total: number;
};

const sizes = { base: "14px", lg: "16px", "2xl": "18px" };
const totalSizes = { base: "18px", lg: "20px", "2xl": "24px" };

const Row = ({
  label,
  value,
  negative,
}: {
  label: string;
  value: number;
  negative?: boolean;
}) => (
  <HStack justify={"space-between"} w="full">
    <Heading fontSize={sizes} fontWeight={"extrabold"}>
      {label}
    </Heading>
    <Text
      fontSize={sizes}
      fontWeight={"bold"}
      color={negative ? "red" : undefined}
    >
      {negative && "-"}
      {value.toLocaleString()} <CurrencySymbol />
    </Text>
  </HStack>
);

// subtotal / coupon discount / shipping / grand total, shared by cart, checkout and order pages
const PriceBreakdown = ({
  subtotal,
  discount = 0,
  discountPercent,
  shippingFee,
  total,
}: Props) => {
  const t = useTranslations("cartAndPayment");
  return (
    <VStack align={"stretch"} w="full" gap={"12px"}>
      <Row label={t("subtotal")} value={subtotal} />
      {discount > 0 && (
        <Row
          label={`${t("discount")}${discountPercent ? ` (${+discountPercent.toFixed(2)}%)` : ""}`}
          value={discount}
          negative
        />
      )}
      {!!shippingFee && shippingFee > 0 && (
        <Row label={t("shippingFee")} value={shippingFee} />
      )}
      <HStack
        justify={"space-between"}
        w="full"
        pt={"12px"}
        borderTop={"1px solid #E5E7EB"}
      >
        <Heading fontSize={totalSizes} fontWeight={"extrabold"}>
          {t("grandTotal")}
        </Heading>
        <Text
          fontSize={totalSizes}
          fontWeight={"bold"}
          color={"primary"}
          ps={"12px"}
        >
          {total.toLocaleString()} <CurrencySymbol />
        </Text>
      </HStack>
    </VStack>
  );
};

export default PriceBreakdown;
