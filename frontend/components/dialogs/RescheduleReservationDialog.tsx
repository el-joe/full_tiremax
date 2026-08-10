"use client";
import React from "react";
import Dialog from "../ui/Dialog";
import { useDialog, Button, HStack, Text, Heading } from "@chakra-ui/react";

import { useTranslations } from "next-intl";
import useDir from "@/hooks/useDir";
import { useMutation } from "@tanstack/react-query";
import axiosInstance from "@/utils/axiosInstance";
import { AxiosError } from "axios";
import toast from "react-hot-toast";
import { useRouter } from "@/i18n/navigation";
import { IReservation } from "@/types";

type props = {
  trigger: React.ReactNode;
  reservation: IReservation;
};

export default function RescheduleReservationDialog({
  trigger,
  reservation,
}: props) {
  const dir = useDir();
  const dialog = useDialog();
  const router = useRouter();
  const t = useTranslations("profile");
  const { mutate: mutateCancelBooking, isPending: isRescheduling } =
    useMutation({
      mutationKey: ["cancelBooking", reservation.id],
      mutationFn: async (id: number) => {
        const { data } = await axiosInstance.post(`bookings/${id}/cancel`);
        return data;
      },
      onSuccess: () => {
        dialog.setOpen(false);
        router.push(
          `/services/reservation?service_id=${reservation.service.id}&branch_id=${reservation.branch.id}`,
        );
      },
      onError: (err: AxiosError<{ message?: string }>) => {
        if (err.status === 401) return;
        const errorMessage =
          err.response?.data?.message ?? "Oops! something went wrong";
        toast.error(errorMessage);
      },
    });
  const handleReschedule = () => {
    mutateCancelBooking(reservation.id);
  };

  return (
    <Dialog
      value={dialog}
      placement={"center"}
      closeIconButton
      trigger={trigger}
    >
      <div dir={dir}>
        <Heading size="md" mb={3}>
          {t("rescheduleBooking")}
        </Heading>
        <Text mb={4}>{t("rescheduleBookingWarning")}</Text>
        <HStack justifyContent="flex-end">
          <Button onClick={() => dialog.setOpen(false)}>
            {t("keepBooking")}
          </Button>
          <Button
            bg="primary"
            onClick={handleReschedule}
            loading={isRescheduling}
          >
            {t("continue")}
          </Button>
        </HStack>
      </div>
    </Dialog>
  );
}
