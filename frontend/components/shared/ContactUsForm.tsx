"use client";
import {
  Box,
  Button,
  Center,
  HStack,
  Icon,
  Text,
  VStack,
} from "@chakra-ui/react";
import React from "react";
import Input from "../ui/Input";
import { useTranslations } from "next-intl";
import { PhoneSignalIcon, SendMessageIcon, WhatsappLogoIcon } from "../Icons";
import Textarea from "../ui/Textarea";
import { Link } from "@/i18n/navigation";
import { SubmitHandler, useForm } from "react-hook-form";
import { zodResolver } from "@hookform/resolvers/zod";
import { ContactInput, contactSchema } from "@/Schemas/contactSchema";
import axiosInstance from "@/utils/axiosInstance";
import { AxiosError } from "axios";
import toast from "react-hot-toast";
import { FaRegUserCircle } from "react-icons/fa";
import { useMutation, useQuery } from "@tanstack/react-query";
import { getPublicSettings } from "@/helpers/getPublicSettings";

const ContactUsForm = () => {
  const t = useTranslations("home");
  const { data, isLoading } = useQuery({
    queryKey: ["settings"],
    queryFn: getPublicSettings,
  });
  const {
    register,
    handleSubmit,
    reset,
    setError,
    formState: { errors },
  } = useForm<ContactInput>({
    resolver: zodResolver(contactSchema),
    defaultValues: { name: "", phone: "", subject: "", message: "" },
  });

  const { mutate: sendMessage, isPending } = useMutation({
    mutationKey: ["contactMessage"],
    mutationFn: async (data: ContactInput) => {
      const { data: res } = await axiosInstance.post<{
        success: boolean;
        message: string;
      }>("contact-messages", data);
      return res;
    },
    onSuccess: () => {
      toast.success(t("contactMessageSent"));
      reset();
    },
    onError: (
      err: AxiosError<{ message?: string; errors?: Record<string, string[]> }>,
    ) => {
      const fieldErrors = err?.response?.data?.errors;
      if (err.response?.status === 422 && fieldErrors) {
        (Object.keys(fieldErrors) as string[]).forEach((key) => {
          if (key in contactSchema.shape) {
            setError(key as keyof ContactInput, {
              type: "server",
              message: fieldErrors[key]?.[0],
            });
          }
        });
      }
      const errMes =
        err?.response?.data?.message ?? "Oops! something went wrong";
      toast.error(errMes);
    },
  });

  const onSubmit: SubmitHandler<ContactInput> = (data) => sendMessage(data);
  // Client (zod) errors are i18n keys; server errors are already messages.
  const fieldMsg = (e?: { message?: string; type?: string }) =>
    !e?.message ? "" : e.type === "server" ? e.message : t(e.message);
  return (
    <form onSubmit={handleSubmit(onSubmit)}>
      <VStack
        gap={{ base: "9px", md: "22px", xl: "32px" }}
        rounded={"16px"}
        p={{ base: "9px", md: "22px", xl: "32px" }}
        border={"1px solid #E5E7EB"}
        alignItems={"stretch"}
      >
        <HStack gap={{ base: "9px", md: "22px", xl: "32px" }}>
          <Input
            label={t("fullName")}
            placeholder={t("enterYourFullName")}
            register={register("name")}
            err={!!errors.name}
            errMes={fieldMsg(errors.name)}
            startElement={
              <Icon size={"md"}>
                <FaRegUserCircle />
              </Icon>
            }
          />
          <Input
            label={t("phoneNumber")}
            placeholder={t("phoneNumberPlaceholder")}
            register={register("phone")}
            err={!!errors.phone}
            errMes={fieldMsg(errors.phone)}
            startElement={<PhoneSignalIcon size={"sm"} color={"gray-2"} />}
          />
        </HStack>
        <Input
          label={t("inquirySubject")}
          placeholder={t("inquiryAboutPrices")}
          register={register("subject")}
          err={!!errors.subject}
          errMes={fieldMsg(errors.subject)}
          w={{ base: "full", xl: "576px" }}
        />
        <Textarea
          label={t("message")}
          placeholder={t("howCanWeHelpYouToday")}
          register={register("message")}
          err={!!errors.message}
          errMes={fieldMsg(errors.message)}
          minH={"160px"}
        />
        <HStack justifyContent={"space-between"} gap={{ base: "4px" }}>
          <HStack gap={{ base: "1px", md: "8px" }}>
            <Text fontSize={{ base: "10px", md: "16px" }}>
              {t("orContactImmediatelyVia")}
            </Text>
            <Link href={data?.whatsapp_url ?? "#"} target="_blank">
              <Center
                bg="#41C452"
                rounded={"8px"}
                color={"white"}
                w={{ base: "24px", md: "38px", xl: "48px" }}
                h={{ base: "24px", md: "38px", xl: "48px" }}
              >
                <WhatsappLogoIcon size={{ base: "sm", md: "lg", xl: "xl" }} />
              </Center>
            </Link>
          </HStack>
          <Button
            fontSize={{ base: "13px", md: "16px", xl: "20px" }}
            rounded={{ base: "11px", md: "16px" }}
            gap={{ base: "3px", md: "11px" }}
            px={{ base: "9px", md: "24px", xl: "48px" }}
            py={{ base: "7px", md: "14px", xl: "20px" }}
            type="submit"
            loading={isPending}
          >
            {" "}
            <SendMessageIcon size={{ base: "xs", md: "sm" }} />{" "}
            {t("sendMessage")}
          </Button>
        </HStack>
      </VStack>
    </form>
  );
};

export default ContactUsForm;
