"use client";
import { INotification } from "@/types";
import axiosInstance from "@/utils/axiosInstance";
import { Box, Button, Center, Heading, HStack, Icon, Text } from "@chakra-ui/react";
import { useTranslations } from "next-intl";
import { useMemo, useState } from "react";
import { FaRegBell } from "react-icons/fa";
import { useMutation, useQueryClient } from "@tanstack/react-query";
import toast from "react-hot-toast";
import { AxiosError } from "axios";
import { NOTIFICATIONS_UNREAD_COUNT_KEY } from "@/hooks/useNotifications";

type Props = { initialNotifications: INotification[] };

const NotificationsList = ({ initialNotifications }: Props) => {
  const t = useTranslations("notifications");
  const queryClient = useQueryClient();
  const [notifications, setNotifications] = useState(initialNotifications);
  const hasUnread = useMemo(
    () => notifications.some((n) => !n.read_at),
    [notifications],
  );

  const onError = (err: AxiosError<{ message: string }>) => {
    if (err.status === 401) return;
    const errMes = err?.response?.data?.message ?? "Something went wrong.";
    toast.error(errMes);
  };

  const { mutate: markAsRead } = useMutation({
    mutationFn: async (id: string) => {
      const { data } = await axiosInstance.post<{ message: string }>(
        `notifications/${id}/read`,
      );
      return data;
    },
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: NOTIFICATIONS_UNREAD_COUNT_KEY });
    },
    onError,
  });

  const { mutate: markAllAsRead, isPending: isMarkingAll } = useMutation({
    mutationFn: async () => {
      const { data } = await axiosInstance.post<{ message: string }>(
        "notifications/read-all",
      );
      return data;
    },
    onSuccess: () => {
      const now = new Date().toISOString();
      setNotifications((prev) => prev.map((n) => ({ ...n, read_at: n.read_at ?? now })));
      queryClient.invalidateQueries({ queryKey: NOTIFICATIONS_UNREAD_COUNT_KEY });
    },
    onError,
  });

  const handleClick = (n: INotification) => {
    if (n.read_at) return;
    const now = new Date().toISOString();
    setNotifications((prev) =>
      prev.map((item) => (item.id === n.id ? { ...item, read_at: now } : item)),
    );
    markAsRead(n.id);
  };

  if (!notifications.length) {
    return (
      <Heading textAlign={"center"}>{t("youDontHaveNotifications")}</Heading>
    );
  }

  return (
    <>
      {hasUnread && (
        <Button
          alignSelf={"flex-end"}
          variant={"ghost"}
          onClick={() => markAllAsRead()}
          loading={isMarkingAll}
        >
          {t("markAllAsRead")}
        </Button>
      )}
      {notifications.map((n) => (
        <HStack
          key={n.id}
          p="24px"
          rounded="8px"
          boxShadow={!n.read_at ? "0 12px 24px 0 #1A1C1C0F" : ""}
          gap="24px"
          bg={!!n.read_at ? "gray-4" : "white"}
          cursor={n.read_at ? "default" : "pointer"}
          onClick={() => handleClick(n)}
        >
          <Center w="56px" h="56px" bg="primary" rounded="8px">
            <Icon color={"white"}>
              <FaRegBell />
            </Icon>
          </Center>
          <Box>
            <Heading fontSize="20px" fontWeight={"bold"}>
              {n.title}
            </Heading>
            <Text color="gray">{n.body}</Text>
          </Box>
        </HStack>
      ))}
    </>
  );
};

export default NotificationsList;
