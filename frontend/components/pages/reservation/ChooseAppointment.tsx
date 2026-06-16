import { useReservationContext } from "@/providers/ReservationProvider";
import {
  Heading,
  HStack,
  IconButton,
  Span,
  Text,
  VStack,
} from "@chakra-ui/react";
import { useTranslations } from "next-intl";
import React from "react";
import { FaArrowRight } from "react-icons/fa";

export default function ChooseAppointment() {
  const t = useTranslations("reservation");
  const {
    reservationData,
    useSteps: { goToPrevStep },
  } = useReservationContext();
  return (
    <>
      <HStack gap={"16px"} mb={"32px"}>
        <IconButton
          variant={"ghost"}
          color={"#6B7280"}
          onClick={() => goToPrevStep()}
        >
          <FaArrowRight />
        </IconButton>
        <VStack align={"start"}>
          <Heading fontSize={"24px"} fontWeight={"bold"}>
            {t("chooseNearestBranch")}
          </Heading>
          <Text color={"#6B7280"}>
            {t("selectedService")}:
            <Span color={"primary"} ms={"3px"} fontWeight={"bold"}>
              {reservationData.branch?.name}
            </Span>
          </Text>
        </VStack>
      </HStack>
    </>
  );
}
