import { HStack, Skeleton } from "@chakra-ui/react";
import React from "react";

export default function ProductCardSkeleton() {
  return (
    <HStack flexWrap={"wrap"} gap={"18px"}>
      {[...Array.from({ length: 6 })].map((_, i) => (
        <Skeleton w="300px" key={i} h={"420px"} rounded={"16px"} />
      ))}
    </HStack>
  );
}
