import Container from "@/components/ui/Container";
import {
  Box,
  Center,
  Heading,
  HStack,
  Icon,
  List,
  Text,
  VStack,
} from "@chakra-ui/react";
import { Metadata } from "next";
import { getLocale, getTranslations } from "next-intl/server";
import React from "react";
import { FaRegCheckCircle } from "react-icons/fa";
import { GiCheckedShield } from "react-icons/gi";
import { PiShieldCheck } from "react-icons/pi";

export const metadata: Metadata = {
  title: "terms and conditions",
};

export default async function page() {
  const t = await getTranslations("termsAndConditions");
  const locale = await getLocale();
  return (
    <Container>
      <VStack gap="48px" align="stretch">
        <Heading
          fontSize={{ base: "22px", md: "38px" }}
          fontWeight={"extrabold"}
          textAlign={"center"}
          mb={{ md: "28px" }}
        >
          {t("termsAndConditions")}
        </Heading>
        <Text
          fontSize={{ base: "14px", md: "18px" }}
          color={"gray-2"}
          maxW={"670px"}
          textAlign={"center"}
          mx="auto"
        >
          {t("termsAndConditionsDescription")}
        </Text>
        {/* 1 */}
        <VStack
          align={"stretch"}
          gap="24px"
          bg="gray-4"
          p={{ base: "18px", md: "48px" }}
          rounded={"12px"}
        >
          <Heading
            fontSize={"24px"}
            fontWeight={"bold"}
            position={"relative"}
            ps={"20px"}
            _before={{
              w: "4px",
              h: "24px",
              ...(locale === "ar" ? { right: "0" } : { left: "0" }),
              bg: "primary",
              content: '""',
              rounded: "2px",
              position: "absolute",
            }}
          >
            1. {t("introduction")}
          </Heading>
          <Text color="#514532" maxW="690px">
            {t("introductionParagraph1")}
          </Text>
          <Text color="#514532" maxW="690px">
            {t("introductionParagraph2")}
          </Text>
        </VStack>
        {/* 2 */}
        <HStack
          align={"stretch"}
          gap="24px"
          p={{ base: "18px", md: "48px" }}
          position={"relative"}
          flexWrap={"wrap"}
          _before={{
            w: "4px",
            h: { base: "90%", md: "70%" },
            bg: "primary",
            content: '""',
            rounded: "2px",
            position: "absolute",
          }}
        >
          <Heading
            fontSize={"24px"}
            fontWeight={"bold"}
            ps={"20px"}
            minW={"full"}
          >
            2. {t("userObligations")}
          </Heading>
          <Box w={{ base: "100%", md: "calc((100% - 24px) / 2)" }} p="24px">
            <Center
              w="40px"
              h="40px"
              rounded={"4px"}
              bg="primary"
              color={"white"}
            >
              <Icon strokeWidth={"1px"} size="md">
                <PiShieldCheck />
              </Icon>
            </Center>
            <Text fontWeight={"bold"} my="6px">
              {t("informationAccuracy")}
            </Text>
            <Text maxW={"294px"} fontSize={"14px"} color="gray-2">
              {t("informationAccuracyDescription")}
            </Text>
          </Box>
          <Box w={{ base: "100%", md: "calc((100% - 24px) / 2)" }} p="24px">
            <Center
              w="40px"
              h="40px"
              rounded={"4px"}
              bg="primary"
              color={"white"}
            >
              <Icon strokeWidth={"1px"} size="md">
                <GiCheckedShield />
              </Icon>
            </Center>
            <Text fontWeight={"bold"} my="6px">
              {t("accountSecurity")}
            </Text>
            <Text maxW={"294px"} fontSize={"14px"} color="gray-2">
              {t("accountSecurityDescription")}
            </Text>
          </Box>
        </HStack>
        {/* 3 purchasesAndPayments */}
        <VStack
          align={"stretch"}
          gap="24px"
          bg="gray-4"
          p={{ base: "18px", md: "48px" }}
          rounded={"12px"}
        >
          <Heading
            fontSize={"24px"}
            fontWeight={"bold"}
            position={"relative"}
            ps={"20px"}
            _before={{
              w: "4px",
              h: "24px",
              ...(locale === "ar" ? { right: "0" } : { left: "0" }),
              bg: "primary",
              content: '""',
              rounded: "2px",
              position: "absolute",
            }}
          >
            3. {t("purchasesAndPayments")}
          </Heading>
          <Text color="gray-2" maxW="690px">
            {t("purchasesAndPaymentsParagraph1")}
          </Text>
          <List.Root gap="2" variant="plain" align="center" ms={{ md: "30%" }}>
            <List.Item color="gray-2">
              <List.Indicator asChild color="primary">
                <FaRegCheckCircle />
              </List.Indicator>
              {t("purchasesAndPaymentsParagraph2")}
            </List.Item>
            <List.Item color="gray-2">
              <List.Indicator asChild color="primary">
                <FaRegCheckCircle />
              </List.Indicator>
              {t("purchasesAndPaymentsParagraph3")}
            </List.Item>
          </List.Root>
        </VStack>
        {/* 4 warranties */}
        <VStack
          align={"stretch"}
          gap="24px"
          p={{ base: "18px", md: "48px" }}
          position={"relative"}
          flexWrap={"wrap"}
          _before={{
            w: "4px",
            h: "70%",
            bg: "primary",
            content: '""',
            rounded: "2px",
            position: "absolute",
          }}
        >
          <Heading fontSize={"24px"} fontWeight={"bold"} ps={"20px"}>
            4. {t("warranties")}
          </Heading>
          <Text color="gray-2" maxW="690px" ps="20px">
            {t("warrantiesDescription")}
          </Text>
          <HStack gap={"8px"} ms={{ md: "30%" }}>
            <Box
              p={"8px 16px"}
              rounded="12px"
              bg="gray-4"
              fontSize={"12px"}
              color={"gray-2"}
              fontWeight={"bold"}
            >
              {t("trafficAccidents")}
            </Box>
            <Box
              p={"8px 16px"}
              rounded="12px"
              bg="gray-4"
              fontSize={"12px"}
              color={"gray-2"}
              fontWeight={"bold"}
            >
              {t("misuse")}
            </Box>
            <Box
              p={"8px 16px"}
              rounded="12px"
              bg="gray-4"
              fontSize={"12px"}
              color={"gray-2"}
              fontWeight={"bold"}
            >
              {t("incorrectInstallation")}
            </Box>
            <Box
              p={"8px 16px"}
              rounded="12px"
              bg="gray-4"
              fontSize={"12px"}
              color={"gray-2"}
              fontWeight={"bold"}
            >
              {t("improperStorage")}
            </Box>
          </HStack>
        </VStack>
        {/* 5 limitationOfLiability */}
        <VStack
          align={"stretch"}
          gap="24px"
          bg="black"
          p={{ base: "18px", md: "48px" }}
          rounded={"12px"}
          color={"white"}
        >
          <Heading
            fontSize={"24px"}
            fontWeight={"bold"}
            position={"relative"}
            color="primary"
            ps={"20px"}
            _before={{
              w: "4px",
              h: "24px",
              ...(locale === "ar" ? { right: "0" } : { left: "0" }),
              bg: "primary",
              content: '""',
              rounded: "2px",
              position: "absolute",
            }}
          >
            5. {t("limitationOfLiability")}
          </Heading>
          <Text maxW="690px">{t("limitationOfLiabilityParagraph1")}</Text>
          <Text maxW="690px">{t("limitationOfLiabilityParagraph2")}</Text>
        </VStack>
        <Text color={"gray-2"} textAlign={"center"} mt="44px">
          {t("lastUpdated")}
        </Text>
        {/* <Button alignSelf={"center"} p="12px 32px" rounded={"12px"}>
          {t("downloadPdf")}
        </Button> */}
      </VStack>
    </Container>
  );
}
