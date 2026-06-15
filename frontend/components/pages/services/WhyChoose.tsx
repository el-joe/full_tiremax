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
    <VStack gap={"80px"} align={"stretch"} textAlign={"center"} py={"128px"}>
      <Heading fontSize={"30px"} fontWeight={"black"}>
        {t("whyChooseTireMax")}
      </Heading>
      <HStack justify={"space-between"} align={"start"}>
        {serviceStepsData.map((step) => (
          <VStack key={step.id} flex={1}>
            <Center minW="80px" h="80px" rounded={"12px"} bg={"#F9FAFB"}>
              <Icon size={"2xl"} color={"primary"}>
                <step.icon />
              </Icon>
            </Center>
            <Text fontSize={"18px"} fontWeight={"black"}>
              {t(step.name)}
            </Text>
            <Text fontSize={"14px"} color={"gray-2"}>
              {t(step.description)}
            </Text>
          </VStack>
        ))}
      </HStack>
    </VStack>
  );
}
