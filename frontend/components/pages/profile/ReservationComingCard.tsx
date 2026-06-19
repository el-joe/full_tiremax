"use client";
import { Link } from "@/i18n/navigation";
import { IReservation } from "@/types";
import axiosInstance from "@/utils/axiosInstance";
import {
  Box,
  Button,
  Center,
  Heading,
  HStack,
  Icon,
  Spinner,
  Text,
  VStack,
} from "@chakra-ui/react";
import { useQuery } from "@tanstack/react-query";
import { useTranslations } from "next-intl";
import React from "react";
import { FaPen, FaRegClock } from "react-icons/fa";
import { IoMdClose } from "react-icons/io";

// const upcomingRes = {
//   id: 1,
//   reference: "BKG-20260604-0001",
//   scheduled_at: "2026-06-10T10:00:00+03:00",
//   duration_minutes: 30,
//   status: "confirmed",
//   customer_notes: "Please use nitrogen for inflation",
//   branch: {
//     id: 1,
//     code: "BSR-MAIN",
//     name: "Basra Main Branch",
//     address: "Basra, Abu Al-Khaseeb Highway",
//     phone: "0771-000-0001",
//     latitude: 30.5085,
//     longitude: 47.7834,
//   },
//   service: {
//     id: 1,
//     slug: "tire-fitting",
//     name: "Tire Fitting",
//     description: "Professional mounting and fitting of new tires",
//     duration_minutes: 30,
//     price: 5000,
//   },
// };

export default function ReservationComingCard() {
  const t = useTranslations("profile");
  const { data: upcomingReservation, isLoading } = useQuery({
    queryKey: ["reservation"],
    queryFn: async () => {
      const { data } = await axiosInstance<{ data: IReservation[] }>(
        "bookings",
      );
      const upcomingR = data.data.findLast((r) => r.status === "confirmed");
      return upcomingR;
    },
  });
  return (
    <Box
      p="24px"
      bg={"gray-4"}
      rounded={"16px"}
      borderStart={"4px solid {colors.primary}"}
    >
      <HStack justify={"space-between"}>
        <Heading fontSize={"24px"} fontWeight={"black"} mb={"24px"}>
          {t("upcomingBookings")}
        </Heading>
        <Link href={"/profile/reservation"}>
          <Text fontWeight={"bold"} color="gray-2">
            {t("viewAll")}
          </Text>
        </Link>
      </HStack>
      <HStack
        gap={"24px"}
        p="20px"
        rounded={"16px"}
        bg="white"
        align={"stretch"}
        flexWrap={"wrap"}
        justify={"stretch"}
      >
        {isLoading ? (
          <Center w="full">
            <Spinner />
          </Center>
        ) : !upcomingReservation ? (
          <>
            <Text>No reservation yet</Text>
          </>
        ) : (
          <>
            {" "}
            <VStack
              gap={"0"}
              bg="primary"
              rounded={"8px"}
              w={"70px"}
              h="75px"
              justify={"center"}
            >
              <Text fontSize={"20px"} fontWeight={"black"}>
                {new Date(upcomingReservation.scheduled_at).getDay()}
              </Text>
              <Text fontSize={"10px"} fontWeight={"bold"}>
                {
                  new Date(upcomingReservation.scheduled_at)
                    .toUTCString()
                    .split(" ")[2]
                }
              </Text>
            </VStack>
            <HStack justify={"space-between"} flex="1">
              <Text fontWeight={"bold"}>
                {upcomingReservation?.service?.name}
              </Text>
              <Text mt={"auto"} fontSize={"12px"} color="gray-2">
                <Icon size={"sm"} me={"2px"}>
                  <FaRegClock />
                </Icon>
                {new Date(
                  upcomingReservation?.scheduled_at,
                ).toLocaleTimeString()}{" "}
                •{upcomingReservation?.branch.name}{" "}
              </Text>
            </HStack>
            <HStack gap="8px">
              <Button variant={"ghost"} color={"#514532"}>
                <Icon>
                  <FaPen />
                </Icon>
              </Button>
              <Button
                variant={"ghost"}
                color={"myRed"}
                _hover={{ bg: "red.emphasized" }}
              >
                <Icon>
                  <IoMdClose />
                </Icon>
              </Button>
            </HStack>
          </>
        )}
      </HStack>
    </Box>
  );
}
