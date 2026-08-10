import NotificationsList from "@/components/pages/notifications/NotificationsList";
import { IApiMetaRes, INotification } from "@/types";
import axiosInstance from "@/utils/axiosInstance";

export default async function page() {
  const { data: notificationsData } = await axiosInstance<{
    data: INotification[];
    meta: IApiMetaRes;
  }>("notifications");
  return (
    <NotificationsList initialNotifications={notificationsData.data} />
  );
}
