"use client";
import {
  Box,
  Center,
  Heading,
  HStack,
  Icon,
  RadioCard,
  Spinner,
  Text,
  VStack,
} from "@chakra-ui/react";
import { SubmitHandler, useForm } from "react-hook-form";
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
import { IGovernorate } from "@/types";
import { LuMapPin } from "react-icons/lu";
import { MdOutlineLocalShipping } from "react-icons/md";
import CurrencySymbol from "@/components/ui/CurrencySymbol";
import { FaMoneyBills, FaRegCreditCard } from "react-icons/fa6";
import { RiBankLine } from "react-icons/ri";
import { AxiosError } from "axios";
import toast from "react-hot-toast";
import useDir from "@/hooks/useDir";
import { useAuthContext } from "@/providers/AuthProvider";
const paymentMethods = [
  {
    icon: FaMoneyBills,
    value: "cod",
    title: "cashOnDelivery",
    description: "cashOnDeliveryDescription",
  },
  //   {
  //     icon: CiMobile1,
  //     value: "zainCash",
  //     title: "zainCash",
  //     description: "onlinePaymentViaZainCash",
  //   },
  {
    icon: RiBankLine,
    value: "transfer",
    title: "bankTransfer",
    description: "directTransferToOneOfOurAuthorizedBankAccounts",
  },
  {
    icon: FaRegCreditCard,
    value: "card",
    title: "card",
    description: "paymentViaCreditCard",
  },
  //   {
  //     icon: FaRegCalendarAlt,
  //     value: "installment",
  //     title: "installmentPayment",
  //     description: "exclusiveInstallmentPlan",
  //   },
];
export default function CheckoutForm() {
  const t = useTranslations("cartAndPayment");
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
    defaultValues: {
      customer_email: "example@mail.com",
    },
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

  const { mutate: createOrder, isPending: isCreatingOrder } = useMutation({
    mutationKey: ["createOrder"],
    mutationFn: async (data: CreateOrderInput) => {
      const body = {
        ...data,
        governorate_id: +data.governorate_id,
      };
      const { data: res } = await axiosInstance.post("orders", body);
      return res;
    },
    onError: () => {
      toast.error("Oops! something want wrang");
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
              <RadioCard.Label dir={dir}>
                <Heading mb={"40px"} fontSize={"24px"} fontWeight={"extrabold"}>
                  {t("paymentMethod")}
                </Heading>
              </RadioCard.Label>
              <HStack
                align="stretch"
                gapX={"40px"}
                gapY={"24px"}
                flexWrap={"wrap"}
              >
                {paymentMethods.map((item) => (
                  <RadioCard.Item
                    key={item.value}
                    value={item.value}
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
                              <item.icon />
                            </Icon>
                          </Center>
                          <Box>
                            <RadioCard.ItemText fontWeight={"bold"}>
                              {t(item.title)}
                            </RadioCard.ItemText>
                            <RadioCard.ItemDescription
                              fontSize={"12px"}
                              color={"gray-2"}
                            >
                              {t(item.description)}
                            </RadioCard.ItemDescription>
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

//   "deliveryService": "Delivery Service",
//     "": "Your order will be delivered to your address within the estimated timeframe.",
//     "estimatedDeliveryTime": "Estimated Delivery Time",
//     "businessDays": "Business Days",
//     "": "Delivery Fee",
//     "": "Payment method",
//     "cashOnDelivery": "Cash on Delivery",
//     "cashOnDeliveryDescription": "Pay cash on delivery.",
//     "zainCash": "Zain cash",
//     "onlinePaymentViaZainCash": "Online payment via zain cash",
//     "bankTransfer": "Bank transfer",
//     "directTransferToOneOfOurAuthorizedBankAccounts": "Direct transfer to on of our authorized bank accounts",
//     "installmentPayment": "Installment payment",
//     "exclusiveInstallmentPlan": "An exclusive flexible installment plan."
