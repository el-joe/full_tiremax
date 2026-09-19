import { getCookie, setCookie, deleteCookie } from "cookies-next";

export const GUEST_COOKIE = "tiremax_guest";
const ONE_YEAR = 60 * 60 * 24 * 365;
export const GUEST_TOKEN_RE = /^[A-Za-z0-9_-]{16,64}$/;

export const generateGuestToken = (): string =>
  typeof crypto !== "undefined" && "randomUUID" in crypto
    ? crypto.randomUUID()
    : `${Date.now().toString(36)}-${Math.random().toString(36).slice(2)}-${Math.random().toString(36).slice(2)}`;

/** Browser only: read the guest token, creating + persisting it when missing. */
export function getOrCreateGuestToken(): string | undefined {
  if (typeof window === "undefined") return undefined;
  const existing = getCookie(GUEST_COOKIE);
  if (typeof existing === "string" && GUEST_TOKEN_RE.test(existing)) {
    return existing;
  }
  const token = generateGuestToken();
  setCookie(GUEST_COOKIE, token, {
    maxAge: ONE_YEAR,
    sameSite: "lax",
    path: "/",
  });
  return token;
}

export function clearGuestToken() {
  if (typeof window === "undefined") return;
  deleteCookie(GUEST_COOKIE, { path: "/" });
}
