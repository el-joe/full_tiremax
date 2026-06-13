import Filters from "@/components/pages/productsView/Filters";
import ProductTabsHeader from "@/components/pages/productsView/ProductTabsHeader";
import Search from "@/components/pages/productsView/Search";
import SmallScreenFilters from "@/components/pages/productsView/SmallScreenFilters";
import Container from "@/components/ui/Container";
import { ProductFilterProvider } from "@/providers/ProductFilterProvider";
import { Box, Heading, HStack, Text, VStack } from "@chakra-ui/react";
import { getTranslations } from "next-intl/server";
import { headers } from "next/headers";
import React from "react";

type Props = {
  children: React.ReactNode;
};

const layout = async ({ children }: Props) => {
  const pathname = (await headers()).get("x-pathname")?.split("/");
  const currentPageTitle = pathname?.[2] as string;
  const t = await getTranslations("store");

  return (
    <ProductFilterProvider>
      <Container overflow={"visible"}>
        <Heading
          textAlign={"center"}
          fontSize={{ base: "22px", md: "28px", lg: "32px", "2xl": "38px" }}
          fontWeight={"extrabold"}
        >
          {t(currentPageTitle)}
        </Heading>
        <Text
          textAlign={"center"}
          mt={{ base: "12px", lg: "16px" }}
          mb={{ base: "26px", md: "40px", xl: "54px", "2xl": "70px" }}
          color={"gray"}
          fontSize={{ base: "12px", md: "14px", lg: "16px", "2xl": "18px" }}
        >
          {t("productCatalogDescription")}
        </Text>
        <HStack gap={"32px"} align="start">
          <Box
            display={{ md: "none" }}
            position={"fixed"}
            right={"0"}
            top={"40%"}
            zIndex={"10"}
          >
            <SmallScreenFilters />
          </Box>
          <Box display={{ base: "none", md: "block" }}>
            <Filters />
          </Box>
          <VStack
            flex={1}
            align={"stretch"}
            gap={{ base: "22px", md: "34px", xl: "48px" }}
          >
            <Search />
            <ProductTabsHeader />
            {children}
          </VStack>
        </HStack>
      </Container>
    </ProductFilterProvider>
  );
};

export default layout;
