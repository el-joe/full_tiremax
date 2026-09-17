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
import { useTranslations } from "next-intl";
import Input from "@/components/ui/Input";
import { FaPhoneAlt, FaRegUserCircle } from "react-icons/fa";
import DropSelectList from "@/components/ui/DropSelectList";
import Textarea from "@/components/ui/Textarea";
import { useMutation, useQuery } from "@tanstack/react-query";
import axiosInstance from "@/utils/axiosInstance";
import {
  IBranch,
  IGovernorate,
  IOrder,
  IPayment,
  IPaymentMethod,
} from "@/types";
import { LuMapPin } from "react-icons/lu";
import { MdOutlineLocalShipping } from "react-icons/md";
import CurrencySymbol from "@/components/ui/CurrencySymbol";
import { FaMoneyBills } from "react-icons/fa6";
import { AxiosError } from "axios";
import toast from "react-hot-toast";
import useDir from "@/hooks/useDir";
import { useAuthContext } from "@/providers/AuthProvider";
import { useRouter } from "@/i18n/navigation";
import { useEffect, useState } from "react";
export default function CheckoutForm() {
  const t = useTranslations("cartAndPayment");
  const router = useRouter();
  const { protectedWithAuth } = useAuthContext();
  const dir = useDir();
  const [isRedirectingToPayment, setIsRedirectingToPayment] = useState(false);
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
  //   fetch branches data
  const { data: branchesData, isLoading: branchesIsLoading } = useQuery({
    queryKey: ["branches"],
    queryFn: async () => {
      const { data } = await axiosInstance<{ data: IBranch[] }>("branches");
      return data.data;
    },
  });

  const orderType = useWatch({ control, name: "type" });

  useEffect(() => {
    if (!orderType) {
      setValue("type", "delivery");
    }
  }, [orderType, setValue]);

  const { mutate: createOrder, isPending: isCreatingOrder } = useMutation({
    mutationKey: ["createOrder"],
    mutationFn: async (data: CreateOrderInput) => {
      const body = {
        type: data.type,
        payment_method: data.payment_method,
        customer_name: data.customer_name,
        customer_phone: data.customer_phone,
        customer_email: data.customer_email,
        notes: data.notes,
        ...(data.type === "basra"
          ? { branch_id: data.branch_id ? +data.branch_id : undefined }
          : {
              governorate_id: data.governorate_id
                ? +data.governorate_id
                : undefined,
              shipping_address: data.shipping_address,
            }),
      };
      const { data: res } = await axiosInstance.post<{
        success: boolean;
        message: string;
        data: IOrder;
      }>("orders", body);
      return res;
    },
    onSuccess: async (res) => {
      toast.success(res.message);
      const orderId = res.data.id;

      try {
        setIsRedirectingToPayment(true);
        const { data: paymentRes } = await axiosInstance.get<{
          data: IPayment;
        }>(`orders/${orderId}/payment`);
        const payment = paymentRes.data;

        if (payment.gateway.driver === "paymob" && payment.redirect_url) {
          window.location.href = payment.redirect_url;
          return;
        }

        router.push(`/checkout/confirm/${orderId}`);
      } catch {
        // no payment record yet (e.g. COD) or fetch failed — proceed to confirmation
        router.push(`/checkout/confirm/${orderId}`);
      } finally {
        setIsRedirectingToPayment(false);
      }
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
      {isRedirectingToPayment && (
        <Center
          position={"fixed"}
          inset={0}
          zIndex={"10"}
          bg={"black/20"}
          flexDirection={"column"}
          gap={"16px"}
        >
          <Spinner size={"xl"} />
          <Text>Redirecting to payment...</Text>
        </Center>
      )}
      <form id="checkoutForm" onSubmit={handleSubmit(onSubmit)}>
        <VStack gap={{ base: "32px", xl: "80px" }} align={"stretch"}>
          {/* order type */}
          <GroupContainer>
            <RadioCard.Root
              value={orderType}
              onValueChange={(e) => {
                setValue("type", e.value as CreateOrderInput["type"]);
              }}
              dir={dir}
            >
              <RadioCard.Label dir={dir} gap="8px">
                <Heading fontSize={"24px"} fontWeight={"extrabold"}>
                  {t("orderType")}
                </Heading>
                {!!errors?.type?.message && (
                  <Text mt="6px" color="red">
                    {t(errors?.type?.message ?? "")}
                  </Text>
                )}
              </RadioCard.Label>
              <HStack
                align="stretch"
                gapX={"40px"}
                gapY={"24px"}
                flexWrap={"wrap"}
              >
                <RadioCard.Item
                  value="delivery"
                  minW={"200px"}
                  w={"calc((100% - 40px) / 2)"}
                  flex={"auto"}
                  rounded={"24px"}
                  dir={dir}
                >
                  <RadioCard.ItemHiddenInput />
                  <RadioCard.ItemControl>
                    <RadioCard.ItemContent>
                      <RadioCard.ItemText fontWeight={"bold"}>
                        {t("delivery")}
                      </RadioCard.ItemText>
                    </RadioCard.ItemContent>
                    <RadioCard.ItemIndicator />
                  </RadioCard.ItemControl>
                </RadioCard.Item>
                <RadioCard.Item
                  value="basra"
                  minW={"200px"}
                  w={"calc((100% - 40px) / 2)"}
                  flex={"auto"}
                  rounded={"24px"}
                  dir={dir}
                >
                  <RadioCard.ItemHiddenInput />
                  <RadioCard.ItemControl>
                    <RadioCard.ItemContent>
                      <RadioCard.ItemText fontWeight={"bold"}>
                        {t("branchPickup")}
                      </RadioCard.ItemText>
                    </RadioCard.ItemContent>
                    <RadioCard.ItemIndicator />
                  </RadioCard.ItemControl>
                </RadioCard.Item>
              </HStack>
            </RadioCard.Root>
          </GroupContainer>
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
              {orderType === "basra" ? (
                /* branch pickup */
                <DropSelectList
                  label={t("branch")}
                  placeholder={t("selectBranch")}
                  isLoading={branchesIsLoading}
                  control={control}
                  list={
                    branchesData?.map((e) => ({
                      label: e?.name,
                      value: String(e?.id),
                    })) || []
                  }
                  name="branch_id"
                  err={!!errors?.branch_id?.message}
                  errMes={
                    !!errors.branch_id?.message
                      ? t(errors?.branch_id?.message)
                      : ""
                  }
                  triggerProps={{
                    bg: "#F9FAFB",
                    h: "auto",
                    p: "16px",
                    rounded: "16px",
                  }}
                />
              ) : (
                /* governorate */
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
              )}
            </HStack>
            <HStack
              gap={{ base: "14px", lg: "26px", xl: "40px" }}
              align={"start"}
              flexWrap={"wrap"}
            >
              {/* address input */}
              {orderType !== "basra" && (
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
              )}
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
          {orderType !== "basra" && (
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
                        (e) => e.id === +(watch("governorate_id") ?? 0),
                      )?.shipping_fee ?? 0) < 1 ? (
                        t("freeDelivery")
                      ) : (
                        <>
                          {
                            governorateData?.find(
                              (e) => e.id === +(watch("governorate_id") ?? 0),
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
          )}
          {/* payment methods */}
          <GroupContainer>
            <RadioCard.Root
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
