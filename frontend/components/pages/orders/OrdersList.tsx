import CurrencySymbol from "@/components/ui/CurrencySymbol";
import { Link } from "@/i18n/navigation";
import { IOrder } from "@/types";
import {
  Badge,
  Box,
  Button,
  Center,
  Heading,
  HStack,
  Image,
  Text,
  VStack,
} from "@chakra-ui/react";
import { getTranslations } from "next-intl/server";
import React from "react";

export default async function OrdersList({ data }: { data: IOrder[] }) {
  const t = await getTranslations("profile");
  if (!data.length)
    return (
      <Center>
        <Text py="40px" fontSize={"28px"} fontWeight={"bold"}>
          No orders yet
        </Text>
      </Center>
    );
  return (
    <VStack gap={"16px"} mt="24px" align={"stretch"}>
      {data.map((order) => (
        <HStack
          key={order.id}
          p="24px"
          border={"1px solid #E5E7EB"}
          rounded={"16px"}
          shadow={"0 1px 2px -1px #0000001A, 0 1px 3px 0px #0000001A"}
          align={"stretch"}
        >
          <Image
            src={"/images/noImage.jpg"}
            alt="image"
            w="80px"
            aspectRatio={"1/1"}
            rounded={"14px"}
          />
          <VStack flex={1} align={"stretch"} gap="12px">
            <HStack align={"start"} justify={"space-between"}>
              <Box>
                <Heading fontSize={"18px"} fontWeight={"bold"}>
                  {order.items[0].product_name} X {order.items[0]?.quantity}
                </Heading>
                <Text color={"gray-2"} fontSize={"14px"}>
                  {t("orderNumber")} {order.reference}
                </Text>
              </Box>
              <Badge
                p="6px 12px"
                rounded={"10px"}
                color="#1447E6"
                bg="#DBEAFE"
                fontSize={"12px"}
              >
                {order.status}
              </Badge>
            </HStack>
            <HStack justify={"space-between"}>
              <Text color={"gray-2"} fontSize={"14px"}>
                {new Date(order.placed_at).toDateString()}
              </Text>
              <Text fontSize={"18px"} fontWeight={"extrabold"} ms={"auto"}>
                {order.total.toLocaleString()} <CurrencySymbol />
              </Text>
              <Link href={`/profile/orders/${order.id}`}>
                <Button h="40px" rounded="14px" ms="12px">
                  {t("viewDetails")}
                </Button>
              </Link>
            </HStack>
          </VStack>
        </HStack>
      ))}
    </VStack>
  );
}
