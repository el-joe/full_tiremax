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
  FaArrowLeft,
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
  const locale = useLocale();
  return (
    <>
      <HStack gap={"16px"} mb={"32px"}>
        <IconButton
          variant={"ghost"}
          color={"#6B7280"}
          onClick={() => goToPrevStep()}
        >
          {locale === "ar" ? <FaArrowRight /> : <FaArrowLeft />}
        </IconButton>
        <VStack align={"start"}>
          <Heading fontSize={{ base: "18px", md: "24px" }} fontWeight={"bold"}>
            {t("chooseNearestBranch")}
          </Heading>
          <Text color={"#6B7280"} fontSize={{ base: "12px", md: "16px" }}>
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
        <HStack flexWrap={"wrap"} gap={{ base: "10px", lg: "16px" }}>
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
      h={"-webkit-fill-available"}
      w={{
        base: "full",
        md: "calc((100% - 10px) / 2 )",
        lg: "calc((100% - 16px) / 2 )",
      }}
    >
      <Image
        src={"/images/branchCardImage.jpg"}
        alt="bg"
        w={{ base: "92px", lg: "160px" }}
        h={"full"}
      />
      <VStack
        p={{ base: "8px", lg: "20px" }}
        gap={{ base: "8px", lg: "18px" }}
        align={"stretch"}
        flex={1}
      >
        <HStack justify={"space-between"} align={"start"}>
          <Box>
            <Heading
              fontSize={{ base: "14px", lg: "18px" }}
              fontWeight={"extrabold"}
            >
              {data.name}
            </Heading>
            <HStack>
              <Icon color={"primary"} size={{ base: "xs", lg: "sm" }}>
                <FaStar />
              </Icon>
              <Text fontWeight={"bold"} fontSize={{ base: "12px", lg: "16px" }}>
                4.8
              </Text>
              <Text color={"gray-2"} fontSize={{ base: "12px", lg: "16px" }}>
                (288{t("rate")})
              </Text>
            </HStack>
          </Box>
          <HStack>
            <Icon color={"primary"} size={{ base: "sm", lg: "xl" }}>
              <TiLocationArrowOutline />
            </Icon>
            <Text fontSize={{ base: "12px", lg: "16px" }}>2.5 {t("km")}</Text>
          </HStack>
        </HStack>
        <VStack gap={{ base: "8px", lg: "12px" }} align={"start"}>
          <HStack gap={"12px"}>
            <Icon color={"primary"} size={{ base: "sm", lg: "md" }}>
              <SlLocationPin />
            </Icon>
            <Text fontSize={{ base: "9px", lg: "14px" }} color={"gray-2"}>
              {data?.address}
            </Text>
          </HStack>
          <HStack gap={"12px"}>
            <Icon color={"primary"} size={{ base: "sm", lg: "md" }}>
              <FiPhone />
            </Icon>
            <Text fontSize={{ base: "9px", lg: "14px" }} color={"gray-2"}>
              {data?.phone}
            </Text>
          </HStack>
          <HStack gap={"12px"}>
            <Icon color={"primary"} size={{ base: "sm", lg: "md" }}>
              <SlClock />
            </Icon>
            <Text fontSize={{ base: "9px", lg: "14px" }} color={"gray-2"}>
              {/* {formatTimeRange("09:00:00", "22:00:00", locale)} */}
              {formatTimeRange(
                data?.schedules[0]?.opens_at ?? "",
                data?.schedules[0]?.closes_at ?? "",
                locale,
              )}
            </Text>
          </HStack>
        </VStack>
        <Box pt={{ base: "10px", lg: "20px" }} borderTop={"1px solid #F3F4F6"}>
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
