import Container from "@/components/ui/Container";
import { Link } from "@/i18n/navigation";
import {
  Box,
  Grid,
  GridItem,
  Heading,
  Image,
  Text,
  VStack,
} from "@chakra-ui/react";
import { getTranslations } from "next-intl/server";
import React from "react";

const BannersGridSection = async () => {
  const t = await getTranslations("home");
  return (
    <Container>
      <Grid
        templateColumns={{ base: "repeat(1, 1fr)", md: "repeat(7, 1fr)" }}
        gap={{ base: "12px", md: "17px", xl: "24px", "2xl": "31px" }}
      >
        <GridItem colSpan={{ base: 3, md: 4, lg: 3 }}>
          <VStack alignItems={"stretch"} gap={"31px"}>
            <Box>
              <Heading
                as="h2"
                fontSize={"28px"}
                fontWeight={"bold"}
                mb={"32px"}
              >
                {t("allInOneSolutionsForYourVehicle")}
              </Heading>
              <Text fontSize={"18px"}>
                {t(
                  "findEverythingYourVehicleNeedsInOnePlace,FromPremiumTiresAndDependableBatteriesToExpertMaintenanceAndInstallationServices",
                )}
              </Text>
            </Box>
            <Box
              rounded={"20px"}
              overflow={"hidden"}
              position={"relative"}
              h={"258px"}
            >
              <Image
                src={"/images/maintenanceServicesBg.jpg"}
                alt="bg"
                objectFit={"cover"}
                position="absolute"
                inset={0}
                w={"full"}
                h="full"
              />
              <Link
                href={"/services"}
                className="bg-white absolute bottom-4 left-4 p-2.5! rounded-[10px]"
              >
                {t("maintenanceServices")}
              </Link>
            </Box>
          </VStack>
        </GridItem>
        <GridItem colSpan={{ base: 3, lg: 2 }}>
          <Box
            rounded={"20px"}
            overflow={"hidden"}
            position={"relative"}
            h={"full"}
            minH={"185px"}
          >
            <Image
              src={"/images/bookAtTheCenterBg.jpg"}
              alt="bg"
              objectFit={"cover"}
              position="absolute"
              inset={0}
              w={"full"}
              h="full"
            />
            <Link
              href={"/services"}
              className="bg-white absolute bottom-4 left-4 p-2.5! rounded-[10px]"
            >
              {t("maintenanceServices")}
            </Link>
          </Box>
        </GridItem>
        <GridItem colSpan={{ base: 3, md: 7, lg: 2 }}>
          <VStack
            alignItems={"stretch"}
            gap={{ base: "12px", md: "17px", xl: "24px", "2xl": "31px" }}
            h="full"
            flexDir={{ base: "row", lg: "column" }}
          >
            <Box
              flex={1}
              rounded={"20px"}
              overflow={"hidden"}
              position={"relative"}
              h="calc(100% - 31px / 2)"
              minH={"185px"}
            >
              <Image
                src={"/images/battaryInstallationBg.jpg"}
                alt="bg"
                objectFit={"cover"}
                position="absolute"
                inset={0}
                w={"full"}
                h="full"
              />
              <Link
                href={"/services"}
                className="bg-white absolute bottom-4 left-2 md:left-4 p-1! md:p-2.5! rounded-[10px] text-sm! md:text-base!"
              >
                {t("batteryInstallation")}
              </Link>
            </Box>
            <Box
              flex={1}
              rounded={"20px"}
              overflow={"hidden"}
              position={"relative"}
              h="calc(100% - 31px / 2)"
              minH={"185px"}
            >
              <Image
                src={"/images/tireInstallationBg.jpg"}
                alt="bg"
                objectFit={"cover"}
                position="absolute"
                inset={0}
                w={"full"}
                h="full"
              />
              <Link
                href={"/services"}
                className="bg-white absolute bottom-4 left-2 md:left-4 p-1! md:p-2.5! rounded-[10px] text-sm! md:text-base!"
              >
                {t("tireInstallation")}
              </Link>
            </Box>
          </VStack>
        </GridItem>
      </Grid>
    </Container>
  );
};

export default BannersGridSection;
