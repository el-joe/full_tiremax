import FeaturesSection from "@/components/pages/services/FeaturesSection";
import ReservationBanner from "@/components/pages/services/ReservationBanner";
import ServicesList from "@/components/pages/services/ServicesList";
import ServiceSteps from "@/components/pages/services/ServiceSteps";
import WhyChoose from "@/components/pages/services/WhyChoose";
import Container from "@/components/ui/Container";
import { IService } from "@/types";
import axiosInstance from "@/utils/axiosInstance";
import { Box, Heading, Text, VStack } from "@chakra-ui/react";
import { getTranslations } from "next-intl/server";

export default async function page() {
  const t = await getTranslations("services");
  const { data: services } = await axiosInstance<{ data: IService[] }>(
    "services",
  );
  return (
    <Container px={"120px"}>
      <VStack
        textAlign={"center"}
        mx={"auto"}
        maxW={"680px"}
        gap={"16px"}
        mb={"88px"}
      >
        <Heading fontSize={"34px"} fontWeight={"bold"}>
          {t("completeVehicleServices")}
        </Heading>
        <Text fontSize={"18px"}>{t("completeVehicleServicesDescription")}</Text>
      </VStack>
      <ServicesList services={services.data} />
      <ServiceSteps />
      <WhyChoose />
      <FeaturesSection />
      <ReservationBanner />
    </Container>
  );
}
