"use client"
import { Box, Button, Center, HStack, Text, VStack } from '@chakra-ui/react'
import React from 'react'
import Input from '../ui/Input'
import { useTranslations } from 'next-intl'
import { PhoneSignalIcon, SendMessageIcon, UserCircleIcon, WhatsappIcon } from '../Icons'
import Textarea from '../ui/Textarea'
import { Link } from '@/i18n/navigation'
import { useForm } from 'react-hook-form'

const ContactUsForm = () => {
    const t = useTranslations("home")
    const { handleSubmit } = useForm()
    const onSubmit = handleSubmit((data) => {
        console.log(data)
    })
    return (
        <form onSubmit={onSubmit}>
            <VStack gap="32px" rounded={"16px"} p="32px" border={"1px solid #E5E7EB"} alignItems={"stretch"} >
                <HStack gap={"32px"}>
                    <Input label={t("fullName")} placeholder={t("enterYourFullName")} startElement={<UserCircleIcon size={"md"} />} />
                    <Input label={t("phoneNumber")} placeholder={t("phoneNumberPlaceholder")} startElement={<PhoneSignalIcon size={"sm"} color={"gray-2"} />} />
                </HStack>
                <Input label={t("inquirySubject")} placeholder={t("inquiryAboutPrices")} w="576px" />
                <Textarea label={t("message")} placeholder={t("howCanWeHelpYouToday")} minH={"160px"} />
                <HStack justifyContent={"space-between"}>
                    <HStack>
                        <Text>{t("orContactImmediatelyVia")}</Text>
                        <Link href="/">
                            <Center bg="#41C452" rounded={"8px"} color={"white"} w="48px" h="48px"><WhatsappIcon size={"xl"} /></Center>
                        </Link>
                    </HStack>
                    <Button fontSize="20px" rounded={"16px"} px="48px" py="20px" type='submit'> <SendMessageIcon /> {t("sendMessage")}</Button>
                </HStack>
            </VStack>
        </form>
    )
}

export default ContactUsForm