"use client";
import CurrencySymbol from "@/components/ui/CurrencySymbol";
import { useCartContext } from "@/providers/CartProvider";
import { Box, Button, HStack, Input, Text } from "@chakra-ui/react";
import { useTranslations } from "next-intl";
import { useState } from "react";

const ApplyOfferInput = () => {
  const t = useTranslations("cartAndPayment");
  const { applyOffer, appliedOffer, applyOfferError, isApplyingOffer } =
    useCartContext();
  const [code, setCode] = useState("");

  const handleApply = () => {
    if (!code.trim()) return;
    applyOffer(code.trim());
  };

  return (
    <Box w={"full"}>
      <HStack gap={"8px"}>
        <Input
          value={code}
          onChange={(e) => setCode(e.target.value)}
          placeholder={t("enterOfferCode")}
          rounded={"16px"}
          bg="#F9FAFB"
          fontSize={{ base: "12px", md: "16px" }}
        />
        <Button
          onClick={handleApply}
          loading={isApplyingOffer}
          rounded={"16px"}
          fontWeight={"bold"}
          px={"20px"}
        >
          {t("apply")}
        </Button>
      </HStack>
      {appliedOffer && (
        <Text mt="8px" fontSize={"14px"} fontWeight={"bold"} color={"green"}>
          {t("offerApplied", { title: appliedOffer.offer.title })} (-
          {appliedOffer.discount.toLocaleString()}
          <CurrencySymbol />)
        </Text>
      )}
      {!appliedOffer && applyOfferError && (
        <Text mt="8px" fontSize={"14px"} color={"red"}>
          {applyOfferError}
        </Text>
      )}
    </Box>
  );
};

export default ApplyOfferInput;
