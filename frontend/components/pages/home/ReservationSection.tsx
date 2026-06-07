import { CalenderIcon, CheckCircleIcon, LeftArrowIcon, SpannerIcon, StarsIcon } from '@/components/Icons'
import { Badge, Box, Button, Container, Heading, Highlight, HStack, Image, List, Text } from '@chakra-ui/react'
import { getLocale, getTranslations } from 'next-intl/server'
import React from 'react'

const ReservationSection = async () => {
  const t = await getTranslations("home")
  const locale = await getLocale()
  return (
    <Container bg="primary" mb="21px" p={{ base: "40px", md: "60px", xl: "112px" }}>
      <HStack gap={{ base: "34px", md: "60px", xl: "130px" }} flexDir={{ base: "column-reverse", lg: "row" }}>
        <Box flex="1">
          <Badge bg={"#FFFFFF33"} border={"1px solid #FFFFFF4D"} px="20px" py="9px" rounded="full" color={"white"} fontWeight={"bold"}> <StarsIcon size="sm" /> {t("quickAndEasyBooking")}</Badge>
          <Heading as={"h2"} fontSize={"48px"} fontWeight={'bold'} my={"28px"} lineHeight={"60px"}><Highlight query={t("now!")} styles={{ color: "white", display: "block" }} >{t("bookYourCarServiceNow")}</Highlight></Heading>
          <Text fontSize={"24px"}>{t("bookServiceDescription")}</Text>
          <List.Root gap="16px" variant="plain" mt="30px" mb={"40px"} fontSize={"18px"}>
            <List.Item alignItems={"center"}>
              <List.Indicator asChild>
                <Badge bg={"#FFFFFF4D"} color="black-2" p={"12px"} rounded="14px">
                  <CheckCircleIcon size={"md"} />
                </Badge>
              </List.Indicator>
              {t("smartBookingSystemWithoutConflicts")}
            </List.Item>
            <List.Item>
              <List.Indicator asChild>
                <Badge bg={"#FFFFFF4D"} color="black-2" p={"12px"} rounded="14px">
                  <SpannerIcon size={"md"} />
                </Badge>
              </List.Indicator>
              {t("professionalMaintenanceBySpecializedTeam")}
            </List.Item>
            <List.Item>
              <List.Indicator asChild>
                <Badge bg={"#FFFFFF4D"} color="black-2" p={"12px"} rounded="14px">
                  <CalenderIcon size={"md"} />
                </Badge>
              </List.Indicator>
              {t("chooseAppointmentAndBranch")}
            </List.Item>
          </List.Root>
          <Button bg="black-2" fontSize={"18px"} fontWeight={"semibold"}><CalenderIcon />{t("bookServiceNow")}<LeftArrowIcon rotate={locale === "en" ? "180deg" : "0"} /></Button>
        </Box>
        <Box flex="1"><Image src={locale === "ar" ? "/images/reservationSteps.png" : "/images/reservationStepsEN.png"} alt="" /></Box>
      </HStack>
    </Container>
  )
}

export default ReservationSection
