"use client";
import React, { useState } from "react";
import Input from "../ui/Input";
import { IoSearch } from "react-icons/io5";
import { useTranslations } from "next-intl";
import { Box, Icon, VStack } from "@chakra-ui/react";
import { useProductFilterContext } from "@/providers/ProductFilterProvider";
import { useRouter } from "@/i18n/navigation";
import { IoClose } from "react-icons/io5";

export default function HeaderSearch() {
  const t = useTranslations("header");
  const [searchHistory, setSearchHistory] = useState<string[]>(() => {
    const storedSearchH = localStorage.getItem("searchHistory");
    if (!!storedSearchH) {
      return JSON.parse(storedSearchH);
    }
    return [];
  });
  const [isSearchFocused, setIsSearchFocused] = useState(false);
  const { getFiltersString } = useProductFilterContext();
  const router = useRouter();
  //   handle search
  const handleSearch = (q: string) => {
    if (!!q.trim()) {
      console.log("q", q);
      const updatedHistory = [...new Set([q, ...searchHistory])];
      setSearchHistory(updatedHistory);
      localStorage.setItem("searchHistory", JSON.stringify(updatedHistory));
    }
    setIsSearchFocused(false);
    router.push(
      `/store?${getFiltersString({ filterBy: "search", query: q, targetEndpoint: "products" })}`,
    );
  };
  //   remove from search history
  const removeFromSearchHistory = (query: string) => {
    const updatedHistory = searchHistory.filter((item) => item !== query);

    setSearchHistory(updatedHistory);
    localStorage.setItem("searchHistory", JSON.stringify(updatedHistory));
  };
  return (
    <Box
      position={"relative"}
      flex={1}
      onMouseDown={() => setIsSearchFocused(true)}
      onBlur={() => setIsSearchFocused(false)}
    >
      <Input
        startElement={
          <Icon size={"md"}>
            <IoSearch />
          </Icon>
        }
        onKeyDown={(e: React.KeyboardEvent<HTMLInputElement>) => {
          if (e.code === "Enter") {
            handleSearch(e.currentTarget.value);
          }
        }}
        placeholder={t("search")}
        bg={"white"}
        type="search"
        autoComplete="off"
        rounded={"20px"}
        name="search"
        rootProps={{ flex: 1 }}
        minW={"120px"}
      />
      <VStack
        py={"8px"}
        bg="white"
        shadow={"lg"}
        position={"absolute"}
        top={"calc(100% + 10px)"}
        insetX={0}
        maxH={"500px"}
        zIndex={5}
        rounded={"20px"}
        align={"stretch"}
        overflow={"auto"}
        display={isSearchFocused ? "flex" : "none"}
      >
        {searchHistory.map((item) => (
          <Box
            key={item}
            p="12px 18px"
            _hover={{ bg: "bg.muted" }}
            cursor="pointer"
            display="flex"
            alignItems="center"
            justifyContent="space-between"
            onMouseDown={() => {
              handleSearch(item);
            }}
          >
            <Box flex={1}>{item}</Box>

            <Icon
              size="sm"
              cursor="pointer"
              onMouseDown={(e) => {
                e.stopPropagation();
                removeFromSearchHistory(item);
              }}
            >
              <IoClose />
            </Icon>
          </Box>
        ))}
      </VStack>
    </Box>
  );
}
