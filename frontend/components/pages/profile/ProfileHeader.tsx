"use client";
import { useAuthContext } from "@/providers/AuthProvider";
import { Box, Heading, Icon, Text } from "@chakra-ui/react";
import { useTranslations } from "next-intl";
import React from "react";
import { PiSealCheckFill } from "react-icons/pi";

export default function ProfileHeader() {
  const t = useTranslations("profile");
  const { customer } = useAuthContext();
  return (
    <Box>
      <Heading
        fontSize={{ base: "18px", md: "22px", lg: "36px" }}
        fontWeight={"black"}
        lineHeight={"40px"}
      >
        {t("welcome")} {customer?.name}
      </Heading>
    </Box>
  );
}
