import Container from "@/components/ui/Container";
import { Link } from "@/i18n/navigation";
import {
  Box,
  Button,
  Center,
  Flex,
  Grid,
  GridItem,
  Heading,
  Icon,
  Image,
  List,
  Text,
  VStack,
} from "@chakra-ui/react";
import { getTranslations } from "next-intl/server";
import React from "react";
import { BsClipboardData, BsDatabase, BsShieldLock } from "react-icons/bs";
import { FiPhone } from "react-icons/fi";
import { GoDatabase } from "react-icons/go";
import { MdMailOutline } from "react-icons/md";

export default async function page() {
  const t = await getTranslations("privacyPolicy");
  return (
    <Container>
      <Heading
        fontSize={{ base: "22px", md: "38px" }}
        fontWeight={"extrabold"}
        textAlign={"center"}
        mb={{ md: "28px" }}
      >
        {t("privacyPolicy")}
      </Heading>
      <Text
        fontSize={{ base: "14px", md: "18px" }}
        color={"gray-2"}
        maxW={"670px"}
        textAlign={"center"}
        mx="auto"
      >
        {t("privacyPolicyDescription")}
      </Text>
      <Grid mt="54px" gridTemplateColumns={"repeat(12, 1fr)"} gap={"32px"}>
        {/* data collection card */}
        <GridItem colSpan={{ base: 12, lg: 8 }}>
          <Flex
            p={{ base: "14px", lg: "40px" }}
            bg="gray-4"
            rounded={"12px"}
            gap={"16px"}
          >
            <Center minW="54px" h="54px" bg="primary" rounded="12px">
              <Icon color={"white"} size={"xl"} strokeWidth={"0.6px"}>
                <GoDatabase />
              </Icon>
            </Center>
            <Box>
              <Heading mb="23px" fontSize={"36px"} fontWeight={"bold"}>
                {t("dataCollection")}
              </Heading>
              <Text
                maxW={"420px"}
                color="gray"
                fontSize={"18px"}
                my={"23px 16px"}
              >
                {t("dataCollectionDescription")}
              </Text>
              <List.Root
                listStyle={"none"}
                maxW={"420px"}
                gap={"7px"}
                ps={"16px"}
                borderStart={"4px solid {colors.primary}"}
              >
                <List.Item color={"gray"} fontSize={"18px"}>
                  {t("personalInformation")}
                </List.Item>
                <List.Item color={"gray"} fontSize={"18px"}>
                  {t("vehicleData")}
                </List.Item>
                <List.Item color={"gray"} fontSize={"18px"}>
                  {t("paymentInformation")}
                </List.Item>
                <List.Item color={"gray"} fontSize={"18px"}>
                  {t("locationData")}
                </List.Item>
              </List.Root>
            </Box>
          </Flex>
        </GridItem>
        {/* image banner card */}
        <GridItem colSpan={{ base: 12, lg: 4 }}>
          <Flex
            rounded={"12px"}
            overflow={"hidden"}
            position={"relative"}
            h="full"
            zIndex={2}
            align={"end"}
            p={"32px"}
          >
            <Image
              src={"/images/privacyPolicyBannerBg.png"}
              alt="bg"
              position={"absolute"}
              inset={"0"}
              h={"full"}
              w="full"
              zIndex="0"
            />
            <Box bg={"black/40"} position={"absolute"} inset={0} />
            <Text
              color="primary"
              zIndex={1}
              fontSize={"20px"}
              fontWeight={"black"}
              w={"165px"}
            >
              PRECISION PERFORMANCE
            </Text>
          </Flex>
        </GridItem>
        {/* how we use information card */}
        <GridItem colSpan={{ base: 12, lg: 6 }}>
          <VStack
            p={{ base: "14px", lg: "40px" }}
            rounded="12px"
            borderStart={"4px solid {colors.primary}"}
            align={"start"}
            gap={"16px"}
          >
            <Icon color={"primary"} size={"xl"}>
              <BsClipboardData />
            </Icon>
            <Heading fontSize={"24px"} fontWeight={"bold"}>
              {t("howWeUseInformation")}
            </Heading>
            <Text maxW={"370px"}>{t("howWeUseInformationDescription")}</Text>
          </VStack>
        </GridItem>
        {/* data protection card */}
        <GridItem colSpan={{ base: 12, lg: 6 }}>
          <VStack
            p={{ base: "14px", lg: "40px" }}
            rounded="12px"
            align={"start"}
            bg="gray-4"
            gap={"16px"}
          >
            <Icon color={"primary"} size={"xl"}>
              <BsShieldLock />
            </Icon>
            <Heading fontSize={"24px"} fontWeight={"bold"}>
              {t("dataProtection")}
            </Heading>
            <Text maxW={"370px"}>{t("dataProtectionDescription")}</Text>
          </VStack>
        </GridItem>
        {/* user rights card */}
        <GridItem colSpan={12}>
          <Flex
            bg={"black"}
            rounded={"12px"}
            p={{ base: "14px", lg: "40px" }}
            justify={"space-between"}
            align={"center"}
          >
            <Box maxW={"530px"}>
              <Heading
                fontSize={"30px"}
                fontWeight={"black"}
                color={"primary"}
                mb="16px"
              >
                {t("userRights")}
              </Heading>
              <Text color={"gray-4"} fontSize="18px">
                {t("userRightsDescription")}
              </Text>
            </Box>
            <Flex gap="16px">
              <Link href={"/#contact-area"}>
                <Button p="16px 32px" rounded="12px">
                  {t("contactUs")}
                </Button>
              </Link>
              {/* <Button p="16px 32px" rounded="12px" bg="gray-3">
                {t("requestData")}
              </Button> */}
            </Flex>
          </Flex>
        </GridItem>
        {/* support links card */}
        <GridItem colSpan={12}>
          <VStack
            gap={"12px"}
            rounded={"12px"}
            p={{ base: "14px", lg: "48px" }}
            bg="gray-4"
          >
            <Heading fontSize={"20px"} fontWeight={"bold"}>
              {t("havePrivacyQuestions")}
            </Heading>
            <Text color={"gray-2"}>{t("havePrivacyQuestionsDescription")}</Text>
            <Flex gap={{ base: "12px", lg: "48px" }} pt="16px">
              <Link href={"mailto:privacy@tiremax-iq.com"}>
                <VStack gap={"8px"}>
                  <Icon color={"primary"} size={"xl"}>
                    <MdMailOutline />
                  </Icon>
                  <Text fontWeight={"bold"}>privacy@tiremax-iq.com</Text>
                </VStack>
              </Link>
              <Link href={"tel:+964 000 000 0000"}>
                <VStack gap={"8px"} dir="ltr">
                  <Icon color={"primary"} size={"xl"}>
                    <FiPhone />
                  </Icon>
                  <Text fontWeight={"bold"}>+964 000 000 0000</Text>
                </VStack>
              </Link>
            </Flex>
          </VStack>
        </GridItem>
      </Grid>
    </Container>
  );
}

