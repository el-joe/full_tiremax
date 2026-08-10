import Container from "@/components/ui/Container";
import {
  Badge,
  Box,
  Center,
  Heading,
  HStack,
  Icon,
  Text,
  VStack,
} from "@chakra-ui/react";
import { getLocale, getTranslations } from "next-intl/server";
import { FaCircleCheck } from "react-icons/fa6";
import ProductSummary from "@/components/pages/orderConfirm/ProductSummary";
import { MdOutlineLocalShipping } from "react-icons/md";
import { RiBankLine } from "react-icons/ri";
import { FiMapPin } from "react-icons/fi";
import { FaStoreAlt } from "react-icons/fa";
import OrderSummary from "@/components/pages/orderConfirm/OrderSummary";
import NeedHelpCard from "@/components/shared/NeedHelpCard";
import axiosInstance from "@/utils/axiosInstance";
import { IOrder } from "@/types";
import { redirect } from "next/navigation";

type props = {
  params: Promise<{ orderId: string }>;
};

export default async function page({ params }: props) {
  const { orderId } = await params;
  const t = await getTranslations("cartAndPayment");
  const locale = await getLocale();
  try {
    const {
      data: { data },
    } = await axiosInstance<{ data: IOrder }>(`orders/${orderId}`);
    return (
      <Container>
        <VStack
          gap={"16px"}
          maxW={"445px"}
          mx={"auto"}
          mb={"32px"}
          textAlign={"center"}
        >
          <Center
            w={"96px"}
            py={"24px"}
            bg={"primary"}
            rounded={"12px"}
            mx={"auto"}
          >
            <Icon size={"xl"} color={"white"}>
              <FaCircleCheck />
            </Icon>
          </Center>
          <Heading fontSize="38px" fontWeight="extrabold">
            {t("orderConfirmedSuccessfully")}
          </Heading>
          <Text fontSize={"18px"} color={"gray-2"}>
            {t("orderConfirmationMessage")}
          </Text>
        </VStack>
        <HStack align={"start"} justify={"center"} gap="40px" flexWrap={"wrap"}>
          {/* products summary */}
          <VStack
            gap={"24px"}
            w={"528px"}
            align={"stretch"}
            textAlign={"start"}
          >
            <ProductSummary data={data} />
            {/*  */}
            <HStack
              gap={"16px"}
              px={"32px"}
              py={"16px"}
              borderStart={"4px solid {colors.primary}"}
              rounded={"8px"}
              bg="#FAFAFA"
              align="start"
            >
              <Center minW="48px" h={"48px"} bg="primary" rounded={"8px"}>
                <Icon size={"xl"} color={"white"}>
                  {data.type === "basra" ? (
                    <FaStoreAlt />
                  ) : (
                    <MdOutlineLocalShipping />
                  )}
                </Icon>
              </Center>
              <Box>
                <Text fontSize={"18px"} fontWeight={"bold"}>
                  {data.type === "basra"
                    ? t("branchPickup")
                    : t("estimatedDeliveryDate")}
                </Text>
                {data.type === "basra" ? (
                  <>
                    <Text fontSize={"14px"} color={"gray-2"}>
                      {data.branch?.name}
                    </Text>
                    <Text fontSize={"14px"} color={"gray-2"}>
                      {data.branch?.address}
                    </Text>
                    <Text fontSize={"14px"} color={"gray-2"}>
                      {data.branch?.phone}
                    </Text>
                  </>
                ) : (
                  <Text fontSize={"14px"} color={"gray-2"}>
                    (unknown)
                  </Text>
                )}
              </Box>
              <Badge
                ms={"auto"}
                bg="#FFB80033"
                color={"primary"}
                p={"7px 16px"}
                rounded={"12px"}
                fontSize={"12px"}
              >
                {data.type === "basra" ? t("readyForPickup") : data.status}
              </Badge>
            </HStack>
            {/*  */}
            <HStack
              gap={"16px"}
              px={"32px"}
              py={"16px"}
              borderStart={"4px solid {colors.primary}"}
              rounded={"8px"}
              bg="#FAFAFA"
              align="start"
            >
              <Center minW="48px" h={"48px"} bg="primary" rounded={"8px"}>
                <Icon size={"xl"} color={"white"}>
                  <RiBankLine />
                </Icon>
              </Center>
              <Box>
                <Text fontSize={"18px"} fontWeight={"bold"}>
                  {t("paymentMethod")}
                </Text>
                <Text fontSize={"14px"} color={"gray-2"}>
                  {data.payment_method}
                </Text>
              </Box>
            </HStack>
            {/*  */}
            {data.type === "delivery" && (
              <HStack
                gap={"16px"}
                px={"32px"}
                py={"16px"}
                borderStart={"4px solid {colors.primary}"}
                rounded={"8px"}
                bg="#FAFAFA"
                align="start"
              >
                <Center minW="48px" h={"48px"} bg="primary" rounded={"8px"}>
                  <Icon size={"xl"} color={"white"}>
                    <FiMapPin />
                  </Icon>
                </Center>
                <Box>
                  <Text fontSize={"18px"} fontWeight={"bold"}>
                    {t("deliveryAddress")}
                  </Text>
                  <Text fontSize={"14px"} color={"gray-2"}>
                    {data.shipping_address}
                  </Text>
                  <Text fontSize={"14px"} color={"gray-2"}>
                    {data.customer_phone}
                  </Text>
                </Box>
              </HStack>
            )}
          </VStack>
          {/* order summary */}
          <VStack gap={"32px"} maxW={"392px"}>
            <OrderSummary data={data} />
            <NeedHelpCard />
          </VStack>
        </HStack>
      </Container>
    );
  } catch {
    redirect(`/${locale}`);
  }
}
