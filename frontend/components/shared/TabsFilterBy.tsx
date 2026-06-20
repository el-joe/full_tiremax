"use client";
import { SearchIcon } from "@/components/Icons";
import DropSelectList from "@/components/ui/DropSelectList";
import generateYearsSlots from "@/helpers/generateYearsSlots";
import useDir from "@/hooks/useDir";
import { Link } from "@/i18n/navigation";
import { useProductFilterContext } from "@/providers/ProductFilterProvider";
import { IMake, IVehicleModel, IYearVehicleModel } from "@/types";
import axiosInstance from "@/utils/axiosInstance";
import {
  Button,
  HStack,
  Tabs,
  TabsContentProps,
  TabsListProps,
  TabsRootProps,
} from "@chakra-ui/react";
import { useMutation, useQuery } from "@tanstack/react-query";
import { useTranslations } from "next-intl";
import { useEffect } from "react";

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

const FoundByVehicle = ({ showButton }: { showButton?: boolean }) => {
  const t = useTranslations("home");
  const { filters, applyFilter, getFiltersString } = useProductFilterContext();
  const { data: makeData, isLoading: makeIsLoading } = useQuery({
    queryKey: ["makeList"],
    queryFn: async () => {
      const { data } = await axiosInstance<{ data: IMake[] }>("vehicles/makes");
      return data.data;
    },
  });
  const {
    data: modelData,
    isPending: modelIsLoading,
    mutate: modelMutate,
  } = useMutation({
    mutationKey: ["modelList"],
    mutationFn: async (id: string) => {
      const { data } = await axiosInstance<{ data: IVehicleModel[] }>(
        `vehicles/makes/${id}/models`,
      );
      return data.data;
    },
  });
  const {
    data: yearData,
    isPending: yearIsLoading,
    mutate: yearMutate,
  } = useMutation({
    mutationKey: ["modelList"],
    mutationFn: async (id: string) => {
      const { data } = await axiosInstance<{ data: IYearVehicleModel[] }>(
        `vehicles/models/${id}/years`,
      );
      return data.data;
    },
  });

  useEffect(() => {
    const selectMakeId = filters
      .find((f) => f.filterBy === "make")
      ?.query?.trim();
    if (
      !!selectMakeId &&
      selectMakeId !== modelData?.[0].vehicle_make_id.toString()
    ) {
      modelMutate(selectMakeId as string);
    }
    if (!!filters.find((f) => f.filterBy === "model")?.query.trim()) {
      yearMutate(
        filters.find((f) => f.filterBy === "model")?.query.trim() as string,
      );
    }
  }, [filters, modelData, modelMutate, yearMutate]);

  return (
    <HStack
      gapX={{ base: "4px", md: "12px", xl: "24px" }}
      alignItems="end"
      flexWrap={"wrap"}
    >
      <DropFilterList
        list={
          makeData?.map((m) => ({ label: m.name, value: m.id.toString() })) ??
          []
        }
        isLoading={makeIsLoading}
        name="make"
        label={t("make")}
        placeholder={t("selectMake")}
      />
      <DropFilterList
        list={
          modelData?.map((m) => ({ label: m.name, value: m.id.toString() })) ??
          []
        }
        isLoading={modelIsLoading}
        label={t("model")}
        placeholder={t("selectModel")}
        name="model"
      />
      <DropFilterList
        list={
          yearData
            ?.map((e) =>
              generateYearsSlots(e?.year_from, e?.year_to).map((m) => ({
                label: String(m),
                value: String(m),
                group: e.trim_name + e.engine,
              })),
            )
            .flat() ?? []
        }
        grouped
        isLoading={yearIsLoading}
        label={t("year")}
        placeholder={t("selectYear")}
        name="year"
      />
      {showButton && (
        <Link href={`/store?${getFiltersString()}`}>
          <Button
            rounded={"12px"}
            minW="200px"
            flex="1"
            type="submit"
            fontSize={{ base: "12px" }}
            w={{ base: "full", md: "auto" }}
            onClick={() => applyFilter()}
          >
            {t("findYourTireNow")} <SearchIcon />
          </Button>
        </Link>
      )}
    </HStack>
  );
};
const FoundBySize = ({ showButton }: { showButton?: boolean }) => {
  const t = useTranslations("home");
  const { applyFilter } = useProductFilterContext();

  return (
    <HStack
      gapX={{ base: "4px", md: "12px", xl: "24px" }}
      alignItems="end"
      flexWrap={"wrap"}
    >
      <DropFilterList
        list={[{ label: "option1", value: "option1" }]}
        label={t("height")}
        placeholder={t("selectHeight")}
        name="height"
      />
      <DropFilterList
        list={[{ label: "option1", value: "option1" }]}
        label={t("width")}
        placeholder={t("selectWidth")}
        name="width"
      />
      <DropFilterList
        list={[{ label: "option1", value: "option1" }]}
        label={t("diameter")}
        placeholder={t("selectDiameter")}
        name="diameter"
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
      name="model"
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