// "": "سياسة الخصوصية",
// "": "في Tire Max Iraq، نلتزم بحماية خصوصيتك وضمان أمان بياناتك الشخصية. توضح هذه السياسة كيفية تعاملنا مع معلوماتك بكل شفافية ودقة.",
// "": "جمع البيانات",
// "": "نقوم بجمع المعلومات التي تقدمها لنا مباشرة عند استخدام خدماتنا، بما في ذلك:",
// "": "المعلومات الشخصية: الاسم، عنوان البريد الإلكتروني، ورقم الهاتف.",
// "": "بيانات المركبة: نوع السيارة، قياس الإطارات، وتاريخ الصيانة.",
// "": "معلومات الدفع: تفاصيل المعاملات المالية (تتم معالجتها عبر قنوات مشفرة).",
// "": "الموقع الجغرافي: لتقديم خدمات المساعدة على الطريق وتحديد أقرب فرع.",
// "": "كيفية استخدام المعلومات",
// "": "نستخدم بياناتك لتحسين تجربة قيادتك، وتخصيص العروض التقنية، وضمان سلامة إطاراتك من خلال تنبيهات الصيانة الدورية. نحن لا نقوم ببيع بياناتك لأطراف ثالثة لأغراض تسويقية.",
// "": "حماية البيانات",
// "": "نطبق بروتوكولات تشفير عسكرية (AES-256) لحماية قواعد بياناتنا. يتم تقييد الوصول إلى المعلومات الشخصية فقط للموظفين الذين يحتاجون إليها لخدمتك.",
// "": "حقوق المستخدم",
// "": "لديك الحق الكامل في الوصول إلى بياناتك، تصحيحها، أو طلب مسحها نهائياً من أنظمتنا. يمكنك أيضاً الاعتراض على معالجة بياناتك في أي وقت.",
// "": "هل لديك استفسارات حول الخصوصية؟",
// "": "فريقنا القانوني والتقني جاهز للإجابة على جميع تساؤلاتك.",
// "": "طلب البيانات",
// "": "تواصل معنا"
