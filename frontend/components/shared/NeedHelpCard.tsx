"use server";
import { Link } from "@/i18n/navigation";
import { Button, Heading, Icon, Text, VStack } from "@chakra-ui/react";
import { getLocale, getTranslations } from "next-intl/server";
import React from "react";
import { FaArrowLeft } from "react-icons/fa";
import { FaArrowRight } from "react-icons/fa6";
import { MdOutlineSupportAgent } from "react-icons/md";

const NeedHelpCard = async () => {
  const t = await getTranslations("cartAndPayment");
  const locale = await getLocale();
  return (
    <VStack
      p={"24px"}
      rounded={"8px"}
      bg="#1A1C1C"
      gap="8px"
      align={"start"}
      color={"white"}
      maxW={"full"}
      position={"relative"}
    >
      <Heading fontSize={"18px"} fontWeight={"bold"}>
        {t("needHelp")}
      </Heading>
      <Text fontSize={"14px"} color={"gray-2"}>
        {t("supportDescription")}
      </Text>
      <Link href={"#"}>
        <Text color={"primary"} pt={"12px"} fontWeight={"bold"}>
          {t("chatWithAnExpert")}
          <Icon ms="8px" size={"lg"}>
            {locale === "ar" ? <FaArrowLeft /> : <FaArrowRight />}
          </Icon>
        </Text>
      </Link>
      <Icon
        w="107px"
        h={"96px"}
        color={"gray-4"}
        opacity={"20%"}
        rotate={locale === "ar" ? "12deg" : "-12deg"}
        position={"absolute"}
        right={locale === "en" ? "-30px" : "unset"}
        left={locale === "ar" ? "-30px" : "unset"}
        bottom={"-30px"}
      >
        <MdOutlineSupportAgent />
      </Icon>
    </VStack>
  );
};

export default NeedHelpCard;
