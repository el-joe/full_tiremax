import { Box, Heading, HStack, Text } from "@chakra-ui/react";
import { getTranslations } from "next-intl/server";
import React from "react";

export default async function SettingsHeader() {
  const t = await getTranslations("profile");
  return (
    <HStack
      justify={"space-between"}
      p="24px"
      border={"1px solid #E5E7EB"}
      rounded={"16px"}
      shadow={"0 1px 2px -1px #0000001A, 0 1px 3px 0px #0000001A"}
    >
      <Box>
        <Heading pb={"8px"} fontSize={"30px"} fontWeight={"bold"}>
          {t("accountSettings")}
        </Heading>
        <Text color={"gray-2"}>{t("accountSettingsDescription")}</Text>
      </Box>
    </HStack>
  );
}
