"use client"
import { usePathname, useRouter } from "@/i18n/navigation";
import { ButtonGroup, IconButton } from "@chakra-ui/react";
import { useSearchParams } from "next/navigation";
import React from "react";
import { Pagination as ChakraPagination } from "@chakra-ui/react";
import { LeftArrowIcon } from "../Icons";
import { useLocale } from "next-intl";

const PREFIX = process.env.NEXT_PUBLIC_PAGINATION_PREFIX ?? "paginate"

type Props = {
  currentPage: number;
  itemsCount: number;
  pageSize: number;
  prefixName?: string;
  onPageChange?: (page: number) => void;
};

const Pagination = ({
  currentPage,
  itemsCount,
  pageSize,
  prefixName = "",
  onPageChange,
}: Props) => {
  const locale = useLocale()
  const router = useRouter();
  const pathName = usePathname();
  const params = useSearchParams();
  const current = new URLSearchParams(Array.from(params.entries()));
  const dir = locale === "ar" ? "rtl" : "ltr"


  const handlePageChange = (page: number) => {
    current.set(`${PREFIX}_page`, String(page));
    router.push(`${pathName}?${current.toString()}`);
    onPageChange?.(page);
  };

  return (
    <>
      <ChakraPagination.Root
        count={itemsCount}
        pageSize={pageSize}
        defaultPage={currentPage}
        onPageChange={(e) => handlePageChange(e.page)}
        dir={dir}
      >
        <ButtonGroup size="sm">
          <ChakraPagination.PrevTrigger asChild>
            <IconButton w={"40px"} h="40px" rounded="8px" bg="#F3F3F3" fontWeight={"semibold"} color="black" >
              <LeftArrowIcon rotate={dir === "rtl" ? '180deg' : ""} />
            </IconButton>
          </ChakraPagination.PrevTrigger>

          <ChakraPagination.Items
            render={(page) => (
              <IconButton w={"40px"} h="40px" rounded="8px" bg="#F3F3F3" fontWeight={"semibold"} _selected={{ bg: "primary" }} color="black" >
                {page.value}
              </IconButton>
            )}
          />

          <ChakraPagination.NextTrigger asChild>
            <IconButton w={"40px"} h="40px" rounded="8px" bg="#F3F3F3" fontWeight={"semibold"} color="black">
              <LeftArrowIcon rotate={dir === "rtl" ? "" : '180deg'} />
            </IconButton>
          </ChakraPagination.NextTrigger>
        </ButtonGroup>
      </ChakraPagination.Root>
    </>
  );
};

export default Pagination;
