"use client";
import RateProductDialog from "@/components/dialogs/RateProductDialog";
import { IOrder } from "@/types";
import { Badge, Button, Heading, HStack, Text, VStack } from "@chakra-ui/react";
import { useTranslations } from "next-intl";
import { FaStar } from "react-icons/fa";

// Lets the customer rate each product of a delivered order
export default function RateOrderItems({ order }: { order: IOrder }) {
  const t = useTranslations("profile");
  if (!["delivered", "completed"].includes(order.status)) return null;

  return (
    <VStack
      align={"stretch"}
      gap={"12px"}
      p={"24px"}
      rounded={"16px"}
      border={"1px solid #E5E7EB"}
    >
      <Heading fontSize={"18px"} fontWeight={"bold"}>
        {t("rateYourProducts")}
      </Heading>
      <Text fontSize={"14px"} color={"gray-2"}>
        {t("rateYourProductsDescription")}
      </Text>
      {order.items.map((item) => (
        <HStack key={item.id} justify={"space-between"} gap={"12px"}>
          <Text fontWeight={"semibold"} fontSize={"14px"} lineClamp={2}>
            {item.product_name}
          </Text>
          {item.reviewed ? (
            <Badge colorPalette={"green"} p={"6px 12px"} rounded={"10px"}>
              {t("rated")}
            </Badge>
          ) : (
            <RateProductDialog
              productId={item.product_id}
              productName={item.product_name}
              orderId={order.id}
              trigger={
                <Button size={"sm"} rounded={"10px"} h={"auto"} p={"8px 12px"}>
                  <FaStar />
                  {t("rate")}
                </Button>
              }
            />
          )}
        </HStack>
      ))}
    </VStack>
  );
}
