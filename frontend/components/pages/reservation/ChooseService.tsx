import ServiceCardsSkeleton from "@/components/skeletons/ServiceCardsSkeleton";
import CurrencySymbol from "@/components/ui/CurrencySymbol";
import { useReservationContext } from "@/providers/ReservationProvider";
import { IService } from "@/types";
import {
  Box,
  Button,
  Center,
  Heading,
  HStack,
  Icon,
  Spinner,
  Text,
  VStack,
} from "@chakra-ui/react";
import { useLocale, useTranslations } from "next-intl";
import { AiOutlineTool } from "react-icons/ai";
import { FaChevronLeft, FaChevronRight } from "react-icons/fa";

export default function ChooseService() {
  const t = useTranslations("reservation");
  const { servicesList, isServicesListLoading } = useReservationContext();
  return (
    <>
      <Heading
        textAlign={"center"}
        fontSize={"24px"}
        fontWeight={"bold"}
        mb={"8px"}
      >
        {t("chooseRequiredService")}
      </Heading>
      <Text textAlign={"center"} color={"gray-2"} mb={"32px"}>
        {t("chooseRequiredServiceDescription")}
      </Text>
      {isServicesListLoading ? (
        <ServiceCardsSkeleton />
      ) : (
        <HStack
          flexWrap={"wrap"}
          gap={{ base: "12px", md: "18px", lg: "24px" }}
          align={"stretch"}
        >
          {servicesList?.map((service) => (
            <ServiceCard key={service.id} data={service} />
          ))}
        </HStack>
      )}
    </>
  );
}

const ServiceCard = ({ data }: { data: IService }) => {
  const {
    useSteps: { goToNextStep },
    setService,
  } = useReservationContext();
  const t = useTranslations("reservation");
  const locale = useLocale();
  return (
    <VStack
      w={{
        base: "calc((100% - 12px) / 2)",
        md: "calc((100% - 54px) / 4)",
        lg: "calc((100% - 72px) / 4)",
      }}
      p={{ base: "12px", lg: "24px" }}
      rounded={"16px"}
      border="1px solid {colors.gray-4}"
      align={"stretch"}
      gap={{ base: "7px", lg: "16px" }}
      boxShadow={"0 1px 2px -1px #0000001A, 0 1px 3px 0 #0000001A"}
    >
      <Center
        alignSelf={"start"}
        minW={{ base: "32px", lg: "56px" }}
        h={{ base: "32px", lg: "56px" }}
        rounded={{ base: "6px", lg: "12px" }}
        bg={"#FDB6041A"}
        color={"primary"}
      >
        <Icon size={{ base: "md", lg: "xl" }}>
          {data?.icon ? <data.icon /> : <AiOutlineTool />}
        </Icon>
      </Center>
      <Box>
        <Heading
          fontSize={{ base: "14px", lg: "18px" }}
          fontWeight={"extrabold"}
          mb={{ base: "3px", lg: "8px" }}
        >
          {data?.name}
        </Heading>
        <Text
          fontSize={{ base: "11px", lg: "14px" }}
          color={"gray-2"}
          pb={{ base: "10px", lg: "20px" }}
        >
          {data?.description}
        </Text>
      </Box>
      <Box>
        <HStack justify={"space-between"} mb={"8px"}>
          <Text fontSize={{ base: "11px", lg: "14px" }} color={"gray-2"}>
            {t("duration")}
          </Text>
          <Text fontSize={{ base: "11px", lg: "14px" }}>
            {data?.duration_minutes} {t("minute")}
          </Text>
        </HStack>
        <HStack justify={"space-between"} mb={"8px"}>
          <Text fontSize={{ base: "11px", lg: "14px" }} color={"gray-2"}>
            {t("cost")}
          </Text>
          <Text
            fontSize={{ base: "11px", lg: "14px" }}
            fontWeight={"bold"}
            color={"primary"}
          >
            {data?.price < 1 ? (
              t("free")
            ) : (
              <>
                {data?.price.toLocaleString()} <CurrencySymbol />
              </>
            )}
          </Text>
        </HStack>
      </Box>
      <Box
        pt={{ base: "8px", lg: "16px" }}
        borderTop={"1px solid #F3F4F6"}
        mt={"auto"}
      >
        <Button
          variant={"ghost"}
          color={"primary"}
          w={"full"}
          _hover={{ color: "white" }}
          onClick={() => {
            setService(data?.id);
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
  );
};
