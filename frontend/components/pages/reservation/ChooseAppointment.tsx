import DatePicker from "@/components/ui/DatePicker";
import generateTimesSlots from "@/helpers/generateTimesSlots";
import { useReservationContext } from "@/providers/ReservationProvider";
import {
  Box,
  Button,
  Center,
  DateValue,
  Heading,
  HStack,
  Icon,
  IconButton,
  parseDate,
  Span,
  Text,
  VStack,
} from "@chakra-ui/react";
import { useTranslations } from "next-intl";
import React from "react";
import { CiCalendar } from "react-icons/ci";
import { FaArrowRight, FaRegClock } from "react-icons/fa";
import { MdOutlineCalendarToday } from "react-icons/md";
import { RiErrorWarningLine } from "react-icons/ri";

export default function ChooseAppointment() {
  const t = useTranslations("reservation");
  const {
    reservationData,
    useSteps: { goToPrevStep, goToNextStep },
    setDate,
    setTime,
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
            {t("chooseDateAndTime")}
          </Heading>
          <Text color={"#6B7280"}>
            {t("selectedBranch")}:
            <Span color={"primary"} ms={"3px"} fontWeight={"bold"}>
              {reservationData.branch?.name}
            </Span>
          </Text>
        </VStack>
      </HStack>
      <HStack gap={"24px"} align={"stretch"}>
        {/* date picker box */}
        <VStack
          border={"2px solid #E5E7EB"}
          gap={"24px"}
          rounded={"16px"}
          p={"34px"}
          boxShadow={"0 1px 2px -1px #0000001A, 0 1px 3px 0 #0000001A"}
          w={"calc((100% - 24px) / 2)"}
          align={"stretch"}
        >
          {/* header */}
          <HStack justify={"start"} gap={"12px"}>
            <Center w={"48px"} h="48px" rounded={"14px"} bg={"#FDB6041A"}>
              <Icon size={"lg"} color={"primary"}>
                <MdOutlineCalendarToday />
              </Icon>
            </Center>
            <Heading>{t("chooseDate")}</Heading>
            {/* date picker */}
          </HStack>
          <DatePicker
            onValueChange={(date) => {
              console.log("date.value", date.value[0].toString());
              setDate(date.value.map((d) => d.toString()).join(", "));
            }}
            value={
              reservationData.date
                ? [parseDate(reservationData.date)]
                : undefined
            }
            isDateUnavailable={isWeekend}
            min={parseDate(new Date())}
            max={parseDate(maxReservationDate())}
            bg={"#F9FAFB"}
            rounded={"14px"}
            inputProps={{
              p: "22px 16px",
              h: "auto",
              rounded: "14px",
              border: "2px solid #D1D5DC",
            }}
          />
          {/* selected date badge */}
          {reservationData.date && (
            <HStack
              p="16px"
              border="1px solid #B9F8CF"
              bg="#F0FDF4"
              rounded={"14px"}
              color={"#008236"}
              gap={"14px"}
            >
              <Icon size={"md"}>
                <MdOutlineCalendarToday />
              </Icon>
              <Text fontSize={"14px"}>
                {t("dateSelected")}:{" "}
                {new Date(reservationData.date).toDateString()}
              </Text>
            </HStack>
          )}
          <HStack
            p="16px"
            border="1px solid #BEDBFF"
            bg="#EFF6FF"
            rounded={"14px"}
            color={"#1447E6"}
            gap={"14px"}
          >
            <Icon size={"md"}>
              <RiErrorWarningLine />
            </Icon>
            <Text fontSize={"14px"}>{t("bookUpTo30DaysAhead")}</Text>
          </HStack>
        </VStack>
        {/* time picker box */}
        <VStack
          border={"2px solid #E5E7EB"}
          gap={"24px"}
          rounded={"16px"}
          p={"34px"}
          boxShadow={"0 1px 2px -1px #0000001A, 0 1px 3px 0 #0000001A"}
          w={"calc((100% - 24px) / 2)"}
          align={"stretch"}
        >
          {/* header */}
          <HStack justify={"start"} gap={"12px"}>
            <Center w={"48px"} h="48px" rounded={"14px"} bg={"#EFF6FF"}>
              <Icon size={"lg"} color={"#155DFC"}>
                <FaRegClock />
              </Icon>
            </Center>
            <Heading>{t("chooseTime")}</Heading>
          </HStack>
          {!reservationData.date ? (
            <VStack py="48px" gap={"16px"}>
              <Icon w={"64px"} h={"64px"} p={"0"} color={"#D1D5DC"}>
                <CiCalendar />
              </Icon>
              <Text color={"gray-2"}>{t("chooseDateFirst")}</Text>
            </VStack>
          ) : (
            <HStack flexWrap={"wrap"} gap={"12px"}>
              {generateTimesSlots("08:00:00", "22:30:00").map((slot, i) => (
                <Button
                  variant={"outline"}
                  key={i}
                  color={"black"}
                  w="calc((100% - 36px) / 3)"
                  fontSize={"14px"}
                  fontWeight={"medium"}
                  bg={reservationData.time === slot ? "primary" : "white"}
                  onClick={() => setTime(slot)}
                >
                  {slot}
                </Button>
              ))}
            </HStack>
          )}
        </VStack>
      </HStack>
      <HStack
        justify={"space-between"}
        p="24px"
        border={"1px solid #E5E7EB"}
        rounded="16px"
        mt="32px"
      >
        <Box>
          <Text fontSize={"18px"} fontWeight={"extrabold"} mb={"6px"}>
            {t("selectedAppointment")}
          </Text>
          <HStack gap={"16px"}>
            {/* selected date */}
            <HStack>
              <Icon color={"primary"} strokeWidth={"1px"}>
                <CiCalendar />
              </Icon>
              <Text fontSize={"14px"} color={"#4A5565"}>
                {reservationData.date ? reservationData.date : t("notSelected")}
              </Text>
            </HStack>
            {/* selected time */}
            <HStack>
              <Icon color={"primary"} strokeWidth={"1px"}>
                <CiCalendar />
              </Icon>
              <Text fontSize={"14px"} color={"#4A5565"}>
                {reservationData.time ? reservationData.time : t("notSelected")}
              </Text>
            </HStack>
          </HStack>
        </Box>
        <Button
          disabled={!reservationData.date || !reservationData.time}
          h={"60px"}
          rounded="14px"
          onClick={() => {
            if (reservationData.date && reservationData.time) {
              goToNextStep();
            }
          }}
        >
          {t("continueToConfirmation")}
        </Button>
      </HStack>
    </>
  );
}

const isWeekend = (date: DateValue) => {
  const dayOfWeek = date.toDate("UTC").getDay();
  return dayOfWeek === 5;
};

const maxReservationDate = () => {
  const dateAfter30Days = new Date();
  dateAfter30Days.setDate(dateAfter30Days.getDate() + 30);

  const formatted = dateAfter30Days.toISOString().split("T")[0]; // e.g. 2026-07-17
  return formatted;
};
