import { getCookie } from "cookies-next";
import { getCookieServer } from "./cookieServer";

export default async function resolveCookie(
  cookieName: string,
): Promise<string> {
  if (typeof window === "undefined") {
    return (await getCookieServer(cookieName)) as string;
  }
  return getCookie(cookieName) as string;
}
