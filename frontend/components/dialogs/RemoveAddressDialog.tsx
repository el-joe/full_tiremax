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

type props = {
  trigger: React.ReactNode;
  addressId: number;
};

export default function RemoveAddressDialog({ trigger, addressId }: props) {
  const dir = useDir();
  const dialog = useDialog();
  const t = useTranslations("profile");
  const router = useRouter();
  //   mutation booking
  const { mutate: removeAddressMutate, isPending: isRemovingAddress } =
    useMutation({
      mutationKey: ["removeAddress"],
      mutationFn: async (id: number) => {
        const { data } = await axiosInstance.delete<{ message: string }>(
          `addresses/${id}`,
        );
        return data;
      },
      onSuccess: (res) => {
        toast.success(res.message);
        dialog.setOpen(false);
        router.refresh();
      },
      onError: (err: AxiosError<{ message: string }>) => {
        if (err.status === 401) return;
        const errMes =
          err?.response?.data?.message ?? "Oops! something want wrang";
        toast.error(errMes);
      },
    });
  const handleCancel = () => {
    removeAddressMutate(addressId);
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
          {t("removeAddress")}
        </Heading>
        <Text mb={4}>{t("removeAddressWarning")}</Text>
        <HStack justifyContent="flex-end">
          <Button onClick={() => dialog.setOpen(false)}>{t("cancel")}</Button>
          <Button
            color="red"
            variant="ghost"
            _hover={{ bg: "red.muted" }}
            onClick={handleCancel}
            loading={isRemovingAddress}
          >
            {t("remove")}
          </Button>
        </HStack>
      </div>
    </Dialog>
  );
}
