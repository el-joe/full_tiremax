"use client";
import CreateAddressDialog from "@/components/dialogs/CreateAddressDialog";
import { Box, Button, Heading, HStack, Text } from "@chakra-ui/react";
import { useTranslations } from "next-intl";
import React from "react";
import { FaPlus } from "react-icons/fa6";

export default function AddressesHeader() {
  const t = useTranslations("profile");
  return (
    <HStack
      justify={"space-between"}
      p={{ base: "10px", md: "16px", lg: "24px" }}
      border={"1px solid #E5E7EB"}
      rounded={"16px"}
      shadow={"0 1px 2px -1px #0000001A, 0 1px 3px 0px #0000001A"}
    >
      <Box>
        <Heading
          pb={"8px"}
          fontSize={{ base: "16px", md: "18px", lg: "30px" }}
          fontWeight={"bold"}
        >
          {t("savedAddresses")}
        </Heading>
        <Text
          color={"gray-2"}
          fontSize={{ base: "8px", md: "12px", lg: "16px" }}
        >
          {t("manageAddressesDescription")}
        </Text>
      </Box>
      <CreateAddressDialog
        trigger={
          <Button
            color={"black"}
            rounded={"12px"}
            h={{ base: "auto", md: "48px" }}
            fontSize={{ base: "12px", lg: "16px" }}
            p={{ base: "4px", md: "8px", lg: "12px" }}
          >
            <FaPlus />
            {t("addAddress")}
          </Button>
        }
      />
    </HStack>
  );
}
