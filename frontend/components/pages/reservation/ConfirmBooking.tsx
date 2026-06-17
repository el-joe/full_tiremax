import CurrencySymbol from "@/components/ui/CurrencySymbol";
import formatTimeRange from "@/helpers/formatTimeRange";
import { useReservationContext } from "@/providers/ReservationProvider";
import {
  Box,
  Button,
  Center,
  Heading,
  HStack,
  Icon,
  IconButton,
  List,
  Span,
  Text,
  VStack,
} from "@chakra-ui/react";
import { useLocale, useTranslations } from "next-intl";
import React from "react";
import { AiOutlineTool } from "react-icons/ai";
import { CiCalendar } from "react-icons/ci";
import {
  FaArrowLeft,
  FaArrowRight,
  FaCheck,
  FaRegClock,
  FaStar,
} from "react-icons/fa";
import { FiPhone } from "react-icons/fi";
import { IoLocationOutline } from "react-icons/io5";
import { LuCircleCheckBig } from "react-icons/lu";

export default function ConfirmBooking() {
  const t = useTranslations("reservation");
  const locale = useLocale();
  const {
    useSteps: { goToPrevStep },
    createBooking,
    isCreatingBooking,
  } = useReservationContext();
  return (
    <>
      <HStack gap={"16px"} mb={"32px"}>
        <IconButton
          variant={"ghost"}
          color={"#6B7280"}
          onClick={() => goToPrevStep()}
        >
          {locale === "ar" ? <FaArrowRight /> : <FaArrowLeft />}
        </IconButton>
        <VStack align={"start"}>
          <Heading fontWeight={"bold"} fontSize={{ base: "18px", md: "24px" }}>
            {t("bookingConfirmation")}
          </Heading>
          <Text color={"#6B7280"} fontSize={{ base: "12px", md: "16px" }}>
            {t("reviewBookingDetails")}:
          </Text>
        </VStack>
      </HStack>
      <HStack
        gap={{ base: "22px", xl: "66px" }}
        align={{ base: "stretch", md: "start" }}
        flexDir={{ base: "column", md: "row" }}
        w={"full"}
      >
        <ReservationDetailsCard />
        <VStack
          gap={"24px"}
          flex={{ base: "1", md: "0.6" }}
          align={"stretch"}
          maxW={"346px"}
          mx={"auto"}
        >
          <BranchInfoCard />
          <NotesCard />
          <Button
            h="60px"
            fontSize={"18px"}
            fontWeight={"extrabold"}
            onClick={() => createBooking()}
            loading={isCreatingBooking}
          >
            <FaCheck />
            {t("confirmBookingButton")}
          </Button>
        </VStack>
      </HStack>
    </>
  );
}

const ReservationDetailsCard = () => {
  const t = useTranslations("reservation");
  const { reservationData } = useReservationContext();
  return (
    <VStack
      gap={"24px"}
      p={{ base: "18px", lg: "32px" }}
      bg="primary"
      rounded={"16px"}
      flex={1}
      align={"stretch"}
    >
      <HStack gap="12px">
        <Center minW="48px" h="48px" bg={"#FFFFFF33"} rounded="14px">
          <Icon size={"lg"}>
            <LuCircleCheckBig />
          </Icon>
        </Center>
        <Heading fontSize={"20px"} fontWeight={"bold"}>
          {t("bookingSummary")}
        </Heading>
      </HStack>
      <HStack flexWrap={"wrap"} gap={"16px"}>
        {/* service detail box */}
        <Box
          p="16px"
          bg="#FFFFFF33"
          rounded={"14px"}
          w={"calc((100% - 16px) / 2)"}
        >
          <HStack gap="8px">
            <Icon>
              <AiOutlineTool />
            </Icon>
            <Text fontSize={"14px"}>{t("service")}</Text>
          </HStack>
          <Text
            fontSize={{ base: "13px", md: "16px", lg: "18px" }}
            fontWeight={"bold"}
            my={"8px 4px"}
          >
            {reservationData.service?.name}
          </Text>
          <Text fontSize={{ base: "12px", lg: "14px" }}>
            {reservationData.service?.duration_minutes} {t("minute")}
          </Text>
        </Box>
        {/* branch detail box */}
        <Box
          p="16px"
          bg="#FFFFFF33"
          rounded={"14px"}
          w={"calc((100% - 16px) / 2)"}
        >
          <HStack gap="8px">
            <Icon>
              <IoLocationOutline />
            </Icon>
            <Text fontSize={"14px"}>{t("branch")}</Text>
          </HStack>
          <Text
            fontSize={{ base: "13px", md: "16px", lg: "18px" }}
            fontWeight={"bold"}
            my={"8px 4px"}
          >
            {reservationData.branch?.name}
          </Text>
          <Text fontSize={{ base: "12px", lg: "14px" }}>
            {reservationData.branch?.address} {t("minute")}
          </Text>
        </Box>
        {/* date detail box */}
        <Box
          p="16px"
          bg="#FFFFFF33"
          rounded={"14px"}
          w={"calc((100% - 16px) / 2)"}
        >
          <HStack gap="8px">
            <Icon>
              <CiCalendar />
            </Icon>
            <Text fontSize={{ base: "12px", lg: "14px" }}>{t("date")}</Text>
          </HStack>
          <Text
            fontSize={{ base: "13px", md: "16px", lg: "18px" }}
            fontWeight={"bold"}
            my={"8px 4px"}
          >
            {new Date(reservationData.date ?? "").toDateString()}
          </Text>
        </Box>
        {/* time detail box */}
        <Box
          p="16px"
          bg="#FFFFFF33"
          rounded={"14px"}
          w={"calc((100% - 16px) / 2)"}
        >
          <HStack gap="8px">
            <Icon>
              <FaRegClock />
            </Icon>
            <Text fontSize={"14px"}>{t("time")}</Text>
          </HStack>
          <Text
            fontSize={{ base: "13px", md: "16px", lg: "18px" }}
            fontWeight={"bold"}
            my={"8px 4px"}
          >
            {reservationData.time}
          </Text>
        </Box>
      </HStack>
      <HStack
        justify={"space-between"}
        pt={"24px"}
        borderTop={"1px solid #FFFFFF33"}
      >
        <Text fontSize={"18px"}>{t("estimatedCost")}</Text>
        <Text fontSize={"24px"} fontWeight={"bold"}>
          {reservationData.service?.price}
          <CurrencySymbol />
        </Text>
      </HStack>
    </VStack>
  );
};

