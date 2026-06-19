"use client";
import CurrencySymbol from "@/components/ui/CurrencySymbol";
import { Link } from "@/i18n/navigation";
import { IOrder } from "@/types";
import axiosInstance from "@/utils/axiosInstance";
import {
  Badge,
  Box,
  Button,
  Center,
  Heading,
  HStack,
  Spinner,
  Table,
  Text,
} from "@chakra-ui/react";
import { useQuery } from "@tanstack/react-query";
import { useTranslations } from "next-intl";

// const orders = [
//   {
//     id: 1,
//     reference: "ORD-20260604-0001",
//     type: "delivery",
//     status: "processing",
//     payment_method: "cod",
//     payment_status: "pending",
//     subtotal: 330000,
//     discount: 33000,
//     shipping_fee: 0,
//     installation_fee: 0,
//     total: 297000,
//     customer_name: "Ahmed Hassan",
//     customer_phone: "07701234567",
//     customer_email: "ahmed@example.com",
//     shipping_address: "Basra, Al-Ashar, Block 5",
//     tracking_number: null,
//     placed_at: "2026-06-04T10:15:00+03:00",
//   },
// ];

export default function RecentOrders() {
  const t = useTranslations("profile");
  const { data: recentOrdersList, isLoading } = useQuery({
    queryKey: ["orders"],
    queryFn: async () => {
      const { data } = await axiosInstance<{ data: IOrder[] }>(
        "orders?per_page=5",
      );
      return data.data;
    },
  });
  return (
    <Box
      p="24px"
      bg={"gray-4"}
      rounded={"16px"}
      borderStart={"4px solid {colors.primary}"}
    >
      <HStack justify={"space-between"}>
        <Heading fontSize={"24px"} fontWeight={"black"} mb={"24px"}>
          {t("recentOrders")}
        </Heading>
        <Link href={"/profile/orders"}>
          <Text fontWeight={"bold"} color="gray-2">
            {t("viewAll")}
          </Text>
        </Link>
      </HStack>
      <Table.Root size="sm">
        <Table.Header>
          <Table.Row bg={"gray-4"}>
            <Table.ColumnHeader fontSize={"12px"} color={"gray-2"}>
              {t("orderNumber")}
            </Table.ColumnHeader>
            <Table.ColumnHeader fontSize={"12px"} color={"gray-2"}>
              {t("date")}
            </Table.ColumnHeader>
            <Table.ColumnHeader fontSize={"12px"} color={"gray-2"}>
              {t("status")}
            </Table.ColumnHeader>
            <Table.ColumnHeader fontSize={"12px"} color={"gray-2"}>
              {t("total")}
            </Table.ColumnHeader>
            <Table.ColumnHeader
              fontSize={"12px"}
              color={"gray-2"}
            ></Table.ColumnHeader>
          </Table.Row>
        </Table.Header>
        <Table.Body rounded={"16px"} bg="white" overflow={"hidden"}>
          {isLoading ? (
            <Table.Row>
              <Table.Cell colSpan={5}>
                <Center>
                  <Spinner />
                </Center>
              </Table.Cell>
            </Table.Row>
          ) : !recentOrdersList?.length ? (
            <Table.Row>
              <Table.Cell colSpan={5}>
                <Center>No orders yet</Center>
              </Table.Cell>
            </Table.Row>
          ) : (
            recentOrdersList?.map((item) => (
              <Table.Row key={item.id}>
                <Table.Cell>
                  <Text fontWeight={"bold"} dir="ltr" w={"fit"}>
                    #{item.reference}
                  </Text>
                </Table.Cell>
                <Table.Cell>
                  <Text color={"#514532"}>
                    {new Date(item.placed_at).toDateString()}
                  </Text>
                </Table.Cell>
                <Table.Cell>
                  <Badge
                    colorPalette={"green"}
                    fontSize={"10px"}
                    rounded={"12px"}
                    p="4px 12px"
                  >
                    {item.status}
                  </Badge>
                </Table.Cell>
                <Table.Cell>
                  <Text fontWeight={"bold"}>
                    {item.total.toLocaleString()}
                    <CurrencySymbol />
                  </Text>
                </Table.Cell>
                <Table.Cell textAlign="end">
                  <Link href={`/profile/orders/${item.id}`}>
                    <Button>{t("viewDetails")}</Button>
                  </Link>
                </Table.Cell>
              </Table.Row>
            ))
          )}
        </Table.Body>
      </Table.Root>
    </Box>
  );
}
