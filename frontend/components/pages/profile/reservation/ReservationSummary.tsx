import CurrencySymbol from "@/components/ui/CurrencySymbol";
import { IReservation } from "@/types";
import { Badge, Heading, HStack, Text, VStack } from "@chakra-ui/react";
import { getTranslations } from "next-intl/server";

type props = {
  data: IReservation;
};

const statusColors: Record<string, { color: string; bg: string }> = {
  complete: { color: "gray-2", bg: "gray-4" },
  cancelled: { color: "#E7000B", bg: "#FFE2E2" },
};

const ReservationSummary = async ({ data }: props) => {
  const t = await getTranslations("profile");
  const badgeColors = statusColors[data.status] ?? {
    color: "primary",
    bg: "#FFB80033",
  };

  return (
    <VStack
      py={{ base: "14px", lg: "26px", "2xl": "40px" }}
      px={{ base: "14px", md: "8px", lg: "22px", "2xl": "32px" }}
      rounded={"16px"}
      gap={{ base: "8px", lg: "22px", "2xl": "31px" }}
      shadow={"0px 40px 80px -20px #00000014"}
      borderTop={"3px solid {colors.primary}"}
      flex={1}
      align={"stretch"}
      w={"full"}
    >
      <HStack alignItems={"start"}>
        <Heading
          fontSize={{ base: "18px", lg: "20px", "2xl": "24px" }}
          fontWeight={"extrabold"}
          pb={{ base: "8px", lg: "18px", "2xl": "24px" }}
        >
          {data.service.name}
        </Heading>
        <Badge
          ms={"auto"}
          bg={badgeColors.bg}
          color={badgeColors.color}
          p={"7px 16px"}
          rounded={"12px"}
          fontSize={"12px"}
        >
          {data.status}
        </Badge>
      </HStack>

      <HStack justify={"space-between"}>
        <Text color={"gray-2"}>{t("bookingNumber")}</Text>
        <Text fontWeight={"bold"}>{data.reference}</Text>
      </HStack>

      <HStack justify={"space-between"}>
        <Text color={"gray-2"}>{t("duration")}</Text>
        <Text fontWeight={"bold"}>
          {data.duration_minutes} {t("minutes")}
        </Text>
      </HStack>

      <HStack justify={"space-between"}>
        <Heading
          fontSize={{ base: "18px", lg: "20px", "2xl": "24px" }}
          fontWeight={"extrabold"}
        >
          {t("price")}
        </Heading>
        <Text
          fontSize={{ base: "18px", lg: "20px", "2xl": "24px" }}
          fontWeight={"bold"}
          color={"primary"}
          ps={"12px"}
        >
          {data.service.price.toLocaleString()} <CurrencySymbol />
        </Text>
      </HStack>
    </VStack>
  );
};

export default ReservationSummary;
