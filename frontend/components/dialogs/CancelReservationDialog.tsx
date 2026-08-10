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

type props = {
  trigger: React.ReactNode;
  reservationId: number;
  onSuccess?: () => void;
};

export default function CancelReservationDialog({
  trigger,
  reservationId,
  onSuccess,
}: props) {
  const dir = useDir();
  const dialog = useDialog();
  const t = useTranslations("profile");
  //   mutation booking
  const { mutate: mutateCancelBooking, isPending: isCancelingBooking } =
    useMutation({
      mutationKey: ["cancelBooking"],
      mutationFn: async (id: number) => {
        const { data } = await axiosInstance.post(`bookings/${id}/cancel`);
        return data;
      },
      onSuccess: () => {
        toast.success("booking canceled");
        dialog.setOpen(false);
        onSuccess?.();
      },
      onError: (err: AxiosError) => {
        if (err.status === 401) return;
        toast.error("Oops! something want wrang");
      },
    });
  const handleCancel = () => {
    mutateCancelBooking(reservationId);
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
          {t("cancelBooking")}
        </Heading>
        <Text mb={4}>{t("cancelBookingWarning")}</Text>
        <HStack justifyContent="flex-end">
          <Button onClick={() => dialog.setOpen(false)}>
            {t("keepBooking")}
          </Button>
          <Button
            color="red"
            variant="ghost"
            _hover={{ bg: "red.muted" }}
            onClick={handleCancel}
            loading={isCancelingBooking}
          >
            {t("cancelBooking")}
          </Button>
        </HStack>
      </div>
    </Dialog>
  );
}
