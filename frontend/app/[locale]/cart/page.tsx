import CartSummary from "@/components/pages/cart/CartSummary";
import ItemsList from "@/components/pages/cart/ItemsList";
import Container from "@/components/ui/Container";
import { Heading, HStack } from "@chakra-ui/react";
import { Metadata } from "next";
import { getTranslations } from "next-intl/server";
import React from "react";

export const metadata: Metadata = {
  title: "cart",
};

export default async function page() {
  const t = await getTranslations("cartAndPayment");
  return (
    <Container>
      <Heading
        as="h1"
        font={"48px"}
        fontWeight={"extrabold"}
        mb={{ base: "24px", md: "36px", lg: "40px", "2xl": "60px" }}
      >
        {t("shoppingCart")}
      </Heading>
      <HStack
        gap={{ base: "22px", md: "22px", lg: "30px", "2xl": "48px" }}
        align={"start"}
        justify={"center"}
        flexWrap={"wrap"}
      >
        <ItemsList />
        <CartSummary />
      </HStack>
    </Container>
  );
}
