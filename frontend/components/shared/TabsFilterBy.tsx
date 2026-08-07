"use client";
import useDir from "@/hooks/useDir";

import {
  Tabs,
  TabsContentProps,
  TabsListProps,
  TabsRootProps,
} from "@chakra-ui/react";
import { useTranslations } from "next-intl";
import FoundByVehicle from "./FilterByVehicle";
import FoundBySize from "./FilterBySize";

type props = {
  showButton?: boolean;
  triggerListProps?: TabsListProps;
  tabsContentProps?: Omit<TabsContentProps, "value">;
  tabsRootProps?: TabsRootProps;
};

const TabsFilterBy = ({
  showButton,
  triggerListProps,
  tabsContentProps,
  tabsRootProps,
}: props) => {
  const t = useTranslations("home");
  const dir = useDir();
  return (
    <Tabs.Root
      defaultValue="foundByVehicle"
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
      </Tabs.Content>
    </Tabs.Root>
  );
};

export default TabsFilterBy;
