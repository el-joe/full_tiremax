import { EmailFastIcon, LocationPinIcon, PhoneSignalIcon } from '@/components/Icons'
import { Badge, Box, Center, Container, Heading, HStack, Text, VStack } from '@chakra-ui/react'
import { getTranslations } from 'next-intl/server'
import React from 'react'
import ContactUsForm from './ContactUsForm'

const ContactUsSection = async () => {
    const t = await getTranslations("home")
    return (
        <Container bg="white" py="80px" roundedTop={"50px"} overflow={"hidden"}>
            <VStack alignItems={"center"} gap={"24px"} mb={"48px"}>
                <Heading as="h2" fontSize={"38px"} fontWeight={"bold"}>{t("contactUs")}</Heading>
                <Text maxW={"527px"} textAlign={"center"} fontSize="18px">{t("contactUsDescription")}</Text>
                <Box h="8px" w={"96px"} bg="primary" rounded={"12px"} />
            </VStack>
            <HStack gap={"48px"} alignItems={"start"}>
                <VStack flex={1} gap={"24px"} alignItems={"start"}>
                    <HStack gap={"16px"} rounded={"16px"} p="32px" border={"1px solid #E5E7EB"} w={"full"}>
                        <Center bg="primary" rounded={"16px"} color={"white"} w="64px" h="64px"><PhoneSignalIcon size={"lg"} /></Center>
                        <Box>
                            <Text fontSize={"14px"} fontWeight={"semibold"} color={"gray-2"}>{t("customerServiceNumber")}</Text>
                            <Text fontSize={"36px"} fontWeight={"extrabold"}>6622</Text>
                        </Box>
                    </HStack>
                    <HStack gap={"16px"} rounded={"16px"} p="32px" border={"1px solid #E5E7EB"} w={"full"}>
                        <Center bg="primary" rounded={"16px"} color={"white"} w="64px" h="64px"><EmailFastIcon size={"lg"} /></Center>
                        <Box>
                            <Text fontSize={"14px"} fontWeight={"semibold"} color={"gray-2"}>{t("email")}</Text>
                            <Text fontSize={"20px"} fontWeight={"bold"}>support@tiremax.iq</Text>
                        </Box>
                    </HStack>
                    <HStack gap={"16px"} rounded={"16px"} p="32px" border={"1px solid #E5E7EB"} w={"full"}>
                        <Center bg="primary" rounded={"16px"} color={"white"} w="64px" h="64px"><LocationPinIcon size={"lg"} /></Center>
                        <Box>
                            <Text fontSize={"14px"} fontWeight={"semibold"} color={"gray-2"}>{t("headOffice")}</Text>
                            <Text fontSize={"20px"} fontWeight={"bold"}>{t("headOfficeAddress")}</Text>
                        </Box>
                    </HStack>
                    <HStack gap={"16px"} rounded={"16px"} p="32px" border={"1px solid #E5E7EB"} w={"full"}>
                        <Center bg="primary" rounded={"16px"} color={"white"} w="64px" h="64px"><LocationPinIcon size={"lg"} /></Center>
                        <Box>
                            <Text fontSize={"14px"} fontWeight={"semibold"} color={"gray-2"}>{t("branch2")}</Text>
                            <Text fontSize={"20px"} fontWeight={"bold"}>{t("branch2Address")}</Text>
                        </Box>
                    </HStack>
                </VStack>
                <ContactUsForm />
            </HStack>
        </Container>
    )
}

export default ContactUsSection


