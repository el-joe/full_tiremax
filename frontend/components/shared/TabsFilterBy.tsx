"use client";
import useDir from "@/hooks/useDir";

import {
  Tabs,
  TabsContentProps,
  TabsListProps,
  TabsRootProps,
} from "@chakra-ui/react";
import { useTranslations } from "next-intl";
import { useSearchParams } from "next/navigation";
import { useState, type ReactNode } from "react";
import { useProductFilterContext } from "@/providers/ProductFilterProvider";
import {
  SEARCH_TAB_PARAM,
  SEARCH_TAB_QUERY,
  type TSearchTab,
} from "@/helpers/searchTabs";
import FoundByVehicle from "./FilterByVehicle";
import FoundBySize from "./FilterBySize";

type props = {
  showButton?: boolean;
  triggerListProps?: TabsListProps;
  tabsContentProps?: Omit<TabsContentProps, "value">;
  tabsRootProps?: TabsRootProps;
  // rendered under the size fields (only visible on the "search by size" tab)
  sizeTabExtra?: ReactNode;
};

// filters that only make sense for one of the two search modes
const VEHICLE_ONLY = [
  { targetEndpoint: "products", filterBy: "vehicle_id" },
  { targetEndpoint: "v", filterBy: "make" },
  { targetEndpoint: "v", filterBy: "model" },
  { targetEndpoint: "v", filterBy: "year" },
];
const SIZE_ONLY = [
  { targetEndpoint: "products", filterBy: "width" },
  { targetEndpoint: "products", filterBy: "aspect_ratio" },
  { targetEndpoint: "products", filterBy: "rim_diameter" },
  { targetEndpoint: "products", filterBy: "brand_id" },
];

const TabsFilterBy = ({
  showButton,
  triggerListProps,
  tabsContentProps,
  tabsRootProps,
  sizeTabExtra,
}: props) => {
  const t = useTranslations("home");
  const dir = useDir();
  const searchParams = useSearchParams();
  const { setFilter } = useProductFilterContext();
  const [tab, setTab] = useState<TSearchTab>(
    searchParams.get(SEARCH_TAB_PARAM) === SEARCH_TAB_QUERY.foundBySize
      ? "foundBySize"
      : "foundByVehicle",
  );
  return (
    <Tabs.Root
      value={tab}
      onValueChange={({ value }) => {
        const next = value as TSearchTab;
        if (next === tab) return;
        setTab(next);
        // drop the other mode's selections so hidden filters never apply silently
        (next === "foundBySize" ? VEHICLE_ONLY : SIZE_ONLY).forEach((f) =>
          setFilter({ ...f, query: "" }),
        );
      }}
      maxW={"1214px"}
      mx={"auto"}
      bg={"bg"}
      rounded={"24px"}
      overflow={"hidden"}
      {...tabsRootProps}
    >
      <Tabs.List
        dir={dir}
        bg="primary"
        borderTop={"3px solid {colors.primary}"}
        {...triggerListProps}
      >
        <Tabs.Trigger
          value="foundByVehicle"
          bg="white"
          flex="1"
          justifyContent={"center"}
          h={"auto"}
          py={{ base: "2px", md: "8px", xl: "12px" }}
          _selected={{
            bg: "primary",
            color: "white",
            "--indicator-color": "transparent",
          }}
        >
          {t("searchByVehicle")}
        </Tabs.Trigger>
        <Tabs.Trigger
          value="foundBySize"
          bg="white"
          flex="1"
          justifyContent={"center"}
          h={"auto"}
          py={{ base: "2px", md: "8px", xl: "12px" }}
          _selected={{
            bg: "primary",
            color: "white",
            "--indicator-color": "transparent",
          }}
        >
          {t("searchBySize")}
        </Tabs.Trigger>
      </Tabs.List>
      <Tabs.Content
        value="foundByVehicle"
        p={{ base: "8px", md: "19px", xl: "31px" }}
        dir={dir}
        {...tabsContentProps}
      >
        <FoundByVehicle showButton={showButton} />
      </Tabs.Content>
      <Tabs.Content
        value="foundBySize"
        p={{ base: "8px", md: "19px", xl: "31px" }}
        dir={dir}
        {...tabsContentProps}
      >
        <FoundBySize showButton={showButton} />
        {sizeTabExtra}
      </Tabs.Content>
    </Tabs.Root>
  );
};

export default TabsFilterBy;
