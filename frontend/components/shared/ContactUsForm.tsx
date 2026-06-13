"use client";
import { Box, Button, Center, HStack, Text, VStack } from "@chakra-ui/react";
import React from "react";
import Input from "../ui/Input";
import { useTranslations } from "next-intl";
import {
  PhoneSignalIcon,
  SendMessageIcon,
  UserCircleIcon,
  WhatsappLogoIcon,
} from "../Icons";
import Textarea from "../ui/Textarea";
import { Link } from "@/i18n/navigation";
import { useForm } from "react-hook-form";

const ContactUsForm = () => {
  const t = useTranslations("home");
  const { handleSubmit } = useForm();
  const onSubmit = handleSubmit((data) => {
    console.log(data);
  });
  return (
    <form onSubmit={onSubmit}>
      <VStack
        gap={{ base: "9px", md: "22px", xl: "32px" }}
        rounded={"16px"}
        p={{ base: "9px", md: "22px", xl: "32px" }}
        border={"1px solid #E5E7EB"}
        alignItems={"stretch"}
      >
        <HStack gap={{ base: "9px", md: "22px", xl: "32px" }}>
          <Input
            label={t("fullName")}
            placeholder={t("enterYourFullName")}
            startElement={<UserCircleIcon size={"md"} />}
          />
          <Input
            label={t("phoneNumber")}
            placeholder={t("phoneNumberPlaceholder")}
            startElement={<PhoneSignalIcon size={"sm"} color={"gray-2"} />}
          />
        </HStack>
        <Input
          label={t("inquirySubject")}
          placeholder={t("inquiryAboutPrices")}
          w={{ base: "full", xl: "576px" }}
        />
        <Textarea
          label={t("message")}
          placeholder={t("howCanWeHelpYouToday")}
          minH={"160px"}
        />
        <HStack justifyContent={"space-between"} gap={{ base: "4px" }}>
          <HStack gap={{ base: "1px", md: "8px" }}>
            <Text fontSize={{ base: "10px", md: "16px" }}>
              {t("orContactImmediatelyVia")}
            </Text>
            <Link href="/">
              <Center
                bg="#41C452"
                rounded={"8px"}
                color={"white"}
                w={{ base: "24px", md: "38px", xl: "48px" }}
                h={{ base: "24px", md: "38px", xl: "48px" }}
              >
                <WhatsappLogoIcon size={{ base: "sm", md: "lg", xl: "xl" }} />
              </Center>
            </Link>
          </HStack>
          <Button
            fontSize={{ base: "13px", md: "16px", xl: "20px" }}
            rounded={{ base: "11px", md: "16px" }}
            gap={{ base: "3px", md: "11px" }}
            px={{ base: "9px", md: "24px", xl: "48px" }}
            py={{ base: "7px", md: "14px", xl: "20px" }}
            type="submit"
          >
            {" "}
            <SendMessageIcon size={{ base: "xs", md: "sm" }} />{" "}
            {t("sendMessage")}
          </Button>
        </HStack>
      </VStack>
    </form>
  );
};

export default ContactUsForm;
