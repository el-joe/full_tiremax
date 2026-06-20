"use client";
import ProductCard from "@/components/shared/ProductCard";
import { Link } from "@/i18n/navigation";
import { useFavContext } from "@/providers/FavProvider";
import { Box, Center, Heading, HStack, Text } from "@chakra-ui/react";
import { useTranslations } from "next-intl";
import React from "react";

export default function FavProductSection() {
  const t = useTranslations("profile");
  const { favorites } = useFavContext();
  return (
    <Box>
      <HStack justify={"space-between"}>
        <Heading fontSize={"24px"} fontWeight={"black"} mb={"24px"}>
          {t("favorites")}
        </Heading>
        <Link href={"/favorites"}>
          <Text fontWeight={"bold"} color="gray-2">
            {t("viewAll")}
          </Text>
        </Link>
      </HStack>
      <HStack gap={"12px"} align={"stretch"} flexWrap={"wrap"}>
        {!favorites.length && (
          <Center w="full">You don&apos;t have favorite protects yet</Center>
        )}
        {favorites.slice(0, 3).map((e) => (
          <ProductCard key={e.id} product={e} />
        ))}
      </HStack>
    </Box>
  );
}
