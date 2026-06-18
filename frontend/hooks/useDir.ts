"use client"
import { useLocale } from "next-intl";

export default function useDir() {
    const locale = useLocale()
    return locale === "ar" ? "rtl" : "ltr"

}