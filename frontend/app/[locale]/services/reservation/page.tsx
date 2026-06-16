"use client";
import Container from "@/components/ui/Container";
import { useReservationContext } from "@/providers/ReservationProvider";
import { Center, Heading, Icon, Steps, Text, VStack } from "@chakra-ui/react";
import { useLocale, useTranslations } from "next-intl";
import { IconType } from "react-icons/lib";

export default function Page() {
  const { steps, useSteps } = useReservationContext();
  const t = useTranslations("reservation");
  const locale = useLocale();
  const dir = locale === "ar" ? "rlt" : "ltr";
  return (
    <Container>
      <Heading textAlign={"center"} fontSize={"36px"} fontWeight={"extrabold"}>
        {t("bookServiceAppointment")}
      </Heading>
      <Text
        textAlign={"center"}
        mt="16px"
        mb={"48px"}
        fontSize={"18px"}
        color={"gray-2"}
      >
        {t("bookServiceAppointmentDescription")}
      </Text>
      <Steps.RootProvider value={useSteps} dir={dir}>
        <Steps.List dir={dir} w={"740px"} mx={"auto"}>
          {steps.map((step, index) => (
            <Steps.Item key={step.id} index={index} dir={dir}>
              <Steps.Status
                complete={
                  <StepIndicator
                    status="complete"
                    stepName={step.stepName}
                    stepNum={step.stepNum}
                    icon={step.icon}
                  />
                }
                incomplete={
                  <StepIndicator
                    status="incomplete"
                    stepName={step.stepName}
                    stepNum={step.stepNum}
                    icon={step.icon}
                  />
                }
                current={
                  <StepIndicator
                    status="active"
                    stepName={step.stepName}
                    stepNum={step.stepNum}
                    icon={step.icon}
                  />
                }
              />
              <Steps.Separator h={"4px"} rounded={"full"} />
            </Steps.Item>
          ))}
        </Steps.List>

        {steps.map((step, index) => (
          <Steps.Content key={index} index={index} dir={dir} pt={"47px"}>
            {step.content}
          </Steps.Content>
        ))}
        <Steps.CompletedContent>All steps are complete!</Steps.CompletedContent>
      </Steps.RootProvider>
    </Container>
  );
}
const StepIndicator = ({
  stepName,
  stepNum,
  icon: StepIcon,
  status,
}: {
  stepName: string;
  stepNum: string;
  icon: IconType;
  status: "active" | "complete" | "incomplete";
}) => {
  const t = useTranslations("reservation");
  const IconStyle = {
    complete: {
      bg: "#00C950",
      color: "white",
      boxShadow: "0 10px 15px -3px #0000001A",
    },
    incomplete: {
      bg: "white",
      color: "#99A1AF",
      boxShadow: "0 10px 15px -3px #0000001A",
      border: "2px solid #E5E7EB",
    },
    active: {
      bg: "primary",
      boxShadow: "0 10px 15px -3px #FDB60480",
    },
  };
  return (
    <VStack gap={"4px"}>
      <Center w={"70px"} h={"70px"} rounded={"16px"} {...IconStyle[status]}>
        <Icon size={"2xl"}>
          <StepIcon />
        </Icon>
      </Center>
      <Text
        fontSize={"14px"}
        maxW={"90px"}
        textAlign={"center"}
        fontWeight={"bold"}
        color={status === "incomplete" ? "#6A7282" : "black"}
      >
        {t(stepName)}
      </Text>
      <Text fontSize={"12px"} color={"#99A1AF"}>
        {t(stepNum)}
      </Text>
    </VStack>
  );
};
