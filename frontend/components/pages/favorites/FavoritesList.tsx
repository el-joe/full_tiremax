"use client";
import ProductCard from "@/components/shared/ProductCard";
import ProductCardSkeleton from "@/components/skeletons/ProductCardSkeleton";
import { useFavContext } from "@/providers/FavProvider";
import { HStack } from "@chakra-ui/react";
import React from "react";

export default function FavList() {
  const { favorites, favIsLoading } = useFavContext();
  if (favIsLoading) {
    return <ProductCardSkeleton />;
  }
  return (
    <HStack
      flexWrap={"wrap"}
      gap={{ base: "14px", md: "14px", xl: "22px", "2xl": "32px" }}
      alignItems={"stretch"}
    >
      {favorites.map((product) => (
        <ProductCard key={product.id} product={{ ...product }} />
      ))}
    </HStack>
  );
}
