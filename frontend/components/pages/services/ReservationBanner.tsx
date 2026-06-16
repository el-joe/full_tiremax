import { Box, Button, Heading, Image, Text, VStack } from "@chakra-ui/react";
import { getTranslations } from "next-intl/server";
import React from "react";

export default async function ReservationBanner() {
  const t = await getTranslations("services");
  return (
    <VStack
      h={{ base: "320px", md: "561px" }}
      flex="1"
      position={"relative"}
      overflow={"hidden"}
      zIndex={1}
      //   p="32px"
      color={"white"}
      mx={{ base: "-16px", lg: "-120px" }}
      mb={{ base: "-24px", lg: "-80px" }}
      justify={"center"}
      gap={{ base: "12px", md: "32px" }}
      textAlign={"center"}
    >
      <Image
        src={"/images/servicesReserveBanner.png"}
        alt="bg"
        position={"absolute"}
        inset={"0"}
        h="full"
        w={"full"}
        zIndex={-1}
      />
      <Box position={"absolute"} inset="0" bg="#00000099" zIndex={-1} />
      <Heading
        fontSize={{ base: "24px", md: "60px" }}
        fontWeight={"extrabold"}
        maxW={{ base: "200px", md: "600px" }}
        lineHeight={{ base: "24px", md: "60px" }}
      >
        {t("ctaTitle")}
      </Heading>
      <Text
        fontSize={{ base: "14px", md: "20px" }}
        color={"#D1D5DB"}
        maxW={"665px"}
      >
        {t("ctaDescription")}
      </Text>
      <Button
        h={"72px"}
        w={"290px"}
        boxShadow={"0 25px 50px -12px #FFB80066"}
        fontSize={"18px"}
        fontWeight={"black"}
      >
        {t("bookYourAppointmentNow")}
      </Button>
    </VStack>
  );
}

// "": "Ready to Keep Your Vehicle in Top Condition?",
// "": "Don't wait for a breakdown. Book your service appointment today and enjoy peace of mind and safer driving on the road.",
//  "": "Book Your Appointment Now"
