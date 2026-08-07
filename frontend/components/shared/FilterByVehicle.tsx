/* eslint-disable react-hooks/exhaustive-deps */
"use client";
import { SearchIcon } from "@/components/Icons";
import generateYearsSlots from "@/helpers/generateYearsSlots";
import { Link } from "@/i18n/navigation";
import { useProductFilterContext } from "@/providers/ProductFilterProvider";
import { IMake, IVehicle, IVehicleModel, IYearVehicleModel } from "@/types";
import axiosInstance from "@/utils/axiosInstance";
import { Button, HStack, Icon, Skeleton, Text } from "@chakra-ui/react";
import { useMutation, useQuery } from "@tanstack/react-query";
import { useTranslations } from "next-intl";
import { useEffect } from "react";
import { IoCarSportOutline } from "react-icons/io5";
import DropSelectList from "../ui/DropSelectList";

const FoundByVehicle = ({ showButton }: { showButton?: boolean }) => {
  const t = useTranslations("home");

  const { filters, applyFilter, getFiltersString, setFilter } =
    useProductFilterContext();

  // make
  const { data: makeData, isLoading: makeIsLoading } = useQuery({
    queryKey: ["makeList"],
    queryFn: async () => {
      const { data } = await axiosInstance<{ data: IMake[] }>("vehicles/makes");

      return data.data;
    },
  });

  // model
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

  // year
  const {
    data: yearData,
    isPending: yearIsLoading,
    mutate: yearMutate,
  } = useMutation({
    mutationKey: ["yearList"],
    mutationFn: async (id: string) => {
      const { data } = await axiosInstance<{ data: IYearVehicleModel[] }>(
        `vehicles/models/${id}/years`,
      );

      return data.data;
    },
  });

  // vehicle
  const {
    data: vehicleData,
    isPending: vehicleIsLoading,
    mutate: vehicleMutate,
    reset,
  } = useMutation({
    mutationKey: ["vehicle"],
    mutationFn: async ({
      make_id,
      model_id,
      year,
    }: {
      make_id: string;
      model_id: string;
      year: string;
    }) => {
      const { data } = await axiosInstance<{ data: IVehicle[] }>("vehicles", {
        params: {
          make_id,
          model_id,
          year,
        },
      });

      return data.data[0];
    },

    onSuccess: (res) => {
      const currentVehicleId = filters.find(
        (f) => f.filterBy === "vehicle_id",
      )?.query;

      if (currentVehicleId !== String(res.id)) {
        setFilter({
          filterBy: "vehicle_id",
          query: String(res.id),
          targetEndpoint: "products",
        });
      }
    },
  });

  const selectedMakeId = filters
    .find((f) => f.filterBy === "make")
    ?.query?.trim();

  const selectedModelId = filters
    .find((f) => f.filterBy === "model")
    ?.query?.trim();

  const selectedYear = filters
    .find((f) => f.filterBy === "year")
    ?.query?.trim();

  /**
   * Load models when make changes
   */
  useEffect(() => {
    if (!selectedMakeId) return;

    const currentMakeId = modelData?.[0]?.vehicle_make_id?.toString();

    if (currentMakeId && selectedMakeId !== currentMakeId) {
      setFilter({
        filterBy: "model",
        query: "",
        targetEndpoint: "v",
      });

      setFilter({
        filterBy: "year",
        query: "",
        targetEndpoint: "v",
      });
      reset();
    }

    modelMutate(selectedMakeId);
  }, [selectedMakeId, modelMutate]);

  /**
   * Load years when model changes
   */
  useEffect(() => {
    if (selectedModelId) {
      yearMutate(selectedModelId);
    }
  }, [selectedModelId, yearMutate]);

  /**
   * Load vehicle when all filters are selected
   */
  useEffect(() => {
    if (!selectedMakeId || !selectedModelId || !selectedYear) {
      reset();
      return;
    }

    vehicleMutate({
      make_id: selectedMakeId,
      model_id: selectedModelId,
      year: selectedYear,
    });
  }, [selectedMakeId, selectedModelId, selectedYear, vehicleMutate]);

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
      {vehicleIsLoading && <Skeleton w={"full"} h={"44px"} rounded="14px" />}
      {!!vehicleData && (
        <HStack
          p={{ base: "8px", lg: "10px" }}
          border="1px solid #B9F8CF"
          bg="#F0FDF4"
          rounded={"14px"}
          color={"#008236"}
          gap={"14px"}
          minW={"200px"}
          flex="1"
        >
          <Icon size={"md"}>
            <IoCarSportOutline />
          </Icon>
          <Text fontSize={"14px"}>
            {vehicleData?.model?.name} {vehicleData?.trim_name}{" "}
            {vehicleData?.engine}
          </Text>
        </HStack>
      )}
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

export default FoundByVehicle;

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
          targetEndpoint: "v",
        })
      }
    />
  );
};
