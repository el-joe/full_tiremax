import { routing } from "@/i18n/routing";
import { getLocale } from "next-intl/server";

export async function resolveLocale(): Promise<string> {
  if (typeof window === "undefined") {
    return await getLocale();
  }

  const pathname = window.location.pathname;

  const locale = routing.locales.find(
    (locale) => pathname === `/${locale}` || pathname.startsWith(`/${locale}/`)
  );

  return locale ?? routing.defaultLocale;
}
