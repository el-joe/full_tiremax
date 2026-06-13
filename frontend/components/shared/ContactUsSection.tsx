import {
  EmailFastIcon,
  LocationPinIcon,
  PhoneSignalIcon,
} from "@/components/Icons";
import { Box, Center, Heading, HStack, Text, VStack } from "@chakra-ui/react";
import { getTranslations } from "next-intl/server";
import React from "react";
import ContactUsForm from "./ContactUsForm";
import Container from "../ui/Container";

const ContactUsSection = async () => {
  const t = await getTranslations("home");
  return (
    <Container>
      <VStack
        alignItems={"center"}
        gap={{ base: "8px", md: "14px", lg: "20", xl: "24px" }}
        mb={{ base: "16px", md: "28px", lg: "40px", xl: "48px" }}
      >
        <Heading
          as="h2"
          fontSize={{ base: "20px", md: "26px", lg: "32px", xl: "38px" }}
          fontWeight={"bold"}
        >
          {t("contactUs")}
        </Heading>
        <Text
          maxW={"527px"}
          textAlign={"center"}
          fontSize={{ base: "12px", md: "16px", lg: "18px" }}
        >
          {t("contactUsDescription")}
        </Text>
        <Box h="8px" w={"96px"} bg="primary" rounded={"12px"} />
      </VStack>
      <HStack
        gap={{ base: "14px", md: "32px", xl: "48px" }}
        alignItems={{ base: "stretch", md: "start" }}
        flexDir={{ base: "column", md: "row" }}
      >
        <VStack
          flex={1}
          gap={{ base: "9px", md: "12px", lg: "18px", xl: "24px" }}
          alignItems={"stretch"}
        >
          <ContactCardInfo
            Icon={PhoneSignalIcon}
            heading={t("customerServiceNumber")}
            contactInfo={"6622"}
            contactInfoFontSize="36px"
          />
          <ContactCardInfo
            Icon={EmailFastIcon}
            heading={t("email")}
            contactInfo={"support@tiremax.iq"}
          />
          <ContactCardInfo
            Icon={LocationPinIcon}
            heading={t("headOffice")}
            contactInfo={t("headOfficeAddress")}
          />
          <ContactCardInfo
            Icon={LocationPinIcon}
            heading={t("branch2")}
            contactInfo={t("branch2Address")}
          />
        </VStack>
        <ContactUsForm />
      </HStack>
    </Container>
  );
};

export default ContactUsSection;

const ContactCardInfo = ({
  Icon,
  heading,
  contactInfo,
  contactInfoFontSize,
}: {
  Icon: React.ElementType;
  heading: string;
  contactInfo: string;
  contactInfoFontSize?: string;
}) => (
  <HStack
    gap={{ base: "8px", md: "12px", lg: "16px" }}
    rounded={"16px"}
    p={{ base: "9px", md: "22px", xl: "32px" }}
    border={"1px solid #E5E7EB"}
    w={"full"}
  >
    <Center
      bg="primary"
      rounded={"16px"}
      color={"white"}
      w={{ base: "32px", md: "42px", xl: "64px" }}
      h={{ base: "32px", md: "42px", xl: "64px" }}
    >
      <Icon size={{ base: "sm", md: "md", xl: "lg" }} />
    </Center>
    <Box>
      <Text fontSize={"14px"} fontWeight={"semibold"} color={"gray-2"}>
        {heading}
      </Text>
      <Text
        fontSize={{
          base: "12px",
          md: "16px",
          lg: contactInfoFontSize || "20px",
        }}
        fontWeight={"bold"}
      >
        {contactInfo}
      </Text>
    </Box>
  </HStack>
);
