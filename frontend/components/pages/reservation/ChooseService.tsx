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
        <Center>
          <Heading>Loading</Heading>
        </Center>
      ) : (
        <HStack flexWrap={"wrap"} gap={"24px"}>
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
      w={"calc((100% - 72px) / 4)"}
      p="24px"
      rounded={"16px"}
      border="1px solid {colors.gray-4}"
      align={"stretch"}
      gap={"16px"}
      boxShadow={"0 1px 2px -1px #0000001A, 0 1px 3px 0 #0000001A"}
    >
      <Center
        alignSelf={"start"}
        minW={"56px"}
        h={"56px"}
        rounded={"12px"}
        bg={"#FDB6041A"}
        color={"primary"}
      >
        <Icon size={"xl"}>
          {data?.icon ? <data.icon /> : <AiOutlineTool />}
        </Icon>
      </Center>
      <Box>
        <Heading fontSize={"18px"} fontWeight={"extrabold"} mb={"8px"}>
          {data?.name}
        </Heading>
        <Text fontSize={"14px"} color={"gray-2"} pb={"20px"}>
          {data?.description ?? "fixe your car today"}
        </Text>
      </Box>
      <Box>
        <HStack justify={"space-between"} mb={"8px"}>
          <Text fontSize={"14px"} color={"gray-2"}>
            {t("duration")}
          </Text>
          <Text fontSize={"14px"}>
            {data?.duration_minutes} {t("minute")}
          </Text>
        </HStack>
        <HStack justify={"space-between"} mb={"8px"}>
          <Text fontSize={"14px"} color={"gray-2"}>
            {t("cost")}
          </Text>
          <Text fontSize={"14px"} fontWeight={"bold"} color={"primary"}>
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
      <Box pt={"16px"} borderTop={"1px solid #F3F4F6"}>
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
