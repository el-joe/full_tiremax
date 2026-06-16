import React from "react";
import { MdOutlineTouchApp } from "react-icons/md";
import { IoCalendarOutline, IoCarOutline } from "react-icons/io5";
import { GoShieldCheck } from "react-icons/go";
import { Center, Heading, HStack, Icon, Text, VStack } from "@chakra-ui/react";
import { getTranslations } from "next-intl/server";

const serviceStepsData = [
  {
    id: 1,
    icon: MdOutlineTouchApp,
    name: "chooseService",
    description: "chooseServiceDescription",
  },
  {
    id: 2,
    icon: IoCalendarOutline,
    name: "scheduleAppointment",
    description: "scheduleAppointmentDescription",
  },
  {
    id: 3,
    icon: IoCarOutline,
    name: "visitServiceCenter",
    description: "visitServiceCenterDescription",
  },
  {
    id: 4,
    icon: GoShieldCheck,
    name: "pickUpVehicle",
    description: "pickUpVehicleDescription",
  },
];

export default async function ServiceSteps() {
  const t = await getTranslations("services");
  return (
    <VStack
      gap={{ base: "22px", lg: "44px", xl: "64px" }}
      align={"stretch"}
      textAlign={"center"}
      bg={"#F9FAFBCC"}
      py={{ base: "22px", lg: "34px", xl: "80px" }}
      roundedTop={"48px"}
      px={{ base: "4px", md: "12px", lg: "24px" }}
    >
      <Heading
        fontSize={{ base: "18px", md: "22px", xl: "30px" }}
        fontWeight={"black"}
      >
        {t("serviceJourneyTitle")}
      </Heading>
      <HStack justify={"space-between"} align={"start"} gap={{ base: "4px" }}>
        {serviceStepsData.map((step) => (
          <VStack key={step.id} flex={1}>
            <Center
              minW={{ base: "32px", lg: "80px" }}
              h={{ base: "32px", lg: "80px" }}
              rounded={"12px"}
              bg={"primary"}
            >
              <Icon size={{ base: "md", lg: "2xl" }} color={"white"}>
                <step.icon />
              </Icon>
            </Center>
            <Text
              fontSize={{ base: "12px", md: "16px", lg: "20px" }}
              fontWeight={"black"}
            >
              {t(step.name)}
            </Text>
            <Text
              color={"gray-2"}
              fontSize={{ base: "9px", md: "12px", lg: "16px" }}
            >
              {t(step.description)}
            </Text>
          </VStack>
        ))}
      </HStack>
    </VStack>
  );
}
