import React from "react";
import { MdOutlineSpeed } from "react-icons/md";
import { GoShieldCheck } from "react-icons/go";
import { Center, Heading, HStack, Icon, Text, VStack } from "@chakra-ui/react";
import { getTranslations } from "next-intl/server";
import { FaRegCircleDot } from "react-icons/fa6";
import { FaToolbox } from "react-icons/fa";

const serviceStepsData = [
  {
    id: 1,
    icon: FaRegCircleDot,
    name: "certifiedExperts",
    description: "certifiedExpertsDescription",
  },
  {
    id: 2,
    icon: GoShieldCheck,
    name: "advancedEquipment",
    description: "advancedEquipmentDescription",
  },
  {
    id: 3,
    icon: MdOutlineSpeed,
    name: "fastTurnaround",
    description: "fastTurnaroundDescription",
  },
  {
    id: 4,
    icon: FaToolbox,
    name: "serviceWarranty",
    description: "serviceWarrantyDescription",
  },
  {
    id: 4,
    icon: GoShieldCheck,
    name: "exceptionalPrecision",
    description: "exceptionalPrecisionDescription",
  },
];

export default async function WhyChoose() {
  const t = await getTranslations("services");
  return (
    <VStack
      gap={{ base: "22px", md: "42px", lg: "80px" }}
      align={"stretch"}
      textAlign={"center"}
      py={{ base: "22px", md: "66px", lg: "128px" }}
      borderY={"1px solid #E4E4E7"}
    >
      <Heading fontSize={"30px"} fontWeight={"black"}>
        {t("whyChooseTireMax")}
      </Heading>
      <HStack justify={"space-between"} align={"start"} gap={{ base: "4px" }}>
        {serviceStepsData.map((step) => (
          <VStack key={step.id} flex={1}>
            <Center
              minW={{ base: "32px", lg: "80px" }}
              h={{ base: "32px", lg: "80px" }}
              rounded={"12px"}
              bg={"#F9FAFB"}
            >
              <Icon size={{ base: "md", lg: "2xl" }} color={"primary"}>
                <step.icon />
              </Icon>
            </Center>
            <Text
              fontSize={{ base: "10px", md: "14px", lg: "18px" }}
              fontWeight={"black"}
            >
              {t(step.name)}
            </Text>
            <Text
              fontSize={{ base: "8px", md: "10px", lg: "14px" }}
              color={"gray-2"}
            >
              {t(step.description)}
            </Text>
          </VStack>
        ))}
      </HStack>
    </VStack>
  );
}
