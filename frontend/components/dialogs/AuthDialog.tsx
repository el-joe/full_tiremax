"use client";
import { Tabs } from "@chakra-ui/react";
import Dialog from "../ui/Dialog";
import LoginForm from "../auth/LoginForm";
import RegisterForm from "../auth/RegisterForm";
import { LuLogIn, LuUserPlus } from "react-icons/lu";
import useDir from "@/hooks/useDir";
import { useTranslations } from "next-intl";
import { useAuthContext } from "@/providers/AuthProvider";

export default function AuthDialog() {
  const dir = useDir();
  const t = useTranslations("auth");
  const { authDialog } = useAuthContext();
  return (
    <Dialog value={authDialog} closeIconButton>
      <Tabs.Root defaultValue="members">
        <Tabs.List dir={dir}>
          <Tabs.Trigger value="members">
            <LuLogIn />
            {t("login")}
          </Tabs.Trigger>
          <Tabs.Trigger value="projects">
            <LuUserPlus />
            {t("register")}
          </Tabs.Trigger>
        </Tabs.List>
        <Tabs.Content value="members" dir={dir}>
          {" "}
          <LoginForm />
        </Tabs.Content>
        <Tabs.Content value="projects" dir={dir}>
          {" "}
          <RegisterForm />
        </Tabs.Content>
      </Tabs.Root>
    </Dialog>
  );
}
