"use client";

import { Button, Box, VStack, Badge } from "@chakra-ui/react";
import { SubmitHandler, useForm } from "react-hook-form";
import { zodResolver } from "@hookform/resolvers/zod";
import Input from "../ui/Input";
import { LoginFormValues, loginSchema } from "@/Schemas/authSchemas";
import { useTranslations } from "next-intl";
import { useAuthContext } from "@/providers/AuthProvider";

export default function LoginForm() {
  const t = useTranslations("auth");
  const { login, isLogging, loginIsError, loginError } = useAuthContext();
  const {
    register,
    handleSubmit,
    formState: { errors },
  } = useForm<LoginFormValues>({
    resolver: zodResolver(loginSchema),
    defaultValues: {
      identifier: "",
      password: "",
    },
  });

  const onSubmit: SubmitHandler<LoginFormValues> = async (data) => {
    login({ login: data.identifier, password: data.password });
  };

  const getErrorMessage = (errorMessage?: string) => {
    if (!errorMessage) return "";
    return t(errorMessage);
  };

  return (
    <Box minW="320px" w="full">
      <form onSubmit={handleSubmit(onSubmit)}>
        <VStack gap="20px" alignItems="stretch">
          <Input
            label={t("emailOrPhoneNumber")}
            placeholder={t("enterEmailOrPhoneNumber")}
            register={register("identifier")}
            err={!!errors.identifier?.message}
            errMes={getErrorMessage(errors.identifier?.message?.toString())}
            type="text"
            h="auto"
            p="16px"
          />

          <Input
            label={t("password")}
            placeholder={t("enterPassword")}
            register={register("password")}
            err={!!errors.password?.message}
            errMes={getErrorMessage(errors.password?.message?.toString())}
            type="password"
            h="auto"
            p="16px"
          />
          {loginIsError && (
            <Badge
              p={"12px"}
              rounded={"12px"}
              fontWeight={"semibold"}
              colorPalette={"red"}
            >
              {loginError?.message}
            </Badge>
          )}
          <Button
            type="submit"
            size="lg"
            rounded="16px"
            loading={isLogging}
            w="full"
          >
            {t("signIn")}
          </Button>
        </VStack>
      </form>
    </Box>
  );
}
