import { useReservationContext } from "@/providers/ReservationProvider";
import { IBranch } from "@/types";
import {
  Box,
  Button,
  Center,
  Heading,
  HStack,
  Icon,
  IconButton,
  Image,
  Span,
  Text,
  VStack,
} from "@chakra-ui/react";
import { useLocale, useTranslations } from "next-intl";
import {
  FaArrowRight,
  FaChevronLeft,
  FaChevronRight,
  FaStar,
} from "react-icons/fa";
import { TiLocationArrowOutline } from "react-icons/ti";
import { SlClock, SlLocationPin } from "react-icons/sl";
import { FiPhone } from "react-icons/fi";
import formatTimeRange from "@/helpers/formatTimeRange";

export default function ChooseBranch() {
  const {
    useSteps: { goToPrevStep },
    reservationData,
    branchesList,
    isBranchesListLoading,
  } = useReservationContext();
  const t = useTranslations("reservation");
  return (
    <>
      <HStack gap={"16px"} mb={"32px"}>
        <IconButton
          variant={"ghost"}
          color={"#6B7280"}
          onClick={() => goToPrevStep()}
        >
          <FaArrowRight />
        </IconButton>
        <VStack align={"start"}>
          <Heading fontSize={"24px"} fontWeight={"bold"}>
            {t("chooseNearestBranch")}
          </Heading>
          <Text color={"#6B7280"}>
            {t("selectedService")}:
            <Span color={"primary"} ms={"3px"} fontWeight={"bold"}>
              {reservationData.service?.name}
            </Span>
          </Text>
        </VStack>
      </HStack>
      {isBranchesListLoading ? (
        <Center>
          <Heading>Loading</Heading>
        </Center>
      ) : (
        <HStack>
          {branchesList.map((branch) => (
            <BranchCard key={branch.id} data={branch} />
          ))}
        </HStack>
      )}
    </>
  );
}

const BranchCard = ({ data }: { data: IBranch }) => {
  const t = useTranslations("reservation");
  const locale = useLocale();
  const {
    setBrach,
    useSteps: { goToNextStep },
  } = useReservationContext();
  return (
    <HStack
      rounded={"16px"}
      border={"2px solid #E5E7EB"}
      boxShadow={"0 1px 2px -1px #0000001A, 0 1px 3px 0 #0000001A"}
      align={"start"}
      overflow={"hidden"}
      w={"calc((100% - 16px) / 2 )"}
      h={"268px"}
    >
      <Image
        src={"/images/branchCardImage.jpg"}
        alt="bg"
        w={"160px"}
        h={"268px"}
      />
      <VStack p={"20px"} gap={"18px"} align={"stretch"} flex={1}>
        <HStack justify={"space-between"} align={"start"}>
          <Box>
            <Heading fontSize={"18px"} fontWeight={"extrabold"}>
              {data.name}
            </Heading>
            <HStack>
              <Icon color={"primary"}>
                <FaStar />
              </Icon>
              <Text fontWeight={"bold"}>4.8</Text>
              <Text color={"gray-2"}>(288{t("rate")})</Text>
            </HStack>
          </Box>
          <HStack>
            <Icon color={"primary"} size={"xl"}>
              <TiLocationArrowOutline />
            </Icon>
            <Text>2.5 {t("km")}</Text>
          </HStack>
        </HStack>
        <VStack gap={"12px"} align={"start"}>
          <HStack gap={"12px"}>
            <Icon color={"primary"} size={"md"}>
              <SlLocationPin />
            </Icon>
            <Text fontSize={"14px"} color={"gray-2"}>
              {data?.address}
            </Text>
          </HStack>
          <HStack gap={"12px"}>
            <Icon color={"primary"} size={"md"}>
              <FiPhone />
            </Icon>
            <Text fontSize={"14px"} color={"gray-2"}>
              {data?.phone}
            </Text>
          </HStack>
          <HStack gap={"12px"}>
            <Icon color={"primary"} size={"md"}>
              <SlClock />
            </Icon>
            <Text fontSize={"14px"} color={"gray-2"}>
              {/* {formatTimeRange("09:00:00", "22:00:00", locale)} */}
              {formatTimeRange(
                data?.schedules[0]?.opens_at ?? "",
                data?.schedules[0]?.closes_at ?? "",
                locale,
              )}
            </Text>
          </HStack>
        </VStack>
        <Box pt={"20px"} borderTop={"1px solid #F3F4F6"}>
          <Button
            variant={"ghost"}
            color={"primary"}
            // w={"full"}
            _hover={{ color: "white" }}
            onClick={() => {
              setBrach(data?.id);
              goToNextStep();
            }}
          >
            {t("chooseThisService")}{" "}
            <Icon size={"sm"}>
              {locale === "ar" ? <FaChevronLeft /> : <FaChevronRight />}
            </Icon>
          </Button>
        </Box>
      </VStack>
    </HStack>
  );
};
