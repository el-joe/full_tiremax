import {
  Box,
  Container,
  Heading,
  Highlight,
  HStack,
  Image,
  RatingGroup,
  Text,
  VStack,
} from "@chakra-ui/react";
import { getTranslations } from "next-intl/server";
import React from "react";

const WhyUsSection = async () => {
  const t = await getTranslations("home");
  return (
    <Container py="80px" color={"white"}>
      <Heading
        textAlign={"center"}
        fontSize={"36px"}
        fontWeight={"bold"}
        mb={"64px"}
      >
        <Highlight query={t("tireMax")} styles={{ color: "primary" }}>
          {t("whyChooseTireMax")}
        </Highlight>
      </Heading>
      <HStack gap={{ base: "12px", md: "16px", xl: "24px" }} flexWrap={"wrap"}>
        <WhyUsCart
          bg="/images/whyUsBg1.png"
          heading={t("genuineWarranty")}
          text={t("genuineWarrantyDescription")}
        />
        <WhyUsCart
          bg="/images/whyUsBg2.jpg"
          heading={t("routineMaintenance")}
          text={t("genuineWarrantyDescription")}
        />
        <WhyUsCart
          bg="/images/whyUsBg3.jpg"
          heading={t("quickTurnaround")}
          text={t("fastServiceDescription")}
        />
      </HStack>
      {/* testimonial */}
      <VStack mt={"120px"} mb={"64px"} gap={"16px"}>
        <Heading textAlign={"center"} fontSize={"36px"} fontWeight={"bold"}>
          {t("whatOurCustomersSay")}
        </Heading>
        <RatingGroup.Root
          readOnly
          colorPalette={"yellow"}
          count={5}
          defaultValue={5}
          size="lg"
        >
          <RatingGroup.HiddenInput />
          <RatingGroup.Control />
        </RatingGroup.Root>
      </VStack>
      <HStack
        gap={{ base: "12px", md: "18px", xl: "30px" }}
        flexWrap={"wrap"}
        alignItems={"stretch"}
      >
        <ReviewCard
          name={t("testimonialName1")}
          address={t("testimonialCity1")}
          avatar="/images/testimonialUserAvatar.jpg"
          content={t("testimonial1")}
        />
        <ReviewCard
          name={t("testimonialName2")}
          address={t("testimonialCity2")}
          avatar="/images/testimonialUserAvatar.jpg"
          content={t("testimonial2")}
        />
        <ReviewCard
          name={t("testimonialName3")}
          address={t("testimonialCity3")}
          avatar="/images/testimonialUserAvatar.jpg"
          content={t("testimonial3")}
        />
      </HStack>
    </Container>
  );
};

export default WhyUsSection;

const WhyUsCart = ({
  bg,
  heading,
  text,
}: {
  bg: string;
  heading: string;
  text: string;
}) => (
  <VStack
    h={{ base: "180px", md: "240px", xl: "334px" }}
    minW={"260px"}
    flex="1"
    position={"relative"}
    rounded="48px"
    overflow={"hidden"}
    zIndex={1}
    justifyContent={"end"}
    alignItems={"start"}
    p="32px"
  >
    <Image
      src={bg}
      alt="bg"
      position={"absolute"}
      inset={"0"}
      h="full"
      w={"full"}
      zIndex={-1}
      opacity={"40%"}
    />
    <Box position={"absolute"} inset="0" bg="#353534" zIndex={-2} />
    <Heading fontSize={"24px"} fontWeight={"semibold"}>
      {heading}
    </Heading>
    <Text fontSize={"14px"}>{text}</Text>
  </VStack>
);

const ReviewCard = ({
  name,
  address,
  avatar,
  content,
}: {
  name: string;
  address: string;
  avatar: string;
  content: string;
}) => (
  <Box
    p={{ base: "12px", md: "20px", xl: "32px" }}
    flex="1"
    bg="white"
    color={"black"}
    rounded={"24px"}
  >
    <HStack mb={"24px"} justifyContent={"space-between"} minW={"260px"}>
      <Box>
        <Heading fontSize={"16px"} fontWeight={"semibold"}>
          {name}
        </Heading>
        <Text fontSize={"12px"}>{address}</Text>
      </Box>
      <Image
        src={avatar}
        alt="avatar"
        w="48px"
        h={"48px"}
        rounded={"12px"}
        outline={"2px solid {colors.primary}"}
        outlineOffset={"1px"}
      />
    </HStack>
    <Text color={"gray-2"} fontSize={{ base: "9px", md: "12px", lg: "16px" }}>
      &quot;{content}&quot;
    </Text>
  </Box>
);
