import {
  Box,
  Center,
  Heading,
  HStack,
  Icon,
  Text,
  VStack,
} from "@chakra-ui/react";
import { getLocale, getTranslations } from "next-intl/server";
import { AiOutlineTool } from "react-icons/ai";
import { FaRegCalendarAlt, FaRegClock } from "react-icons/fa";
import { FiMapPin, FiPhone } from "react-icons/fi";
import { LuStickyNote } from "react-icons/lu";
import NeedHelpCard from "@/components/shared/NeedHelpCard";
import axiosInstance from "@/utils/axiosInstance";
import { IReservation } from "@/types";
import { redirect } from "next/navigation";
import ReservationSummary from "@/components/pages/profile/reservation/ReservationSummary";
import CancelReservationButton from "@/components/pages/profile/reservation/CancelReservationButton";
import { Link } from "@/i18n/navigation";
import { BiArrowBack } from "react-icons/bi";
import { BsArrowRight } from "react-icons/bs";

type props = {
  params: Promise<{ reservationId: string }>;
};

export default async function page({ params }: props) {
  const { reservationId } = await params;
  const t = await getTranslations("profile");
  const locale = await getLocale();
  try {
    const {
      data: { data },
    } = await axiosInstance<{ data: IReservation }>(
      `bookings/${reservationId}`,
    );
    return (
      <>
        <Link href={"/profile/reservation"}>
          <Icon size={"2xl"} strokeWidth={"1px"}>
            {locale === "ar" ? <BsArrowRight /> : <BiArrowBack />}
          </Icon>
        </Link>
        <VStack
          gap={"16px"}
          maxW={"445px"}
          mx={"auto"}
          mb={"32px"}
          textAlign={"center"}
        >
          <Heading fontSize="38px" fontWeight="extrabold">
            {t("reservationDetails")}
          </Heading>
          <Text fontSize={"18px"} color={"gray-2"}>
            {t("reservationDetailsDescription")}
          </Text>
        </VStack>
        <HStack align={"start"} justify={"center"} gap="40px" flexWrap={"wrap"}>
          {/* reservation details */}
          <VStack
            gap={"24px"}
            w={"528px"}
            align={"stretch"}
            textAlign={"start"}
          >
            <HStack
              gap={"16px"}
              px={"32px"}
              py={"16px"}
              borderStart={"4px solid {colors.primary}"}
              rounded={"8px"}
              bg="#FAFAFA"
              align="start"
            >
              <Center minW="48px" h={"48px"} bg="primary" rounded={"8px"}>
                <Icon size={"xl"} color={"white"}>
                  <AiOutlineTool />
                </Icon>
              </Center>
              <Box>
                <Text fontSize={"18px"} fontWeight={"bold"}>
                  {data.service.name}
                </Text>
                <Text fontSize={"14px"} color={"gray-2"}>
                  {data.duration_minutes} {t("minutes")}
                </Text>
              </Box>
            </HStack>
            {/*  */}
            <HStack
              gap={"16px"}
              px={"32px"}
              py={"16px"}
              borderStart={"4px solid {colors.primary}"}
              rounded={"8px"}
              bg="#FAFAFA"
              align="start"
            >
              <Center minW="48px" h={"48px"} bg="primary" rounded={"8px"}>
                <Icon size={"xl"} color={"white"}>
                  <FaRegCalendarAlt />
                </Icon>
              </Center>
              <Box>
                <Text fontSize={"18px"} fontWeight={"bold"}>
                  {t("date")}
                </Text>
                <HStack gap="16px">
                  <HStack>
                    <Icon color={"primary"} size={"sm"}>
                      <FaRegCalendarAlt />
                    </Icon>
                    <Text fontSize={"14px"} color={"gray-2"}>
                      {new Date(data.scheduled_at).toDateString()}
                    </Text>
                  </HStack>
                  <HStack>
                    <Icon color={"primary"} size={"sm"}>
                      <FaRegClock />
                    </Icon>
                    <Text fontSize={"14px"} color={"gray-2"}>
                      {new Date(data.scheduled_at)
                        .toLocaleTimeString()
                        .split(" ")
                        .map((e) => e.split(":").slice(0, 2).join(":"))
                        .join(" ")}
                    </Text>
                  </HStack>
                </HStack>
              </Box>
            </HStack>
            {/*  */}
            <HStack
              gap={"16px"}
              px={"32px"}
              py={"16px"}
              borderStart={"4px solid {colors.primary}"}
              rounded={"8px"}
              bg="#FAFAFA"
              align="start"
            >
              <Center minW="48px" h={"48px"} bg="primary" rounded={"8px"}>
                <Icon size={"xl"} color={"white"}>
                  <FiMapPin />
                </Icon>
              </Center>
              <Box>
                <Text fontSize={"18px"} fontWeight={"bold"}>
                  {data.branch.name}
                </Text>
                <Text fontSize={"14px"} color={"gray-2"}>
                  {data.branch.address}
                </Text>
                <HStack gap="6px" pt="4px">
                  <Icon color={"primary"} size={"sm"}>
                    <FiPhone />
                  </Icon>
                  <Text fontSize={"14px"} color={"gray-2"}>
                    {data.branch.phone}
                  </Text>
                </HStack>
              </Box>
            </HStack>
            {/*  */}
            {data.customer_notes && (
              <HStack
                gap={"16px"}
                px={"32px"}
                py={"16px"}
                borderStart={"4px solid {colors.primary}"}
                rounded={"8px"}
                bg="#FAFAFA"
                align="start"
              >
                <Center minW="48px" h={"48px"} bg="primary" rounded={"8px"}>
                  <Icon size={"xl"} color={"white"}>
                    <LuStickyNote />
                  </Icon>
                </Center>
                <Box>
                  <Text fontSize={"18px"} fontWeight={"bold"}>
                    {t("notes")}
                  </Text>
                  <Text fontSize={"14px"} color={"gray-2"}>
                    {data.customer_notes}
                  </Text>
                </Box>
              </HStack>
            )}
          </VStack>
          {/* reservation summary */}
          <VStack gap={"32px"} maxW={"392px"}>
            <ReservationSummary data={data} />
            {(data.status === "pending" || data.status === "confirmed") && (
              <CancelReservationButton reservationId={data.id} />
            )}
            <NeedHelpCard />
          </VStack>
        </HStack>
      </>
    );
  } catch {
    redirect(`/${locale}/profile/reservation`);
  }
}
