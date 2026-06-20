"use client";
import {
  Badge,
  Box,
  Button,
  HStack,
  useDialog,
  VStack,
} from "@chakra-ui/react";
import React, { useEffect } from "react";
import Dialog from "../ui/Dialog";
import Input from "../ui/Input";
import { SubmitHandler, useForm, useWatch } from "react-hook-form";
import {
  createAddressSchema,
  TCreateAddressSchema,
} from "@/Schemas/addressSchemas";
import { zodResolver } from "@hookform/resolvers/zod";
import { FaPhoneAlt, FaRegUserCircle } from "react-icons/fa";
import DropSelectList from "../ui/DropSelectList";
import { useMutation, useQuery } from "@tanstack/react-query";
import axiosInstance from "@/utils/axiosInstance";
import { IAddress, ICity, IGovernorate } from "@/types";
import Textarea from "../ui/Textarea";
import toast from "react-hot-toast";
import { AxiosError } from "axios";
import { useLocale, useTranslations } from "next-intl";
import { useRouter } from "@/i18n/navigation";

type Props = {
  trigger: React.ReactNode;
};

export default function CreateAddressDialog({ trigger }: Props) {
  const dialog = useDialog();
  const t = useTranslations("profile");
  const locale = useLocale();
  const router = useRouter();

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
    mutationKey: ["createAddress"],
    mutationFn: async (body: TCreateAddressSchema) => {
      const { data } = await axiosInstance.post<{
        data: IAddress;
        message: string;
      }>("addresses", body);
      return data;
    },
    onSuccess: (res) => {
      toast.success(res.message);
      dialog.setOpen(false);
      router.refresh();
    },
    onError: (err: AxiosError<{ message?: string }>) => {
      const apiMessage =
        err.response?.data?.message ?? "Oops! something want wrang!";
      toast.error(apiMessage);
    },
  });

  const onSubmit: SubmitHandler<TCreateAddressSchema> = async (data) => {
    console.log("data", data);
    createAddress(data);
  };

  const getErrorMessage = React.useCallback(
    (errorMessage?: string) => (errorMessage ? t(errorMessage) : ""),
    [t],
  );
  // fetch the cities data
  const {
    data: citiesData,
    isPending: citiesIsLoading,
    mutate: citiesMutate,
  } = useMutation({
    mutationKey: ["modelList"],
    mutationFn: async (id: string) => {
      const { data } = await axiosInstance<{ data: ICity[] }>(
        `governorates/${id}/cities`,
      );
      return data.data;
    },
  });

  const governorateId = useWatch({ control, name: "governorate_id" });

  useEffect(() => {
    if (!!governorateId) {
      citiesMutate(governorateId);
    }
  }, [citiesMutate, governorateId]);
  return (
    <Dialog value={dialog} trigger={trigger} closeIconButton>
      <Box minW={{ base: "auto", md: "680px" }} w="full">
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
                register={register("full_name")}
                err={!!errors?.full_name?.message}
                errMes={getErrorMessage(errors?.full_name?.message)}
                h={"auto"}
                p={{ base: "8px", md: "16px" }}
                ps="28px !important"
              />

              <Input
                label={t("phoneNumber")}
                placeholder={t("phoneNumberPlaceholder")}
                startElement={<FaPhoneAlt />}
                register={register("phone")}
                err={!!errors?.phone?.message}
                errMes={getErrorMessage(errors.phone?.message)}
                h="auto"
                p={{ base: "8px", md: "16px" }}
                ps="28px !important"
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
                  p: { base: "8px", md: "16px" },
                  rounded: "16px",
                }}
              />
              <DropSelectList
                label={t("city")}
                placeholder={t("selectCity")}
                isLoading={citiesIsLoading}
                control={control}
                contentProps={{ maxH: "340px" }}
                list={
                  citiesData?.map((e) => ({
                    label: locale === "ar" ? e?.name_ar : e?.name_en,
                    value: String(e?.id),
                  })) || []
                }
                name="city_id"
                err={!!errors?.city_id?.message}
                errMes={getErrorMessage(errors.city_id?.message)}
                triggerProps={{
                  bg: "#F9FAFB",
                  h: "auto",
                  p: { base: "8px", md: "16px" },
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
                register={register("address")}
                label={t("fullAddress")}
                placeholder={t("fullAddressPlaceholder")}
                err={!!errors?.address?.message}
                errMes={getErrorMessage(errors?.address?.message)}
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
