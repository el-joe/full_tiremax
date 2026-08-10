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
  orderId: number;
  onSuccess?: () => void;
};

export default function CancelOrderDialog({
  trigger,
  orderId,
  onSuccess,
}: props) {
  const dir = useDir();
  const dialog = useDialog();
  const t = useTranslations("profile");

  const { mutate: mutateCancelOrder, isPending: isCancelingOrder } =
    useMutation({
      mutationKey: ["cancelOrder"],
      mutationFn: async (id: number) => {
        const { data } = await axiosInstance.post(`orders/${id}/cancel`);
        return data;
      },
      onSuccess: () => {
        toast.success("Order cancelled successfully");
        dialog.setOpen(false);
        onSuccess?.();
      },
      onError: (err: AxiosError<{ message?: string }>) => {
        if (err.status === 401) return;
        toast.error(err.response?.data?.message || "Oops! something went wrong");
      },
    });
  const handleCancel = () => {
    mutateCancelOrder(orderId);
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
          {t("cancelOrder")}
        </Heading>
        <Text mb={4}>{t("cancelOrderWarning")}</Text>
        <HStack justifyContent="flex-end">
          <Button onClick={() => dialog.setOpen(false)}>
            {t("keepOrder")}
          </Button>
          <Button
            color="red"
            variant="ghost"
            _hover={{ bg: "red.muted" }}
            onClick={handleCancel}
            loading={isCancelingOrder}
          >
            {t("cancelOrder")}
          </Button>
        </HStack>
      </div>
    </Dialog>
  );
}
