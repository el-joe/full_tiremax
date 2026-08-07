import { LeftArrowIcon, PlayCircleIcon } from "@/components/Icons";
import {
  Box,
  Button,
  Container,
  HStack,
  Span,
  Text,
  VStack,
} from "@chakra-ui/react";
import { getLocale, getTranslations } from "next-intl/server";
import React from "react";
import TabsFilterBy from "../../shared/TabsFilterBy";
import { Link } from "@/i18n/navigation";

const HeroSection = async () => {
  const t = await getTranslations("home");
  const local = await getLocale();
  return (
    <Container
      rounded={"50px"}
      overflow={"hidden"}
      pt={{ base: "22px", md: "43px", xl: "83px" }}
      pb={"22px"}
      zIndex={1}
    >
      <Box
        bgSize={"cover"}
        bgImage={"url(/images/heroBg.png)"}
        position={"absolute"}
        inset={0}
        zIndex={-1}
      >
        <Box
          className={`inset-0 absolute ${local === "en" ? "bg-linear-to-r" : "bg-linear-to-l"} from-black via-black/40 to-black/0`}
        />
      </Box>
      <VStack
        gap={{ base: "18px", md: "28px", xl: "39px" }}
        alignItems={"start"}
        maxW={"575px"}
        mb={{ base: "44px", md: "70px", xl: "120px", "2xl": "156px" }}
      >
        <Text
          fontSize={
            local === "en"
              ? { base: "48px", md: "65px", xl: "75px" }
              : { base: "52px", sm: "72px", md: "90px", "2xl": "123px" }
          }
          fontWeight={"800"}
          color={"white"}
          lineHeight={
            local === "en"
              ? { base: "48px", md: "75px", xl: "85px" }
              : { base: "84px", md: "104px", "2xl": "144px" }
          }
        >
          {t("controlStartsWith")}{" "}
          <Span color={"primary"}>{t("theRightTire")}</Span>
        </Text>
        <Text
          fontSize={{ base: "14px", md: "16px", xl: "20px" }}
          color={"white"}
          maxW={"530px"}
        >
          {t(
            "shop,book,andInstall—allInOnePlace,PoweredByTheLatestGlobalTireServiceTechnologies",
          )}
        </Text>
        <HStack gap={{ base: "8px", md: "12px", xl: "16px" }}>
          <Button
            variant={"outline"}
            fontSize={{ base: "14px", xl: "18px" }}
            py={{ base: "15px", xl: "20pxx" }}
            px={{ base: "6px", md: "15px", xl: "" }}
            h={"auto"}
          >
            {t("watchVideo")}
            <PlayCircleIcon />
          </Button>
          <Link href={"/store"}>
            <Button
              fontSize={{ base: "14px", xl: "18px" }}
              py={{ base: "15px", xl: "20pxx" }}
              px={{ base: "6px", md: "15px", xl: "" }}
              h={"auto"}
            >
              {t("chooseYourTireNow")}
              <LeftArrowIcon rotate={local === "en" ? "180deg" : ""} />
            </Button>
          </Link>
        </HStack>
      </VStack>
      <TabsFilterBy showButton />
    </Container>
  );
};

export default HeroSection;
