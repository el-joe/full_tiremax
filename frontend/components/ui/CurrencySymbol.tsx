"use client"
import { Text, TextProps } from '@chakra-ui/react'
import { useTranslations } from 'next-intl'

const CurrencySymbol = (props: TextProps) => {
    const t = useTranslations()
    return (
        <Text display={"inline-block"}{...props}>{t("iqd")}</Text>
    )
}

export default CurrencySymbol