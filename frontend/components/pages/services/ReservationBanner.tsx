import { Box, Button, Heading, Image, Text, VStack } from "@chakra-ui/react";
import { getTranslations } from "next-intl/server";
import React from "react";

export default async function ReservationBanner() {
  const t = await getTranslations("services");
  return (
    <VStack
      h={{ base: "180px", md: "240px", xl: "561px" }}
      flex="1"
      position={"relative"}
      overflow={"hidden"}
      zIndex={1}
      p="32px"
      color={"white"}
      mx={"-120px"}
      mb={"-80px"}
      justify={"center"}
      gap={"32px"}
      textAlign={"center"}
    >
      <Image
        src={"/images/servicesReserveBanner.png"}
        alt="bg"
        position={"absolute"}
        // filter={"grayscale(1)"}
        inset={"0"}
        h="full"
        w={"full"}
        zIndex={-1}
        // opacity={"40%"}
      />
      <Box position={"absolute"} inset="0" bg="#00000099" zIndex={-1} />
      <Heading
        fontSize={"60px"}
        fontWeight={"extrabold"}
        maxW={"600px"}
        lineHeight={"60px"}
      >
        {t("ctaTitle")}
      </Heading>
      <Text fontSize={"20px"} color={"#D1D5DB"} maxW={"665px"}>
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
