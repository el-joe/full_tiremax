"use client";
import { useProductFilterContext } from "@/providers/ProductFilterProvider";
import { Button, HStack } from "@chakra-ui/react";
import { useTranslations } from "next-intl";
import React, { useState } from "react";

const ProductTabsHeader = () => {
  const t = useTranslations("store");
  const { filters, applyFilter } = useProductFilterContext();
  const typeFilter = filters.find((f) => f.filterBy === "type");
  const [activeType, setActiveType] = useState<string>(typeFilter?.query ?? "");
  return (
    <HStack
      borderBottom={"1px solid #D5C4AB33"}
      ps={{ base: "39px", md: "52px", xl: "120px" }}
    >
      <Button
        onClick={() => {
          setActiveType("");
          applyFilter({
            targetEndpoint: "products",
            filterBy: "type",
            query: "",
          });
        }}
        variant={"ghost"}
        color={"black"}
        rounded={"0"}
        borderBottom={"3px solid transparent"}
        borderBottomColor={activeType === "" ? "primary" : ""}
        fontSize={"18px"}
        fontWeight={"semibold"}
      >
        {t("all")}
      </Button>
      <Button
        onClick={() => {
          setActiveType("tire");
          applyFilter({
            targetEndpoint: "products",
            filterBy: "type",
            query: "tire",
          });
        }}
        variant={"ghost"}
        color={"black"}
        rounded={"0"}
        borderBottom={"3px solid transparent"}
        borderBottomColor={activeType === "tire" ? "primary" : ""}
        fontSize={"18px"}
        fontWeight={"semibold"}
      >
        {t("tires")}
      </Button>
      <Button
        onClick={() => {
          setActiveType("battery");
          applyFilter({
            targetEndpoint: "products",
            filterBy: "type",
            query: "battery",
          });
        }}
        variant={"ghost"}
        color={"black"}
        rounded={"0"}
        borderBottom={"3px solid transparent"}
        borderBottomColor={activeType === "battery" ? "primary" : ""}
        fontSize={"18px"}
        fontWeight={"semibold"}
      >
        {t("batteries")}
      </Button>
    </HStack>
  );
};

export default ProductTabsHeader;
