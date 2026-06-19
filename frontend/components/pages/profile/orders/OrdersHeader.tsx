"use client";
import useApiFilter from "@/hooks/useApiFilter";
import { Box, Button, Heading, HStack, Text } from "@chakra-ui/react";
import { useTranslations } from "next-intl";

const statusFilter = [
  {
    id: 1,
    label: "processing",
    value: "pending",
  },
  {
    id: 2,
    label: "onTheWay",
    value: "on_the_way",
  },
  {
    id: 3,
    label: "delivered",
    value: "delivered",
  },
];

export default function OrdersHeader({ ordersCount }: { ordersCount: number }) {
  const t = useTranslations("profile");
  const { applyFilter, filters } = useApiFilter();
  return (
    <HStack
      justify={"space-between"}
      p="24px"
      border={"1px solid #E5E7EB"}
      rounded={"16px"}
      shadow={"0 1px 2px -1px #0000001A, 0 1px 3px 0px #0000001A"}
    >
      <Box>
        <Heading pb={"8px"} fontSize={"30px"} fontWeight={"bold"}>
          {t("orders")}
        </Heading>
        <Text color={"gray-2"}>
          {t("youHave")} {ordersCount} {t("order")}
        </Text>
      </Box>
      <HStack gap={"8px"}>
        <Button
          bg={
            !filters.find((e) => e.filterBy === "status") ? "primary" : "gray-4"
          }
          color={
            !filters.find((e) => e.filterBy === "status") ? "black" : "gray-2"
          }
          boxShadow={
            !filters.find((e) => e.filterBy === "status")
              ? "0 2px 4px -2px #0000001A, 0 4px 6px -1px #0000001A"
              : "unset"
          }
          onClick={() =>
            applyFilter({
              filterBy: "status",
              query: "",
              targetEndpoint: "orders",
            })
          }
        >
          {t("all")}
        </Button>
        {statusFilter.map((f) => (
          <Button
            key={f.id}
            bg={filters.find((e) => e.query === f.value) ? "primary" : "gray-4"}
            color={
              filters.find((e) => e.query === f.value) ? "black" : "gray-2"
            }
            boxShadow={
              filters.find((e) => e.query === f.value)
                ? "0 2px 4px -2px #0000001A, 0 4px 6px -1px #0000001A"
                : "unset"
            }
            onClick={() =>
              applyFilter({
                filterBy: "status",
                query: f.value,
                targetEndpoint: "orders",
              })
            }
          >
            {t(f.label)}
          </Button>
        ))}
      </HStack>
    </HStack>
  );
}
