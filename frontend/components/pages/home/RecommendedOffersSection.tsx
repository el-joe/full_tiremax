import { ChevronLeftIcon } from "@/components/Icons";
import ProductCard from "@/components/shared/ProductCard";
import Container from "@/components/ui/Container";
import { Link } from "@/i18n/navigation";
import { IProduct } from "@/types";
import { Heading, HStack } from "@chakra-ui/react";
import { getLocale, getTranslations } from "next-intl/server";
import React from "react";

type props = {
  data: IProduct[];
};

const RecommendedOffersSection = async ({ data }: props) => {
  const t = await getTranslations("home");
  const locale = await getLocale();
  return (
    <Container roundedBottom={"50px"}>
      <HStack
        justifyContent={"space-between"}
        mb={{ base: "19px", md: "34px", xl: "48px" }}
      >
        <Heading
          as={"h2"}
          fontWeight={"700"}
          fontSize={{ base: "18px", md: "36px" }}
        >
          {t("recommendedOffersForYou")}
        </Heading>
        <Link href={"/offers"}>
          <HStack>
            {t("showAll")}
            <ChevronLeftIcon
              rotate={locale === "en" ? "180deg" : "0deg"}
              size={"md"}
            />
          </HStack>
        </Link>
      </HStack>
      <HStack
        flexWrap={"wrap"}
        gap={{ base: "14px", md: "14px", xl: "22px", "2xl": "32px" }}
        alignItems={"stretch"}
      >
        {data.map((product) => (
          <ProductCard key={product.id} product={product} />
        ))}
      </HStack>
    </Container>
  );
};

export default RecommendedOffersSection;
