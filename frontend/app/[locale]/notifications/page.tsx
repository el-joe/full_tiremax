import { IApiMetaRes, INotification } from "@/types";
import axiosInstance from "@/utils/axiosInstance";
import { Box, Center, Heading, HStack, Icon, Text } from "@chakra-ui/react";
import { getTranslations } from "next-intl/server";
import { FaRegBell } from "react-icons/fa";

export default async function page() {
  const t = await getTranslations("notifications");
  const { data: notificationsData } = await axiosInstance<{
    data: INotification[];
    meta: IApiMetaRes;
  }>("notifications");
  if (!notificationsData.data.length) {
    return (
      <Heading textAlign={"center"}>{t("youDontHaveNotifications")}</Heading>
    );
  }
  return (
    <>
      {notificationsData.data.map((n) => (
        <HStack
          key={n.id}
          p="24px"
          rounded="8px"
          boxShadow={!n.read_at ? "0 12px 24px 0 #1A1C1C0F" : ""}
          gap="24px"
          bg={!!n.read_at ? "gray-4" : "white"}
        >
          <Center w="56px" h="56px" bg="primary" rounded="8px">
            <Icon color={"white"}>
              <FaRegBell />
            </Icon>
          </Center>
          <Box>
            <Heading fontSize="20px" fontWeight={"bold"}>
              {n.data.title}
            </Heading>
            <Text color="gray">{n.data.body}</Text>
          </Box>
        </HStack>
      ))}
    </>
  );
}
