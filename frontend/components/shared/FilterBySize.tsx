"use client";
import { SearchIcon } from "@/components/Icons";
import DropSelectList from "@/components/ui/DropSelectList";
import { useProductFilterContext } from "@/providers/ProductFilterProvider";
import { ITyreSize } from "@/types";
import axiosInstance from "@/utils/axiosInstance";

import { Button, HStack } from "@chakra-ui/react";
import { useQuery } from "@tanstack/react-query";
import { useTranslations } from "next-intl";

const FoundBySize = ({ showButton }: { showButton?: boolean }) => {
  const t = useTranslations("home");
  const { applyFilter } = useProductFilterContext();

  // make
  const { data: sizesData, isLoading: sizesIsLoading } = useQuery({
    queryKey: ["tyreSizes"],
    queryFn: async () => {
      const { data } = await axiosInstance<{ data: ITyreSize[] }>(
        "fitments/sizes",
      );

      return data.data;
    },
  });

  return (
    <HStack
      gapX={{ base: "4px", md: "12px", xl: "24px" }}
      alignItems="end"
      flexWrap={"wrap"}
    >
      <DropFilterList
        list={[...new Set(sizesData?.map((item) => item.width))].map(
          (size) => ({ label: String(size), value: String(size) }),
        )}
        label={t("width")}
        isLoading={sizesIsLoading}
        placeholder={t("selectWidth")}
        name="width"
      />
      <DropFilterList
        list={[...new Set(sizesData?.map((item) => item.aspect_ratio))].map(
          (size) => ({ label: String(size), value: String(size) }),
        )}
        label={t("aspectRatio")}
        placeholder={t("selectAspectRatio")}
        isLoading={sizesIsLoading}
        name="aspect_ratio"
      />
      <DropFilterList
        list={[...new Set(sizesData?.map((item) => item.rim_diameter))].map(
          (size) => ({ label: String(size), value: String(size) }),
        )}
        label={t("rimDiameter")}
        placeholder={t("selectRimDiameter")}
        isLoading={sizesIsLoading}
        name="rim_diameter"
      />
      {showButton && (
        <Button
          rounded={"12px"}
          type="submit"
          fontSize={{ base: "12px" }}
          w={{ base: "full", md: "auto" }}
          onClick={() => applyFilter()}
        >
          {t("findYourTireNow")} <SearchIcon />
        </Button>
      )}
    </HStack>
  );
};

export default FoundBySize;

type TDropFilterProps = {
  label: string;
  placeholder: string;
  name: string;
  list: { label: string; value: string; group?: string }[];
  isLoading?: boolean;
  grouped?: boolean;
};

const DropFilterList = ({
  label,
  placeholder,
  name,
  list,
  isLoading,
  grouped,
}: TDropFilterProps) => {
  const { setFilter, filters } = useProductFilterContext();
  const v = [filters.find((f) => f.filterBy === name)?.query as string];
  // const v = !!filters.find(f => f.filterBy === name)?.query ? [filters.find(f => f.filterBy === name)?.query as string] : undefined
  return (
    <DropSelectList
      isLoading={isLoading}
      list={list}
      grouped={grouped}
      label={label}
      placeholder={placeholder}
      name={name}
      containerProps={{ flex: 1 }}
      minW={"200px"}
      value={v}
      triggerProps={{ rounded: "12px" }}
      onValueChange={(d) =>
        setFilter({
          filterBy: name,
          query: d.value[0],
          targetEndpoint: "products",
        })
      }
    />
  );
};
