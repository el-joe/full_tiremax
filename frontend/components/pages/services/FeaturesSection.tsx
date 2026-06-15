import {
  Badge,
  Box,
  Center,
  Heading,
  Highlight,
  HStack,
  Icon,
  Image,
  Text,
  VStack,
} from "@chakra-ui/react";
import { getLocale, getTranslations } from "next-intl/server";
import React from "react";
import { IconType } from "react-icons/lib";
import {
  MdOutlineHandshake,
  MdOutlineStars,
  MdOutlineSupportAgent,
  MdOutlineVerified,
} from "react-icons/md";
import { HiOutlineBellAlert } from "react-icons/hi2";
import { LuShieldPlus } from "react-icons/lu";

const features = [
  {
    id: 1,
    icon: HiOutlineBellAlert,
    title: "smartReminders",
    description: "smartRemindersDescription",
  },
  {
    id: 2,
    icon: MdOutlineSupportAgent,
    title: "technicalSupport247",
    description: "technicalSupport247Description",
  },
  {
    id: 3,
    icon: LuShieldPlus,
    title: "freeInspections",
    description: "freeInspectionsDescription",
  },
  {
    id: 4,
    icon: MdOutlineVerified,
    title: "extendedWarranty",
    description: "extendedWarrantyDescription",
  },
];

export default async function FeaturesSection() {
  const t = await getTranslations("services");
  const locale = await getLocale();
  return (
    <HStack gap="32px" py={"96px"} align={"start"}>
      <VStack gap={"24px"} flex={"1"} align={"stretch"} justify={"start"}>
        <Badge
          bg={"#FFB8001A"}
          color={"primary"}
          px="16px"
          py={"8px"}
          rounded={"16px"}
          w={"fit"}
          fontWeight={"bold"}
        >
          <MdOutlineHandshake />
          {t("dedicatedSupport")}
        </Badge>
        <Heading
          maxW={"286px"}
          fontSize={locale === "ar" ? "48px" : "28px"}
          lineHeight={"48px"}
        >
          <Highlight
            query={[t("dedicatedSupportDescriptionHighlight")]}
            styles={{ color: "primary" }}
          >
            {t("dedicatedSupportDescription")}
          </Highlight>
        </Heading>
        <Text fontSize={"20px"} color={"gray-2"}>
          {t("customerCareDescription")}
        </Text>
        <HStack flexWrap={"wrap"} gap={"32px"}>
          {features.map((feature) => (
            <FeatureCard key={feature.id} feature={feature} />
          ))}
        </HStack>
      </VStack>
      <Box position="relative">
        <Image src={"/images/servicesFeatureSectionImage.png"} alt="bg" />
        <HStack
          minW={"172px"}
          px={"8px"}
          h={"98px"}
          bg={"white"}
          boxShadow={"0 25px 50px -12px #00000040"}
          rounded={"24px"}
          position={"absolute"}
          bottom={"-10px"}
          justify={"center"}
        >
          <Center minW={"48px"} h={"48px"} bg="primary" rounded={"full"}>
            <Icon size={"lg"} color={"white"}>
              <MdOutlineStars />
            </Icon>
          </Center>
          <Box>
            <Text fontSize={"12px"} fontWeight={"bold"} color={"gray-2"}>
              {t("customerSatisfaction")}
            </Text>
            <Text fontSize={"24px"} fontWeight={"black"}>
              100%
            </Text>
          </Box>
        </HStack>
      </Box>
    </HStack>
  );
}

const FeatureCard = async ({
  feature,
}: {
  feature: { icon: IconType; title: string; description: string };
}) => {
  const t = await getTranslations("services");
  return (
    <HStack minW={"calc((100% - 32px) / 2)"} flex={1}>
      <Center minW={"48px"} h={"48px"} bg="gray-4" rounded={"16px"}>
        <Icon size={"lg"} color={"primary"}>
          <feature.icon />
        </Icon>
      </Center>
      <Box>
        <Heading fontSize={"18px"} fontWeight={"bold"}>
          {t(feature.title)}
        </Heading>
        <Text fontSize={"14px"} color="gray-2">
          {t(feature.description)}
        </Text>
      </Box>
    </HStack>
  );
};
