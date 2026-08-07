"use client";

import React from "react";
import { Button, Box, VStack, Badge } from "@chakra-ui/react";
import { SubmitHandler, useForm } from "react-hook-form";
import { zodResolver } from "@hookform/resolvers/zod";
import Input from "../ui/Input";
import { RegisterFormValues, registerSchema } from "@/Schemas/authSchemas";
import { useLocale, useTranslations } from "next-intl";
import { useAuthContext } from "@/providers/AuthProvider";

export default function RegisterForm() {
  const t = useTranslations("auth");
  const locale = useLocale();

  const {
    register: registerUser,
    isRegistering,
    registerIsError,
    registerError,
  } = useAuthContext();

  const {
    register,
    handleSubmit,
    formState: { errors },
  } = useForm<RegisterFormValues>({
    resolver: zodResolver(registerSchema),
    defaultValues: {
      name: "",
      phone: "",
      email: "",
      password: "",
      password_confirmation: "",
      address: "",
    },
  });

  const onSubmit: SubmitHandler<RegisterFormValues> = async (data) => {
    registerUser({
      name: data.name,
      phone: data.phone,
      password: data.password,
      password_confirmation: data.password_confirmation,
      address: data?.address,
      email: data?.email,
      locale,
    });
  };

  const getErrorMessage = React.useCallback(
    (errorMessage?: string) => (errorMessage ? t(errorMessage) : ""),
    [t],
  );

  return (
    <Box minW="320px" w="full">
      <form onSubmit={handleSubmit(onSubmit)}>
        <VStack gap="20px" alignItems="stretch">
          <Input
            label={t("fullName")}
            placeholder={t("enterFullName")}
            register={register("name")}
            err={!!errors.name?.message}
            errMes={getErrorMessage(errors.name?.message?.toString())}
            type="text"
            h="auto"
            p="16px"
          />

          <Input
            label={t("phoneNumber")}
            placeholder={t("enterPhoneNumber")}
            register={register("phone")}
            err={!!errors.phone?.message}
            errMes={getErrorMessage(errors.phone?.message?.toString())}
            type="tel"
            h="auto"
            p="16px"
          />

          <Input
            label={t("emailOptional")}
            placeholder={t("enterEmail")}
            register={register("email")}
            err={!!errors.email?.message}
            errMes={getErrorMessage(errors.email?.message?.toString())}
            type="email"
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

          <Input
            label={t("confirmPassword")}
            placeholder={t("confirmYourPassword")}
            register={register("password_confirmation")}
            err={!!errors.password_confirmation?.message}
            errMes={getErrorMessage(
              errors.password_confirmation?.message?.toString(),
            )}
            type="password"
            h="auto"
            p="16px"
          />

          <Input
            label={t("addressOptional")}
            placeholder={t("enterAddress")}
            register={register("address")}
            err={!!errors.address?.message}
            errMes={getErrorMessage(errors.address?.message?.toString())}
            type="text"
            h="auto"
            p="16px"
          />

          {registerIsError && (
            <Badge
              p="12px"
              rounded="12px"
              fontWeight="semibold"
              colorPalette="red"
              aria-live="polite"
            >
              {registerError?.message}
            </Badge>
          )}

          <Button
            type="submit"
            size="lg"
            rounded="16px"
            loading={isRegistering}
            w="full"
          >
            {t("createAccount")}
          </Button>
        </VStack>
      </form>
    </Box>
  );
}
