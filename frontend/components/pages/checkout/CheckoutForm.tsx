"use client";
import {
  Box,
  Center,
  Heading,
  HStack,
  Icon,
  RadioCard,
  Skeleton,
  Spinner,
  Text,
  VStack,
} from "@chakra-ui/react";
import { SubmitHandler, useForm, useWatch } from "react-hook-form";
import { zodResolver } from "@hookform/resolvers/zod";
import {
  type CreateOrderInput,
  createOrderSchema,
} from "@/Schemas/createOrderSchemas";
import { useLocale, useTranslations } from "next-intl";
import Input from "@/components/ui/Input";
import { FaPhoneAlt, FaRegUserCircle } from "react-icons/fa";
import DropSelectList from "@/components/ui/DropSelectList";
import Textarea from "@/components/ui/Textarea";
import { useMutation, useQuery } from "@tanstack/react-query";
import axiosInstance from "@/utils/axiosInstance";
import { ICity, IGovernorate, IOrder, IPaymentMethod } from "@/types";
import { LuMapPin } from "react-icons/lu";
import { MdOutlineLocalShipping } from "react-icons/md";
import CurrencySymbol from "@/components/ui/CurrencySymbol";
import { FaMoneyBills } from "react-icons/fa6";
import { AxiosError } from "axios";
import toast from "react-hot-toast";
import useDir from "@/hooks/useDir";
import { useAuthContext } from "@/providers/AuthProvider";
import { useRouter } from "@/i18n/navigation";
import { useEffect } from "react";
export default function CheckoutForm() {
  const t = useTranslations("cartAndPayment");
  const locale = useLocale();
  const router = useRouter();
  const { protectedWithAuth } = useAuthContext();
  const dir = useDir();
  const {
    register,
    handleSubmit,
    control,
    setValue,
    watch,
    formState: { errors },
  } = useForm<CreateOrderInput>({
    resolver: zodResolver(createOrderSchema),
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
  //   fetch payment methods data
  const { data: paymentMethods, isLoading: paymentMethodsIsLoading } = useQuery(
    {
      queryKey: ["payment-gateways"],
      queryFn: async () => {
        const { data } = await axiosInstance<{ data: IPaymentMethod[] }>(
          "payment-gateways",
        );
        return data.data;
      },
    },
  );
  // fetch the cities data
  const {
    data: citiesData,
    isPending: citiesIsLoading,
    mutate: citiesMutate,
  } = useMutation({
    mutationKey: ["citiesList"],
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

  const { mutate: createOrder, isPending: isCreatingOrder } = useMutation({
    mutationKey: ["createOrder"],
    mutationFn: async (data: CreateOrderInput) => {
      const body = {
        ...data,
        governorate_id: +data.governorate_id,
        type: "delivery",
      };
      const { data: res } = await axiosInstance.post<{
        success: boolean;
        message: string;
        data: IOrder;
      }>("orders", body);
      return res;
    },
    onSuccess: (res) => {
      toast.success(res.message);
      router.push(`/checkout/confirm/${res.data.id}`);
    },
    onError: (err: AxiosError<{ message: string }>) => {
      if (err.status === 401) return;
      const errMes =
        err?.response?.data?.message ?? "Oops! something want wrang";
      toast.error(errMes);
    },
  });

  const onSubmit: SubmitHandler<CreateOrderInput> = async (data) => {
    // wrap mutate call so it matches protectedWithAuth signature
    protectedWithAuth(() => createOrder(data));
  };

  return (
    <Box flex={1} w={"880px"} minW={"420px"}>
      {isCreatingOrder && (
        <Center position={"fixed"} inset={0} zIndex={"10"} bg={"black/20"}>
          <Spinner size={"xl"} />
        </Center>
      )}
      <form id="checkoutForm" onSubmit={handleSubmit(onSubmit)}>
        <VStack gap={{ base: "32px", xl: "80px" }} align={"stretch"}>
          {/* personal information */}
          <GroupContainer>
            <Heading>{t("personalInformation")}</Heading>
            <HStack
              gap={{ base: "14px", lg: "26px", xl: "40px" }}
              align={"start"}
            >
              <Input
                label={t("fullName")}
                placeholder={t("enterYourFullName")}
                startElement={<FaRegUserCircle />}
                register={register("customer_name")}
                err={!!errors?.customer_name?.message}
                errMes={
                  !!errors?.customer_name?.message
                    ? t(errors?.customer_name?.message)
                    : ""
                }
                h={"auto"}
                p="16px"
              />
              <Input
                label={t("phoneNumber")}
                placeholder={t("phoneNumberPlaceholder")}
                startElement={<FaPhoneAlt />}
                register={register("customer_phone")}
                err={!!errors?.customer_phone?.message}
                errMes={
                  !!errors.customer_phone?.message
                    ? t(errors?.customer_phone?.message)
                    : ""
                }
                h="auto"
                p="16px"
              />
            </HStack>
            <HStack
              gap={{ base: "14px", lg: "26px", xl: "40px" }}
              align={"start"}
            >
              {/* governorates */}
              <DropSelectList
                label={t("governorate")}
                placeholder={t("selectGovernorate")}
                isLoading={governorateIsLoading}
                control={control}
                list={
                  governorateData?.map((e) => ({
                    label: e?.name,
                    value: String(e?.id),
                  })) || []
                }
                name="governorate_id"
                err={!!errors?.governorate_id?.message}
                errMes={
                  !!errors.governorate_id?.message
                    ? t(errors?.governorate_id?.message)
                    : ""
                }
                triggerProps={{
                  bg: "#F9FAFB",
                  h: "auto",
                  p: "16px",
                  rounded: "16px",
                }}
              />
              {/* cities */}
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
                errMes={
                  !!errors.city_id?.message ? t(errors?.city_id?.message) : ""
                }
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
                register={register("shipping_address")}
                label={t("fullAddress")}
                placeholder={t("fullAddressPlaceholder")}
                err={!!errors?.shipping_address?.message}
                errMes={
                  !!errors?.shipping_address?.message
                    ? t(errors?.shipping_address?.message)
                    : ""
                }
                containerProps={{
                  w: "calc((100% - 40px) / 2)",
                  minW: "220px",
                  flex: 1,
                }}
              />
              <Textarea
                register={register("notes")}
                label={t("notes")}
                placeholder={t("notesPlaceholder")}
                err={!!errors?.notes?.message}
                errMes={
                  !!errors?.notes?.message ? t(errors?.notes?.message) : ""
                }
                containerProps={{
                  w: "calc((100% - 40px) / 2)",
                  minW: "200px",
                  flex: 1,
                }}
              />
            </HStack>
          </GroupContainer>
          {/* shipping details */}
          <GroupContainer>
            {watch("governorate_id") ? (
              // if governorate selected
              <VStack gap={"40px"} align={"stretch"}>
                <Box>
                  <Heading fontSize={"24px"} fontWeight={"extrabold"}>
                    <Icon color={"primary"} size={"xl"} me={"8px"}>
                      <MdOutlineLocalShipping />
                    </Icon>
                    {t("deliveryService")}
                  </Heading>
                  <Text mt={"8px"} fontSize={"14px"} color={"gray-2"}>
                    {t("deliveryDescription")}
                  </Text>
                </Box>
                <VStack gap={"16px"} align={"stretch"}>
                  {/* estimated delivery */}
                  <HStack
                    justify={"space-between"}
                    bg={"#F9FAFB"}
                    p={"16px"}
                    rounded={"12px"}
                    border={"1px solid #D1D5DC"}
                  >
                    <Text color={"gray-2"}>{t("estimatedDeliveryTime")}</Text>
                    <Text>(Unknown) {t("businessDays")}</Text>
                  </HStack>
                  {/* shipping fee */}
                  <HStack
                    justify={"space-between"}
                    bg={"#F9FAFB"}
                    p={"16px"}
                    rounded={"12px"}
                    border={"1px solid #D1D5DC"}
                  >
                    <Text color={"gray-2"}>{t("deliveryFee")}</Text>
                    <Text fontWeight={"bold"} color={"primary"}>
                      {(governorateData?.find(
                        // eslint-disable-next-line react-hooks/incompatible-library
                        (e) => e.id === +watch("governorate_id"),
                      )?.shipping_fee as number) < 1 ? (
                        t("freeDelivery")
                      ) : (
                        <>
                          {
                            governorateData?.find(
                              (e) => e.id === +watch("governorate_id"),
                            )?.shipping_fee
                          }
                          <CurrencySymbol />
                        </>
                      )}
                    </Text>
                  </HStack>
                </VStack>
              </VStack>
            ) : (
              // if no selected governorate
              <VStack>
                <Icon color={"#4A5565"} size={"2xl"}>
                  <LuMapPin />
                </Icon>
                <Text color={"#99A1AF"}>
                  {t("selectYourAddressToShowTheAvailableServices")}
                </Text>
              </VStack>
            )}
          </GroupContainer>
          {/* payment methods */}
          <GroupContainer>
            <RadioCard.Root
              defaultValue="cod"
              onValueChange={(e) => {
                setValue(
                  "payment_method",
                  e.value as CreateOrderInput["payment_method"],
                );
              }}
              dir={dir}
            >
              <RadioCard.Label dir={dir} gap="8px">
                <Heading mb={"40px"} fontSize={"24px"} fontWeight={"extrabold"}>
                  {t("paymentMethod")}
                </Heading>
                {!!errors?.payment_method?.message && (
                  <Text mt="6px" color="red">
                    {t(errors?.payment_method?.message ?? "")}
                  </Text>
                )}
              </RadioCard.Label>
              <HStack
                align="stretch"
                gapX={"40px"}
                gapY={"24px"}
                flexWrap={"wrap"}
              >
                {paymentMethodsIsLoading &&
                  Array.from({ length: 4 }).map((e, i) => (
                    <Skeleton
                      key={i}
                      minW={"200px"}
                      w={"calc((100% - 40px) / 2)"}
                      h="56px"
                      rounded="24px"
                    />
                  ))}
                {!paymentMethods?.length && (
                  <Heading textAlign={"center"}>
                    {t("noPaymentMethodsAvailable")}
                  </Heading>
                )}
                {paymentMethods?.map((item) => (
                  <RadioCard.Item
                    key={item.id}
                    value={item.name}
                    minW={"200px"}
                    w={"calc((100% - 40px) / 2)"}
                    // maxW={"calc((100% - 40px) / 2)"}
                    flex={"auto"}
                    rounded={"24px"}
                    dir={dir}
                  >
                    <RadioCard.ItemHiddenInput />
                    <RadioCard.ItemControl>
                      <RadioCard.ItemContent>
                        <HStack gap="12px">
                          <Center
                            minW={"48px"}
                            h={"48px"}
                            bg={"primary"}
                            rounded={"12px"}
                            color={"white"}
                          >
                            <Icon size={"lg"}>
                              <FaMoneyBills />
                            </Icon>
                          </Center>
                          <Box>
                            <RadioCard.ItemText fontWeight={"bold"}>
                              {item.display_name}
                            </RadioCard.ItemText>
                            {/* <RadioCard.ItemDescription
                              fontSize={"12px"}
                              color={"gray-2"}
                            >
                              {t(item.description)}
                            </RadioCard.ItemDescription> */}
                          </Box>
                        </HStack>
                      </RadioCard.ItemContent>
                      <RadioCard.ItemIndicator />
                    </RadioCard.ItemControl>
                  </RadioCard.Item>
                ))}
              </HStack>
            </RadioCard.Root>

            <HStack></HStack>
          </GroupContainer>
        </VStack>
      </form>
    </Box>
  );
}

const GroupContainer = ({ children }: { children: React.ReactNode }) => (
  <VStack
    gap={{ base: "12px", xl: "24px" }}
    align={"stretch"}
    p={"32px"}
    rounded={"16px"}
    border={"1px solid #E5E7EB"}
  >
    {children}
  </VStack>
);
