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
      gap={"64px"}
      align={"stretch"}
      textAlign={"center"}
      bg={"#F9FAFBCC"}
      py={"80px"}
      roundedTop={"48px"}
      px={"24px"}
    >
      <Heading fontSize={"30px"} fontWeight={"black"}>
        {t("serviceJourneyTitle")}
      </Heading>
      <HStack justify={"space-between"} align={"start"}>
        {serviceStepsData.map((step) => (
          <VStack key={step.id} flex={1}>
            <Center minW="80px" h="80px" rounded={"12px"} bg={"primary"}>
              <Icon size={"2xl"} color={"white"}>
                <step.icon />
              </Icon>
            </Center>
            <Text fontSize={"20px"} fontWeight={"black"}>
              {t(step.name)}
            </Text>
            <Text color={"gray-2"}>{t(step.description)}</Text>
          </VStack>
        ))}
      </HStack>
    </VStack>
  );
}
