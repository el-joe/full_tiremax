"use client";
import {
  Box,
  Button,
  Center,
  Heading,
  HStack,
  Spinner,
  Text,
  VStack,
} from "@chakra-ui/react";
import { useTranslations } from "next-intl";
// import React, { useState } from 'react'
import TabsFilterBy from "../../shared/TabsFilterBy";
import RangeSlider from "@/components/ui/RangeSlider";
import { SearchIcon } from "@/components/Icons";
import { useProductFilterContext } from "@/providers/ProductFilterProvider";
import { useQuery } from "@tanstack/react-query";
import axiosInstance from "@/utils/axiosInstance";
import { IBrand } from "@/types";
const maxRange = 200000;
const Filters = ({ setDialog }: { setDialog?: (state: boolean) => void }) => {
  const t = useTranslations("store");
  const { applyFilter, removeAllFilters, filters, setFilter } =
    useProductFilterContext();
  const minRangeVal = +(
    filters.find((f) => f.filterBy === "min_price")?.query || 0
  );
  const maxRangeVal = +(
    filters.find((f) => f.filterBy === "max_price")?.query || maxRange
  );
  const { data: brandData, isLoading: brandIsLoading } = useQuery({
    queryKey: ["makeList"],
    queryFn: async () => {
      const { data } = await axiosInstance<{ data: IBrand[] }>(
        "vehicles/makes",
      );
      return data.data;
    },
  });
  return (
    <VStack
      gap={"32px"}
      w={{
        base: "full",
        md: "200px",
        lg: "240px",
        xl: "270px",
        "2xl": "320px",
      }}
    >
      <Box w={"full"}>
        <HStack
          justify={"space-between"}
          alignItems={"center"}
          pe={{ base: "30px", md: "0" }}
        >
          <Heading as="h3" fontSize={"24px"} fontWeight={"semibold"}>
            {t("filters")}
          </Heading>
          <Button
            variant={"ghost"}
            fontSize={"12px"}
            fontWeight={"semibold"}
            color={"black"}
            _hover={{ color: "white" }}
            onClick={() => {
              removeAllFilters([
                { targetEndpoint: "products", filterName: "type" },
                { targetEndpoint: "products", filterName: "search" },
                { targetEndpoint: "products", filterName: "badge" },
              ]);
              setDialog?.(false);
            }}
          >
            {t("clearFilters")}
          </Button>
        </HStack>
        <Text fontSize={"10px"} lineHeight={"28px"} color={"gray-3"}>
          {t("filtersDescription")}
        </Text>
      </Box>
      <TabsFilterBy
        triggerListProps={{
          rounded: "16px",
          overflow: "hidden",
          borderBottomWidth: "0",
          borderTopWidth: "2px",
        }}
        tabsRootProps={{ rounded: "0", minH: "300px" }}
        tabsContentProps={{ p: "0", pt: "32px" }}
      />
      {/* price range filter */}
      <RangeSlider
        step={0.5}
        minStepsBetweenThumbs={8}
        label={t("priceRange")}
        maxVal={maxRange}
        defaultValue={[minRangeVal, maxRangeVal]}
        onRangeChangeEnd={(values) => {
          setFilter({
            targetEndpoint: "products",
            filterBy: "min_price",
            query: values[0].toString(),
          });
          setFilter({
            targetEndpoint: "products",
            filterBy: "max_price",
            query: values[1].toString(),
          });
        }}
      />
      <Box w="full">
        <Heading fontSize={"14px"} fontWeight={"semibold"} mb={"16px"}>
          {t("brand")}
        </Heading>
        {brandIsLoading ? (
          <Center>
            {" "}
            <Spinner size={"lg"} />
          </Center>
        ) : (
          <HStack flexWrap={"wrap"} gap={"8px"}>
            {brandData?.map((brand) => (
              <Button
                key={brand.id}
                w="calc(100% / 2 - 8px)"
                variant={
                  filters.find((f) => f.filterBy === "brand_id")?.query ===
                  brand.id.toString()
                    ? "solid"
                    : "outline"
                }
                onClick={() =>
                  setFilter({
                    targetEndpoint: "products",
                    filterBy: "brand_id",
                    query: brand.id.toString(),
                  })
                }
                color={"black"}
                _hover={{ color: "white" }}
              >
                {brand.name}
              </Button>
            ))}
          </HStack>
        )}
      </Box>
      <Button
        w="full"
        rounded={"16px"}
        fontSize={"18px"}
        fontWeight={"bold"}
        p="16px"
        onClick={() => {
          applyFilter();
          setDialog?.(false);
        }}
      >
        <SearchIcon />
        {t("applyFilters")}
      </Button>
    </VStack>
  );
};

export default Filters;
