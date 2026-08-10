import DatePicker from "@/components/ui/DatePicker";
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
  Spinner,
  Text,
  VStack,
} from "@chakra-ui/react";
import { useLocale, useTranslations } from "next-intl";
import { CiCalendar } from "react-icons/ci";
import { FaArrowLeft, FaArrowRight, FaRegClock } from "react-icons/fa";
import { MdOutlineCalendarToday } from "react-icons/md";
import { RiErrorWarningLine } from "react-icons/ri";

export default function ChooseAppointment() {
  const t = useTranslations("reservation");
  const locale = useLocale();
  const {
    reservationData,
    useSteps: { goToPrevStep, goToNextStep },
    setDate,
    setTime,
    availableTimeSlots,
    isAvailableTimeSlotsLoading,
  } = useReservationContext();
  return (
    <Box maxW={"1086px"} mx={"auto"}>
      <HStack gap={"16px"} mb={"32px"}>
        <IconButton
          variant={"ghost"}
          color={"#6B7280"}
          onClick={() => goToPrevStep()}
        >
          {locale === "ar" ? <FaArrowRight /> : <FaArrowLeft />}
        </IconButton>
        <VStack align={"start"}>
          <Heading fontSize={{ base: "18px", md: "24px" }} fontWeight={"bold"}>
            {t("chooseDateAndTime")}
          </Heading>
          <Text color={"#6B7280"} fontSize={{ base: "12px", md: "16px" }}>
            {t("selectedBranch")}:
            <Span color={"primary"} ms={"3px"} fontWeight={"bold"}>
              {reservationData.branch?.name}
            </Span>
          </Text>
        </VStack>
      </HStack>
      <HStack gap={"24px"} align={"stretch"} flexWrap={"wrap"}>
        {/* date picker box */}
        <VStack
          border={"2px solid #E5E7EB"}
          gap={"24px"}
          rounded={"16px"}
          p={{ base: "18px", lg: "34px" }}
          boxShadow={"0 1px 2px -1px #0000001A, 0 1px 3px 0 #0000001A"}
          w={"calc((100% - 24px) / 2)"}
          align={"stretch"}
          minW={"280px"}
          flex={1}
        >
          {/* header */}
          <HStack justify={"start"} gap={"12px"}>
            <Center
              w={{ base: "26px", lg: "48px" }}
              h={{ base: "26px", lg: "48px" }}
              rounded={{ base: "6px", lg: "14px" }}
              bg={"#FDB6041A"}
            >
              <Icon size={{ lg: "lg" }} color={"primary"}>
                <MdOutlineCalendarToday />
              </Icon>
            </Center>
            <Heading>{t("chooseDate")}</Heading>

            {/* date picker input */}
          </HStack>
          <DatePicker
            onValueChange={(date) => {
              setDate(date.value.map((d) => d.toString()).join(", "));
            }}
            value={
              reservationData.date
                ? [parseDate(reservationData.date)]
                : undefined
            }
            isDateUnavailable={(date) =>
              isClosedDay(date, reservationData.branch?.schedules ?? [])
            }
            min={parseDate(new Date())}
            max={parseDate(maxReservationDate())}
            bg={"#F9FAFB"}
            rounded={"14px"}
            inputProps={{
              p: { base: "12px", lg: "22px 16px" },
              h: "auto",
              rounded: "14px",
              border: "2px solid #D1D5DC",
            }}
          />
          {/* selected date badge */}
          {reservationData.date && (
            <HStack
              p={{ base: "8px", lg: "16px" }}
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
          {!reservationData.branch?.schedules.find((d) => !d.is_closed) && (
            <HStack
              p={{ base: "8px", lg: "16px" }}
              border="1px solid {colors.red.border}"
              bg="red.muted"
              rounded={"14px"}
              color={"red.fg"}
              gap={"14px"}
            >
              <Icon size={"md"}>
                <RiErrorWarningLine />
              </Icon>
              <Text fontSize={"14px"}>
                {t("thisBranchHasNoAvailableDates")}:{" "}
              </Text>
            </HStack>
          )}
          <HStack
            p={{ base: "8px", lg: "16px" }}
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
          p={{ base: "18px", lg: "34px" }}
          boxShadow={"0 1px 2px -1px #0000001A, 0 1px 3px 0 #0000001A"}
          w={"calc((100% - 24px) / 2)"}
          align={"stretch"}
          minW={"280px"}
          flex={1}
        >
          {/* header */}
          <HStack justify={"start"} gap={"12px"}>
            <Center
              w={{ base: "26px", lg: "48px" }}
              h={{ base: "26px", lg: "48px" }}
              rounded={{ base: "6px", lg: "14px" }}
              bg={"#EFF6FF"}
            >
              <Icon size={{ lg: "lg" }} color={"#155DFC"}>
                <FaRegClock />
              </Icon>
            </Center>
            <Heading>{t("chooseTime")}</Heading>
          </HStack>
          {!reservationData.branch || !reservationData.date ? (
            <VStack py="48px" gap={"16px"}>
              <Icon w={"64px"} h={"64px"} p={"0"} color={"#D1D5DC"}>
                <CiCalendar />
              </Icon>
              <Text color={"gray-2"}>{t("chooseDateFirst")}</Text>
            </VStack>
          ) : isAvailableTimeSlotsLoading ? (
            <Center>
              <Spinner size={"lg"} />
            </Center>
          ) : !availableTimeSlots.length ? (
            <HStack
              p={{ base: "8px", lg: "16px" }}
              border="1px solid {colors.red.border}"
              bg="red.muted"
              rounded={"14px"}
              color={"red.fg"}
              gap={"14px"}
            >
              <Icon size={"md"}>
                <RiErrorWarningLine />
              </Icon>
              <Text fontSize={"14px"}>{t("noTimeAvailable")}: </Text>
            </HStack>
          ) : (
            <HStack flexWrap={"wrap"} gap={"12px"}>
              {/* {generateTimesSlots("08:00:00", "22:30:00").map((slot, i) => ( */}
              {availableTimeSlots.map((slot, i) => (
                <Button
                  variant={"outline"}
                  key={i}
                  color={"black"}
                  w="calc((100% - 36px) / 3)"
                  fontSize={"14px"}
                  fontWeight={"medium"}
                  bg={reservationData.time === slot.time ? "primary" : "white"}
                  onClick={() => setTime(slot.time)}
                  disabled={!slot.available}
                >
                  {slot.time}
                </Button>
              ))}
            </HStack>
          )}
          {/* selected date badge */}
          {reservationData.time && (
            <HStack
              p={{ base: "8px", lg: "16px" }}
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
                {t("selectedTime")}: {reservationData.time}
              </Text>
            </HStack>
          )}
        </VStack>
      </HStack>
      {/* confirmation bar */}
      <HStack
        justify={"space-between"}
        p={{ base: "8px", lg: "24px" }}
        border={"1px solid #E5E7EB"}
        rounded="16px"
        mt="32px"
      >
        <Box>
          <Text
            fontSize={{ base: "14px", md: "18px" }}
            fontWeight={"extrabold"}
            mb={"6px"}
          >
            {t("selectedAppointment")}
          </Text>
          <HStack gap={"16px"}>
            {/* selected date */}
            <HStack>
              <Icon color={"primary"} strokeWidth={"1px"}>
                <CiCalendar />
              </Icon>
              <Text fontSize={{ base: "9px", md: "14px" }} color={"#4A5565"}>
                {reservationData.date ? reservationData.date : t("notSelected")}
              </Text>
            </HStack>
            {/* selected time */}
            <HStack>
              <Icon color={"primary"} strokeWidth={"1px"}>
                <FaRegClock />
              </Icon>
              <Text fontSize={{ base: "9px", md: "14px" }} color={"#4A5565"}>
                {reservationData.time ? reservationData.time : t("notSelected")}
              </Text>
            </HStack>
          </HStack>
        </Box>
        <Button
          disabled={!reservationData.date || !reservationData.time}
          h={{ base: "42px", md: "60px" }}
          rounded="14px"
          onClick={() => {
            if (reservationData.date && reservationData.time) {
              goToNextStep();
            }
          }}
          fontSize={{ base: "12px", md: "18px" }}
          fontWeight={"extrabold"}
        >
          {t("continueToConfirmation")}
        </Button>
      </HStack>
    </Box>
  );
}

const isClosedDay = (
  date: DateValue,
  branchSchedule: { day_of_week: number; is_closed: boolean }[],
) => {
  const dayOfWeek = date.toDate("UTC").getDay();
  const targetDay = branchSchedule.find((d) => d.day_of_week == dayOfWeek);
  if (!!targetDay) {
    return targetDay.is_closed;
  } else {
    return true;
  }
};

const maxReservationDate = () => {
  const dateAfter30Days = new Date();
  dateAfter30Days.setDate(dateAfter30Days.getDate() + 30);

  const formatted = dateAfter30Days.toISOString().split("T")[0]; // e.g. 2026-07-17
  return formatted;
};
