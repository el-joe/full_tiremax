"use client";
import CancelReservationDialog from "@/components/dialogs/CancelReservationDialog";
import { Link } from "@/i18n/navigation";
import { IReservation } from "@/types";
import {
  Badge,
  Box,
  Button,
  Center,
  Heading,
  HStack,
  Icon,
  Text,
  VStack,
} from "@chakra-ui/react";
import { useTranslations } from "next-intl";
import React from "react";
import { AiOutlineTool } from "react-icons/ai";
import { FaRegCalendarAlt, FaRegClock } from "react-icons/fa";
import { FaClockRotateLeft } from "react-icons/fa6";
import { FiMapPin } from "react-icons/fi";
import { IoMdClose } from "react-icons/io";

export default function ReservationList({ data }: { data: IReservation[] }) {
  const t = useTranslations("profile");
  if (!data.length)
    return (
      <Center>
        <Text py="40px" fontSize={"28px"} fontWeight={"bold"}>
          No booking yet
        </Text>
      </Center>
    );
  return (
    <VStack gap={"16px"} mt="24px" align={"stretch"}>
      {data.map((reserve) => (
        <HStack
          key={reserve.id}
          gap="18px"
          p="24px"
          borderStyle={"solid"}
          rounded={"16px"}
          shadow={"0 1px 2px -1px #0000001A, 0 1px 3px 0px #0000001A"}
          align={"stretch"}
          borderColor={reserve.status !== "complete" ? "primary" : "#E5E7EB"}
          borderWidth={
            reserve.status === "complete" ? "1px" : "6px 1px 1px 1px"
          }
        >
          <Center
            w={"64px"}
            h="64px"
            bg={reserve.status === "complete" ? "gray-4" : "primary"}
            rounded={"12px"}
            boxShadow={
              reserve.status !== "complete"
                ? "0 2px 4px -2px #FDB6044D, 0 4px 6px -1px #FDB6044D"
                : "unset"
            }
          >
            <Icon size={"xl"}>
              <AiOutlineTool />
            </Icon>
          </Center>
          <VStack align={"stretch"} flex="1" gap={"14px"}>
            <HStack justify={"space-between"}>
              <Box>
                <Heading fontSize={"18px"}>{reserve.service.name}</Heading>
                <Text color={"gray-2"} fontSize={"14px"}>
                  {t("bookingNumber")}: {reserve.reference}
                </Text>
              </Box>
              <Badge
                p="6px 12px"
                rounded={"10px"}
                color={reserve.status === "complete" ? "gray-2" : "#1447E6"}
                bg={reserve.status === "complete" ? "gray-4" : "#DBEAFE"}
                fontSize={"12px"}
              >
                {reserve.status}
              </Badge>
            </HStack>
            <HStack>
              <HStack>
                <Icon color={"primary"}>
                  <FaRegCalendarAlt />
                </Icon>
                <Text fontSize={"14px"} color="gray-2">
                  {new Date(reserve.scheduled_at).toDateString()}
                </Text>
              </HStack>
              <HStack ps="80px">
                <Icon color={"primary"}>
                  <FaRegClock />
                </Icon>
                <Text fontSize={"14px"} color="gray-2">
                  {new Date(reserve.scheduled_at).toLocaleTimeString()}
                </Text>
              </HStack>
              <HStack flex={"1"} justify={"end"} pe="40px">
                <Icon color={"primary"}>
                  <FiMapPin />
                </Icon>
                <Text fontSize={"14px"} color="gray-2">
                  {reserve.branch.address}
                </Text>
              </HStack>
            </HStack>
            {reserve.status !== "complete" && (
              <HStack pt="16px" borderTop={"1px solid #F3F4F6"}>
                <Button bg="gray-4" rounded="12px" color="gray-2">
                  <FaClockRotateLeft /> {t("reschedule")}
                </Button>
                <CancelReservationDialog
                  reservationId={reserve?.id}
                  trigger={
                    <Button
                      border="1px solid #FFC9C9"
                      bg="transparent"
                      color="#E7000B"
                      rounded="12px"
                    >
                      <IoMdClose /> {t("cancelBooking")}
                    </Button>
                  }
                />
                <Link
                  href={`/profile/reservation/${reserve.id}`}
                  className="ms-auto!"
                >
                  <Button rounded="12px" color="black">
                    {t("viewDetails")}
                  </Button>
                </Link>
              </HStack>
            )}
          </VStack>
        </HStack>
      ))}
    </VStack>
  );
}
