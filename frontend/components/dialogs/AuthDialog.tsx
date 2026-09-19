"use client";
import { Tabs } from "@chakra-ui/react";
import Dialog from "../ui/Dialog";
import LoginForm from "../auth/LoginForm";
import RegisterForm from "../auth/RegisterForm";
import { LuLogIn, LuUserPlus } from "react-icons/lu";
import useDir from "@/hooks/useDir";
import { useTranslations } from "next-intl";
import { useAuthContext } from "@/providers/AuthProvider";
import { useQueryState } from "nuqs";
import { useSearchParams } from "next/navigation";

export default function AuthDialog() {
  const dir = useDir();
  const t = useTranslations("auth");
  const { authDialog } = useAuthContext();
  const hasPhone = !!useSearchParams().get("phone");
  const [, setAuthDialogPram] = useQueryState("authDialog");
  return (
    <Dialog
      value={authDialog}
      closeIconButton
      onExitComplete={() => setAuthDialogPram(null)}
    >
      <Tabs.Root defaultValue={hasPhone ? "register" : "login"}>
        <Tabs.List dir={dir}>
          <Tabs.Trigger value="login">
            <LuLogIn />
            {t("login")}
          </Tabs.Trigger>
          <Tabs.Trigger value="register">
            <LuUserPlus />
            {t("register")}
          </Tabs.Trigger>
        </Tabs.List>
        <Tabs.Content value="login" dir={dir} minW={"440px"}>
          {" "}
          <LoginForm />
        </Tabs.Content>
        <Tabs.Content value="register" dir={dir} minW={"440px"}>
          {" "}
          <RegisterForm />
        </Tabs.Content>
      </Tabs.Root>
    </Dialog>
  );
}
