"use client";
import {
  Badge,
  Box,
  Button,
  HStack,
  useDialog,
  VStack,
} from "@chakra-ui/react";
import React from "react";
import Dialog from "../ui/Dialog";
import Input from "../ui/Input";
import { SubmitHandler, useForm } from "react-hook-form";
import {
  createAddressSchema,
  TCreateAddressSchema,
} from "@/Schemas/addressSchemas";
import { zodResolver } from "@hookform/resolvers/zod";
import { FaPhoneAlt, FaRegUserCircle } from "react-icons/fa";
import DropSelectList from "../ui/DropSelectList";
import { useMutation, useQuery } from "@tanstack/react-query";
import axiosInstance from "@/utils/axiosInstance";
import { IAddress, IGovernorate } from "@/types";
import Textarea from "../ui/Textarea";
import toast from "react-hot-toast";
import { AxiosError } from "axios";
import { useTranslations } from "next-intl";

type Props = {
  trigger: React.ReactNode;
};

export default function CreateAddressDialog({ trigger }: Props) {
  const dialog = useDialog();
  const t = useTranslations("profile");

  const {
    register,
    handleSubmit,
    control,
    formState: { errors },
  } = useForm<TCreateAddressSchema>({
    resolver: zodResolver(createAddressSchema),
  });

  //   fetch governorate data
  const { data: governorateData, isLoading: governorateIsLoading } = useQuery({
    queryKey: ["governorate"],
    queryFn: async () => {
      const { data } = await axiosInstance<{ data: IGovernorate[] }>(
        "governorates",
      );
      return data.data;
    },
  });

  // create address mutation
  const {
    mutate: createAddress,
    error: createAddressError,
    isPending: createAddressIsPending,
    isError: createAddressIsError,
  } = useMutation({
    mutationKey: ["register"],
    mutationFn: async (body: Omit<IAddress, "id" | "icon">) => {
      const { data } = await axiosInstance.post("auth/register", body);
      return data;
    },
    onSuccess: (res) => {
      toast.success(`${t("welcome")} ${res.customer.name}`);
    },
    onError: (err: AxiosError<{ message?: string }>) => {
      const apiMessage = err.response?.data?.message;
      if (apiMessage) {
        err.message = apiMessage;
      }
    },
  });

  const onSubmit: SubmitHandler<TCreateAddressSchema> = async (data) => {
    console.log("data", data);
    createAddress({
      address_line1: data.governorate_id,
      address_line2: data.city_id,
      full_address: data.full_address,
      is_default: false,
      name: data.name || "",
      phone: data.phone || "",
      title: "",
    });
  };

  const getErrorMessage = React.useCallback(
    (errorMessage?: string) => (errorMessage ? t(errorMessage) : ""),
    [t],
  );
  return (
    <Dialog value={dialog} trigger={trigger} closeIconButton>
      <Box minW="680px" w="full">
        <form onSubmit={handleSubmit(onSubmit)}>
          <VStack gap="20px" alignItems="stretch">
            <HStack
              gap={{ base: "14px", lg: "26px", xl: "40px" }}
              align={"start"}
            >
              <Input
                label={t("fullName")}
                placeholder={t("enterYourFullName")}
                startElement={<FaRegUserCircle />}
                register={register("name")}
                err={!!errors?.name?.message}
                errMes={getErrorMessage(errors?.name?.message)}
                h={"auto"}
                p="16px"
              />

              <Input
                label={t("phoneNumber")}
                placeholder={t("phoneNumberPlaceholder")}
                startElement={<FaPhoneAlt />}
                register={register("phone")}
                err={!!errors?.phone?.message}
                errMes={getErrorMessage(errors.phone?.message)}
                h="auto"
                p="16px"
              />
            </HStack>
            <HStack
              gap={{ base: "14px", lg: "26px", xl: "40px" }}
              align={"start"}
            >
              <DropSelectList
                label={t("governorate")}
                placeholder={t("selectGovernorate")}
                isLoading={governorateIsLoading}
                control={control}
                contentProps={{ maxH: "340px" }}
                list={
                  governorateData?.map((e) => ({
                    label: e?.name,
                    value: String(e?.id),
                  })) || []
                }
                name="governorate_id"
                err={!!errors?.governorate_id?.message}
                errMes={getErrorMessage(errors.governorate_id?.message)}
                triggerProps={{
                  bg: "#F9FAFB",
                  h: "auto",
                  p: "16px",
                  rounded: "16px",
                }}
              />
              <DropSelectList
                label={t("city")}
                placeholder={t("selectCity")}
                isLoading={governorateIsLoading}
                control={control}
                contentProps={{ maxH: "340px" }}
                list={
                  governorateData?.map((e) => ({
                    label: e?.name,
                    value: String(e?.id),
                  })) || []
                }
                name="city_id"
                err={!!errors?.city_id?.message}
                errMes={getErrorMessage(errors.city_id?.message)}
                triggerProps={{
                  bg: "#F9FAFB",
                  h: "auto",
                  p: "16px",
                  rounded: "16px",
                }}
              />
            </HStack>
            <HStack
              gap={{ base: "14px", lg: "26px", xl: "40px" }}
              align={"start"}
              flexWrap={"wrap"}
            >
              {/* address input */}
              <Textarea
                register={register("full_address")}
                label={t("fullAddress")}
                placeholder={t("fullAddressPlaceholder")}
                err={!!errors?.full_address?.message}
                errMes={getErrorMessage(errors?.full_address?.message)}
                containerProps={{
                  w: "calc((100% - 40px) / 2)",
                  minW: "220px",
                  flex: 1,
                }}
              />
            </HStack>

            {createAddressIsError && (
              <Badge
                p="12px"
                rounded="12px"
                fontWeight="semibold"
                colorPalette="red"
                aria-live="polite"
              >
                {createAddressError?.message}
              </Badge>
            )}

            <Button
              type="submit"
              size="lg"
              rounded="16px"
              loading={createAddressIsPending}
              w="full"
            >
              {t("createAddress")}
            </Button>
          </VStack>
        </form>
      </Box>
    </Dialog>
  );
}
