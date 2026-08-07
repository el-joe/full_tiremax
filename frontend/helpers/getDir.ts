import { getLocale } from "next-intl/server";

export default async function getDir() {
    const locale = await getLocale()
    return locale === "ar" ? "rtl" : "ltr"
} 