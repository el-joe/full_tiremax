import {
  Box,
  Button,
  Container,
  Heading,
  HStack,
  Image,
  Text,
  VStack,
} from "@chakra-ui/react";
import { getTranslations } from "next-intl/server";
import React from "react";
import {
  CalenderIcon,
  FacebookLogoIcon,
  InstagramLogoIcon,
  LocationPinIcon,
  PhoneSignalIcon,
  WhatsappLogoIcon,
} from "../Icons";
import { Link } from "@/i18n/navigation";
import type { PublicSettings } from "@/helpers/getPublicSettings";

const Footer = async ({ settings }: { settings?: PublicSettings | null }) => {
  const t = await getTranslations("footer");
  return (
    <Container px={"46px"} pt="80px" pb={"32px"} color={"white"}>
      <HStack justify={"space-between"} align={"start"} flexWrap="wrap">
        <Box>
          <Image src="/images/logo.svg" mb={"16px"} alt="logo" />
          <Text fontSize={"14px"} maxW={"315px"}>
            {t("footerCompanyDescription")}
          </Text>
          <HStack px="24px" gap="24px" py={"10px"}>
            {(settings?.whatsapp_url ?? true) && (
              <a href={settings?.whatsapp_url ?? "#"} target="_blank" rel="noopener noreferrer" aria-label="WhatsApp">
                <WhatsappLogoIcon size={"xl"} />
              </a>
            )}
            {(!settings || settings.social?.facebook) && (
              <a href={settings?.social?.facebook ?? "#"} target="_blank" rel="noopener noreferrer" aria-label="Facebook">
                <FacebookLogoIcon size={"xl"} />
              </a>
            )}
            {(!settings || settings.social?.instagram) && (
              <a href={settings?.social?.instagram ?? "#"} target="_blank" rel="noopener noreferrer" aria-label="Instagram">
                <InstagramLogoIcon size={"xl"} />
              </a>
            )}
          </HStack>
        </Box>
        <Box>
          <Heading as={"h4"} fontSize={"16px"} fontWeight={"bold"} mb={"16px"}>
            {t("quickLinks")}
          </Heading>
          <VStack
            align={"start"}
            color={"#CBCBCB"}
            fontSize={"14px"}
            gap={"8px"}
          >
            <Link href={"/"}>
              <Text _hover={{ color: "white" }}> {t("home")}</Text>
            </Link>
            <Link href={"/services"}>
              <Text _hover={{ color: "white" }}> {t("aboutUs")}</Text>
            </Link>
            <Link href={"/store"}>
              <Text _hover={{ color: "white" }}> {t("store")}</Text>
            </Link>
            <Link href={"/offers"}>
              <Text _hover={{ color: "white" }}> {t("offers")}</Text>
            </Link>
            <Link href={"/track-order"}>
              <Text _hover={{ color: "white" }}> {t("trackOrder")}</Text>
            </Link>
          </VStack>
        </Box>
        <Box>
          <Heading as={"h4"} fontSize={"16px"} fontWeight={"bold"} mb={"16px"}>
            {t("services")}
          </Heading>
          <VStack
            align={"start"}
            color={"#CBCBCB"}
            fontSize={"14px"}
            gap={"8px"}
          >
            <Link href={"/services"}>
              <Text _hover={{ color: "white" }}> {t("batteries")}</Text>
            </Link>
            <Link href={"/services"}>
              <Text _hover={{ color: "white" }}> {t("tires")}</Text>
            </Link>
            <Link href={"/services"}>
              <Text _hover={{ color: "white" }}> {t("serviceCenter")}</Text>
            </Link>
          </VStack>
        </Box>
        <Box fontSize={"14px"}>
          <Heading as={"h4"} fontSize={"16px"} fontWeight={"bold"}>
            {t("contactUs")}
          </Heading>
          <Link href={`tel:${settings?.site_phone ?? "+964 770 000 0000"}`}>
            <HStack gap={"12px"} color={"#CBCBCB"} my={"16px"}>
              <PhoneSignalIcon color={"primary"} size={"sm"} />
              <Text dir="ltr">{settings?.site_phone ?? "+964 770 000 0000"}</Text>
            </HStack>
          </Link>
          <HStack gap={"12px"} color={"#CBCBCB"}>
            <LocationPinIcon size={"sm"} color={"primary"} />
            <Text>{settings?.address || t("footerAddress")}</Text>
          </HStack>
        </Box>
        <Box fontSize={"14px"} maxW={"337px"}>
          <Heading as={"h4"} fontSize={"16px"} fontWeight={"bold"}>
            {t("serviceBooking")}
          </Heading>
          <Text color={"#CBCBCB"} my={"16px"}>
            {t("footerServiceBookingDescription")}
          </Text>
          <Link href={"/services/reservation"}>
            <Button>
              {t("bookYourAppointmentNow")}
              <CalenderIcon />
            </Button>
          </Link>
        </Box>
      </HStack>
      <Box h={"1px"} bg={"white"} w={"97%"} mx={"auto"} my={"61px"} />
      <HStack justify={"space-around"}>
        <Link href={"/privacy-policy"}>
          <Text color={"gray-2"} fontSize={"14px"} _hover={{ color: "white" }}>
            {t("privacyPolicy")}
          </Text>
        </Link>
        <Text color={"gray-2"} fontSize={"14px"}>
          {t("allRightsReserved")}
        </Text>
        <Link href={"/termsAndConditions"}>
          <Text color={"gray-2"} fontSize={"14px"} _hover={{ color: "white" }}>
            {t("termsAndConditions")}
          </Text>
        </Link>
      </HStack>
    </Container>
  );
};

export default Footer;
