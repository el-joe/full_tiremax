import NeedHelpCard from "@/components/shared/NeedHelpCard";
import Container from "@/components/ui/Container";
import { Link } from "@/i18n/navigation";
import {
  Box,
  Heading,
  HStack,
  Image,
  Skeleton,
  Text,
  VStack,
} from "@chakra-ui/react";
import { Metadata } from "next";
import { getTranslations } from "next-intl/server";
import React, { Suspense } from "react";

export const metadata: Metadata = {
  title: "notifications",
};

type Props = { children: React.ReactNode };

export default async function layout({ children }: Props) {
  const t = await getTranslations("notifications");

  return (
    <Container>
      <Heading textAlign={"center"} font={"36px"} fontWeight={"extrabold"}>
        {t("notifications")}
      </Heading>
      <Text
        fontSize={"18px"}
        color="gray"
        textAlign={"center"}
        mt="16px"
        mb="48px"
      >
        {t("notificationsHeadingDescription")}
      </Text>
      <VStack gap={"12px"} align={"stretch"}>
        <Suspense
          fallback={Array.from({ length: 4 }).map((e, i) => (
            <Skeleton key={i} h="56px" rounded="12px" />
          ))}
        >
          {children}
        </Suspense>
      </VStack>
      <HStack mt="48px" gap="24px" flexWrap={"wrap"}>
        <Link href={"/store"} className="flex-1">
          <VStack
            rounded={"8px"}
            overflow={"hidden"}
            position={"relative"}
            h={"256px"}
            minH={"185px"}
            align={"start"}
            justify={"end"}
            minW={"300px"}
          >
            <Image
              src={"/images/notifications-banner.png"}
              alt="bg"
              objectFit={"cover"}
              position="absolute"
              inset={0}
              w={"full"}
              h="full"
            />
            <Box position={"relative"} p="24px">
              <Text
                bg="primary"
                color="white"
                p="4px 12px"
                rounded={"8px"}
                w="fit-content"
              >
                {t("bestTiresInIraq")}
              </Text>
              <Heading color={"white"} fontSize={"30px"} my={"16px 8px"}>
                {t("chooseYourPerfectTire")}
              </Heading>
              <Text color={"gray-4"} fontSize={"14px"}>
                {t("chooseYourPerfectTireDescription")}
              </Text>
            </Box>
          </VStack>
        </Link>
        <NeedHelpCard />
      </HStack>
    </Container>
  );
}

//   "bestTiresInIraq": "Best Tires in Iraq",
//   "": "Choose the Right Tire for Iraq's Summer",
//   "": "Carefu
