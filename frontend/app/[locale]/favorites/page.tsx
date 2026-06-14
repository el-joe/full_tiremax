import FavList from "@/components/pages/favorites/FavoritesList";
import Container from "@/components/ui/Container";
import { Heading, Text } from "@chakra-ui/react";
import { getTranslations } from "next-intl/server";
import React from "react";

export default async function page() {
  const t = await getTranslations("favorites");
  return (
    <Container textAlign={"center"}>
      {/* page header */}
      <Heading fontSize={"36px"} fontWeight={"bold"}>
        {t("favorites")}
      </Heading>
      <Text fontSize={"14px"} color={"#6B7280"} mt={"16px"} mb={"48px"}>
        {t("savedProductsDescription")}
      </Text>
      <FavList />
    </Container>
  );
}