const BranchInfoCard = () => {
  const t = useTranslations("reservation");
  const locale = useLocale();
  const {
    reservationData,
    useSteps: { goToPrevStep },
  } = useReservationContext();
  return (
    <VStack
      p="24px"
      border={"1px solid #E5E7EB"}
      rounded={"16px"}
      align={"stretch"}
      gap={"12px"}
    >
      <Heading pb={"4px"}>{t("branchInformation")}</Heading>
      {/* address */}
      <HStack>
        <Icon color={"primary"}>
          <IoLocationOutline />
        </Icon>
        <Text fontSize={"14px"} color={"gray-2"}>
          {reservationData.branch?.address}
        </Text>
      </HStack>
      {/* phone */}
      <HStack>
        <Icon color={"primary"}>
          <FiPhone />
        </Icon>
        <Text fontSize={"14px"} color={"gray-2"}>
          {reservationData.branch?.phone}
        </Text>
      </HStack>
      {/* opens & closes time */}
      <HStack>
        <Icon color={"primary"}>
          <FaRegClock />
        </Icon>
        <Text fontSize={"14px"} color={"gray-2"}>
          {formatTimeRange(
            reservationData.branch?.schedules[0]?.opens_at ?? "",
            reservationData.branch?.schedules[0]?.closes_at ?? "",
            locale,
          )}
        </Text>
      </HStack>
      <HStack pt={"12px"} borderTop={"1px solid #F3F4F6"}>
        <Icon color={"primary"}>
          <FaStar />
        </Icon>
        <Text fontWeight={"bold"}>4.8</Text>
        <Text color={"gray-2"}>(288{t("rate")})</Text>
      </HStack>
    </VStack>
  );
};

const NotesCard = () => {
  const t = useTranslations("reservation");
  return (
    <VStack
      color={"#1447E6"}
      border={"1px solid #BEDBFF"}
      bg={"#EFF6FF"}
      rounded={"16px"}
      p="24px"
      align={"stretch"}
    >
      <Heading fontSize={"18px"} pb={"4px"}>
        {t("importantNotes")}
      </Heading>
      <List.Root ps={"16px"} gap={"8px"}>
        <List.Item>{t("arriveEarlyNote")}</List.Item>
        <List.Item>{t("lateArrivalNote")}</List.Item>
        <List.Item>{t("modifyBookingNote")}</List.Item>
      </List.Root>
    </VStack>
  );
};

//     "importantNotes": "Important Notes",
//     "": "Please arrive 10 minutes before your scheduled appointment.",
//     "": "Late arrivals may result in your appointment being rescheduled.",
//     "": "You may cancel or modify your booking up to 24 hours in advance.",
//     "": "Confirm Booking"
