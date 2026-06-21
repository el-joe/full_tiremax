import { HStack, Skeleton } from "@chakra-ui/react";
import React from "react";

export default function ServiceCardsSkeleton() {
  return (
    <HStack flexWrap={"wrap"} gap={"22px"}>
      {[...Array.from({ length: 4 })].map((_, i) => (
        <Skeleton w="300px" key={i} h={"340px"} rounded={"16px"} />
      ))}
    </HStack>
  );
}
