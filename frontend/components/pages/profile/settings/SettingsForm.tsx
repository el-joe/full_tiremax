"use client";
import Input from "@/components/ui/Input";
import useDir from "@/hooks/useDir";
import { useAuthContext } from "@/providers/AuthProvider";
import {
  settingsSchema,
  TSettingsSchema,
} from "@/Schemas/updateProfileSchemas";
import {
  Badge,
  Button,
  Center,
  Heading,
  HStack,
  Icon,
  Switch,
  Text,
  VStack,
} from "@chakra-ui/react";
import { zodResolver } from "@hookform/resolvers/zod";
import { useTranslations } from "next-intl";
import React, { useEffect } from "react";
import { SubmitHandler, useForm, Resolver } from "react-hook-form";
import { FaRegSave, FaRegUser } from "react-icons/fa";
import { GoBell } from "react-icons/go";
import { IoLockClosedOutline } from "react-icons/io5";

const NOTIFICATIONS_SETTINGS_LIST = [
  {
    id: 1,
    name: "orderUpdates",
    description: "orderUpdatesDescription",
    key: "",
  },
  {
    id: 2,
    name: "offersAndDiscounts",
    description: "offersAndDiscountsDescription",
    key: "",
  },
  {
    id: 3,
    name: "newsletter",
    description: "newsletterDescription",
    key: "",
  },
  {
    id: 4,
    name: "smsMessages",
    description: "smsMessagesDescription",
    key: "",
  },
];

export default function SettingsForm() {
  const t = useTranslations("profile");
  const dir = useDir();

  const {
    updateCustomer,
    updateCustomerError,
    updateCustomerIsPending,
    updateCustomerIsError,
    customer,
  } = useAuthContext();

  const {
    register,
    handleSubmit,
    formState: { errors },
  } = useForm<TSettingsSchema>({
    resolver: zodResolver(settingsSchema) as Resolver<TSettingsSchema>,
    defaultValues: {
      name: customer?.name,
      phone: customer?.phone,
      email: customer?.email,
    },
  });

  const onSubmit: SubmitHandler<TSettingsSchema> = async (data) => {
    updateCustomer(data);
  };

  const getErrorMessage = React.useCallback(
    (errorMessage?: string) => (errorMessage ? t(errorMessage) : ""),
    [t],
  );

  useEffect(() => {
    console.log(errors);
    return () => {};
  }, [errors]);
  return (
    <VStack
      as="form"
      onSubmit={handleSubmit(onSubmit)}
      mt={"25px"}
      align={"stretch"}
      gap="24px"
    >
      <GroupContainer>
        <HStack>
          <Center w="38px" h="38px" bg="#FDB6041A" rounded="14px">
            <Icon color={"primary"} size={"md"}>
              <FaRegUser />
            </Icon>
          </Center>
          <Heading fontSize={"20px"} fontWeight={"bold"}>
            {t("personalInformation")}
          </Heading>
        </HStack>
        <HStack gap={"24px"}>
          <Input
            label={t("fullName")}
            placeholder={t("enterYourFullName")}
            register={register("name")}
            err={!!errors.name?.message}
            errMes={getErrorMessage(errors.name?.message?.toString())}
            type="text"
            h="auto"
            p="16px"
          />
          <Input
            label={t("phoneNumber")}
            placeholder={t("phoneNumberPlaceholder")}
            register={register("phone")}
            err={!!errors.phone?.message}
            errMes={getErrorMessage(errors.phone?.message?.toString())}
            type="text"
            h="auto"
            p="16px"
          />
        </HStack>
        <Input
          label={t("email")}
          placeholder={t("emailPlaceholder")}
          register={register("email")}
          err={!!errors.email?.message}
          errMes={getErrorMessage(errors.email?.message?.toString())}
          type="text"
          h="auto"
          p="16px"
        />
      </GroupContainer>
      {/* security settings */}
      <GroupContainer>
        <HStack>
          <Center w="38px" h="38px" bg="#EFF6FF" rounded="14px">
            <Icon color={"#155DFC"} size={"md"}>
              <IoLockClosedOutline />
            </Icon>
          </Center>
          <Heading fontSize={"20px"} fontWeight={"bold"}>
            {t("securityAndPassword")}
          </Heading>
        </HStack>
        <HStack gap={"24px"}>
          <Input
            label={t("newPassword")}
            register={register("newPassword")}
            err={!!errors.newPassword?.message}
            errMes={getErrorMessage(errors.newPassword?.message?.toString())}
            type="text"
            h="auto"
            p="16px"
          />
          <Input
            label={t("confirmPassword")}
            register={register("password_confirmation")}
            err={!!errors.password_confirmation?.message}
            errMes={getErrorMessage(
              errors.password_confirmation?.message?.toString(),
            )}
            type="text"
            h="auto"
            p="16px"
          />
        </HStack>
      </GroupContainer>
      <GroupContainer>
        <HStack>
          <Center w="38px" h="38px" bg="#F0FDF4" rounded="14px">
            <Icon color={"#00A63E"} size={"md"}>
              <GoBell />
            </Icon>
          </Center>
          <Heading fontSize={"20px"} fontWeight={"bold"}>
            {t("notificationSettings")}
          </Heading>
        </HStack>
        {NOTIFICATIONS_SETTINGS_LIST.map((e) => (
          <HStack
            key={e.id}
            p="16px"
            ps="121px"
            bg={"gray-4"}
            rounded="14px"
            justify={"space-between"}
          >
            <VStack align={"start"}>
              <Text fontSize={"18px"} fontWeight={"medium"}>
                {t(e.name)}
              </Text>
              <Text fontSize={"14px"} color={"gray-2"}>
                {t(e.description)}
              </Text>
            </VStack>
            <Switch.Root size={"lg"} disabled>
              <Switch.HiddenInput />
              <Switch.Control dir={dir} _checked={{ bg: "primary" }} />
            </Switch.Root>
          </HStack>
        ))}
      </GroupContainer>
      {updateCustomerIsError && (
        <Badge
          p="12px"
          rounded="12px"
          fontWeight="semibold"
          colorPalette="red"
          aria-live="polite"
        >
          {updateCustomerError?.message}
        </Badge>
      )}
      <HStack justify={"end"} pe={"105px"} gap={"16px"}>
        {/* <Button
          variant={"outline"}
          color={"black"}
          borderColor={"#D1D5DC"}
          px="24px"
          h="50px"
        >
          {t("cancel")}
        </Button> */}
        <Button
          color={"black"}
          px="24px"
          h="50px"
          type="submit"
          loading={updateCustomerIsPending}
        >
          <FaRegSave /> {t("saveChanges")}
        </Button>
      </HStack>
    </VStack>
  );
}

const GroupContainer = ({ children }: { children: React.ReactNode }) => (
  <VStack
    gap="24px"
    align="stretch"
    p="32px"
    border="1px solid #E5E7EB"
    rounded="16px"
    boxShadow={"0 1px 2px -1px #0000001A, 0 1px 3px 0px #0000001A"}
  >
    {children}
  </VStack>
);
