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
import { getTranslations } from "next-intl/server";
import { FaCircleCheck } from "react-icons/fa6";
import ProductSummary from "@/components/pages/orderConfirm/ProductSummary";
import { MdOutlineLocalShipping } from "react-icons/md";
import { RiBankLine } from "react-icons/ri";
import { FiMapPin } from "react-icons/fi";
import OrderSummary from "@/components/pages/orderConfirm/OrderSummary";
import NeedHelpCard from "@/components/shared/NeedHelpCard";

// dummy data
const data = {
  id: 1,
  reference: "ORD-20260604-0001",
  type: "delivery",
  status: "processing",
  payment_method: "cod",
  payment_status: "pending",
  subtotal: 330000,
  discount: 33000,
  shipping_fee: 0,
  installation_fee: 0,
  total: 297000,
  customer_name: "Ahmed Hassan",
  customer_phone: "07701234567",
  customer_email: "ahmed@example.com",
  shipping_address: "Basra, Al-Ashar, Block 5, House 12",
  tracking_number: "TRK-00001234",
  placed_at: "2026-06-04T10:15:00+03:00",
  governorate: {
    id: 1,
    code: "BSR",
    name: "Basra",
    is_basra: true,
    shipping_fee: 0,
  },
  branch: null,
  items: [
    {
      id: 1,
      product_id: 1,
      product_name: "Michelin Pilot Sport 5 225/50R17",
      product_sku: "MCH-PS5-22550R17",
      quantity: 2,
      unit_price: 165000,
      total: 330000,
    },
    {
      id: 2,
      product_id: 2,
      product_name: "Michelin Pilot Sport 5 225/50R17",
      product_sku: "MCH-PS5-22550R17",
      quantity: 2,
      unit_price: 165000,
      total: 330000,
    },
  ],
};

export default async function page() {
  const t = await getTranslations("cartAndPayment");
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
        <VStack gap={"24px"} w={"528px"} align={"stretch"} textAlign={"start"}>
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
                <MdOutlineLocalShipping />
              </Icon>
            </Center>
            <Box>
              <Text fontSize={"18px"} fontWeight={"bold"}>
                {t("estimatedDeliveryDate")}
              </Text>
              <Text fontSize={"14px"} color={"gray-2"}>
                (unknown)
              </Text>
            </Box>
            <Badge
              ms={"auto"}
              bg="#FFB80033"
              color={"primary"}
              p={"7px 16px"}
              rounded={"12px"}
              fontSize={"12px"}
            >
              {data.status}
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
        </VStack>
        {/* order summary */}
        <VStack gap={"32px"} maxW={"392px"}>
          <OrderSummary data={data} />
          <NeedHelpCard />
        </VStack>
      </HStack>
    </Container>
  );
}

//         "date": "Date",
// "productSummary": "Product Summary",
// "estimatedDeliveryDate": "Estimated Delivery Date",
// "endingWith": "Ending in **** 4242",
// "deliveryAddress": "Delivery Address",
