"use client"
import { Span, TextProps } from '@chakra-ui/react'
import { useTranslations } from 'next-intl'

const CurrencySymbol = (props: TextProps) => {
    const t = useTranslations()
    return (
        <Span display={"inline-block"}{...props}>{t("iqd")}</Span>
    )
}

export default CurrencySymbol