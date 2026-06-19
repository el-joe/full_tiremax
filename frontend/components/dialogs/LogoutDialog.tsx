"use client";
import React from "react";
import Dialog from "../ui/Dialog";
import { useDialog, Button, HStack, Text, Heading } from "@chakra-ui/react";
import { useAuthContext } from "@/providers/AuthProvider";
import { useRouter } from "@/i18n/navigation";
import { useTranslations } from "next-intl";
import useDir from "@/hooks/useDir";

type props = {
  trigger: React.ReactNode;
};

export default function LogoutDialog({ trigger }: props) {
  const dir = useDir();
  const dialog = useDialog();
  const t = useTranslations("auth");
  const { logout } = useAuthContext();
  const router = useRouter();

  const handleLogout = () => {
    logout();
    dialog.setOpen(false);
    void router.push("/");
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
          {t("logoutTitle")}
        </Heading>
        <Text mb={4}>{t("logoutWarning")}</Text>
        <HStack justifyContent="flex-end">
          <Button onClick={() => dialog.setOpen(false)}>
            {t("logoutCancel")}
          </Button>
          <Button
            color="red"
            variant="ghost"
            _hover={{ bg: "red.muted" }}
            onClick={handleLogout}
          >
            {t("logoutConfirm")}
          </Button>
        </HStack>
      </div>
    </Dialog>
  );
}
