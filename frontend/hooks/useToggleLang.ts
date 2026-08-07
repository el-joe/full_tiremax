"use client";
import { usePathname, useRouter } from "@/i18n/navigation";
import { useLocale } from "next-intl";
import { useSearchParams } from "next/navigation";

const useToggleLang = () => {
  const locale = useLocale();
  const router = useRouter();
  const pathname = usePathname();
  const params = useSearchParams();

  const changeLanguage = (newLocale: "en" | "ar") => {
    const currentParams = new URLSearchParams(Array.from(params.entries()));
    router.replace(`${pathname}?${currentParams}`, {
      locale: newLocale,
    });
  };
  const handleToggleLang = () => {
    changeLanguage(locale === "en" ? "ar" : "en");
  };
  return handleToggleLang;
};

export default useToggleLang;
