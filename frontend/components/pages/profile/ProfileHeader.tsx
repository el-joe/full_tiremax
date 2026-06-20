"use client";
import { useAuthContext } from "@/providers/AuthProvider";
import { Box, Heading } from "@chakra-ui/react";
import { useTranslations } from "next-intl";

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
