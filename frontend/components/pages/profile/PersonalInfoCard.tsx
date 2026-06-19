"use client";
import { Link } from "@/i18n/navigation";
import { useAuthContext } from "@/providers/AuthProvider";
import { Box, Heading, HStack, Icon, Text } from "@chakra-ui/react";
import { useTranslations } from "next-intl";
import React from "react";
import { FaPen } from "react-icons/fa";
import { LuMapPin } from "react-icons/lu";

export default function PersonalInfoCard() {
  const t = useTranslations("profile");
  const { customer } = useAuthContext();
  return (
    <Box
      p="24px"
      bg={"gray-4"}
      rounded={"16px"}
      borderStart={"4px solid {colors.primary}"}
    >
      <HStack justify={"space-between"}>
        <Heading fontSize={"24px"} fontWeight={"black"} mb={"24px"}>
          {t("personalInformation")}
        </Heading>
        <Link href={"/profile/settings"}>
          <Text fontWeight={"bold"} color="gray-2">
            <Icon>
              <FaPen />
            </Icon>
            {t("edit")}
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
      >
        {/* name */}
        <Box w={"calc((100% - 24px) / 2)"}>
          <Text fontSize={"10px"} fontWeight={"bold"} color={"gray-2"}>
            {t("fullName")}
          </Text>
          <Text fontWeight={"bold"}>{customer?.name}</Text>
        </Box>
        {/* phone */}
        <Box w={"calc((100% - 24px) / 2)"}>
          <Text fontSize={"10px"} fontWeight={"bold"} color={"gray-2"}>
            {t("phoneNumber")}
          </Text>
          <Text fontWeight={"bold"}>{customer?.phone}</Text>
        </Box>
        {/* address */}
        <Box w="full">
          <Text fontSize={"10px"} fontWeight={"bold"} color={"gray-2"} mb="3px">
            {t("primaryAddress")}
          </Text>
          <Text fontWeight={"bold"}>
            <Icon size={"md"} color={"primary"}>
              <LuMapPin />
            </Icon>
            {customer?.address}
          </Text>
        </Box>
      </HStack>
    </Box>
  );
}
