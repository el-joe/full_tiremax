"use client";
import { useQuery } from "@tanstack/react-query";
import axiosInstance from "@/utils/axiosInstance";
import { useAuthContext } from "@/providers/AuthProvider";

export const NOTIFICATIONS_UNREAD_COUNT_KEY = ["notifications", "unread-count"];

export const useNotifications = () => {
  const { isLogged } = useAuthContext();

  const { data: unreadCount = 0 } = useQuery({
    queryKey: NOTIFICATIONS_UNREAD_COUNT_KEY,
    queryFn: async () => {
      const { data } = await axiosInstance<{ unread_count: number }>(
        "notifications/unread-count",
      );
      return data.unread_count;
    },
    enabled: isLogged,
  });

  return { unreadCount: isLogged ? unreadCount : 0 };
};
