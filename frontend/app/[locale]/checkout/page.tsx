import CheckoutForm from "@/components/pages/checkout/CheckoutForm";
import CheckoutSummary from "@/components/pages/checkout/CheckoutSummary";
import Container from "@/components/ui/Container";
import { Heading, HStack } from "@chakra-ui/react";
import { Metadata } from "next";
import { getTranslations } from "next-intl/server";
import React from "react";

export const metadata: Metadata = {
  title: "checkout",
};

const page = async () => {
  const t = await getTranslations("cartAndPayment");
  return (
    <Container>
      <Heading
        as="h1"
        font={"48px"}
        fontWeight={"extrabold"}
        mb={{ base: "24px", md: "36px", lg: "40px", "2xl": "60px" }}
      >
        {t("checkout")}
      </Heading>
      <HStack
        gap={{ base: "22px", md: "22px", lg: "30px", "2xl": "48px" }}
        align={"start"}
        justify={"center"}
        flexWrap={"wrap"}
      >
        <CheckoutForm />
        <CheckoutSummary />
      </HStack>
    </Container>
  );
};

export default page;
