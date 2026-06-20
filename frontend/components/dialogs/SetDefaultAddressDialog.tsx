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

export default function SetAsDefaultAddressDialog({
  trigger,
  addressId,
}: props) {
  const dir = useDir();
  const dialog = useDialog();
  const t = useTranslations("profile");
  const router = useRouter();
  //   mutation booking
  const { mutate: setDefaultMutate, isPending: isSetting } = useMutation({
    mutationKey: ["setAddressDefault"],
    mutationFn: async (id: number) => {
      const { data } = await axiosInstance.post<{ message: string }>(
        `addresses/${id}/set-default`,
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
        err.response?.data?.message ?? "Oops! something want wrang";
      toast.error(errMes);
    },
  });
  const handleSetDefault = () => {
    setDefaultMutate(addressId);
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
          {t("setAsDefaultAddress")}
        </Heading>
        <Text mb={4}>{t("setAsDefaultAddressWarning")}</Text>
        <HStack justifyContent="flex-end">
          <Button
            variant="ghost"
            color="black"
            onClick={() => dialog.setOpen(false)}
          >
            {t("cancel")}
          </Button>
          <Button onClick={handleSetDefault} loading={isSetting}>
            {t("set")}
          </Button>
        </HStack>
      </div>
    </Dialog>
  );
}
