import axios from "axios";
import { resolveApiFilters } from "@/helpers/resolveApiFilters";
import { resolveLocale } from "@/helpers/resolveLocale";
import { resolveApiPagination } from "@/helpers/resolveApiPagination";
import resolveCookie from "@/helpers/resolveCookie";
import { getLocale } from "next-intl/server";
import { redirect } from "next/navigation";
import { getOrCreateGuestToken, GUEST_COOKIE } from "@/helpers/guestToken";

const axiosInstance = axios.create({
  baseURL: process.env.NEXT_PUBLIC_BASE_API_URL,
});

// Endpoints that require an authenticated customer (everything else is public / guest-capable)
const PROTECTED_SEGMENTS = [
  "addresses",
  "favorites",
  "notifications",
  "reviews",
  "auth/me",
];
function isProtectedEndpoint(url?: string, method?: string): boolean {
  const path = (url ?? "").split("?")[0].replace(/^\/+|\/+$/g, "");
  if ((method ?? "get").toLowerCase() === "get" && (path === "orders" || path === "bookings")) {
    return true;
  }
  return PROTECTED_SEGMENTS.some((s) => path === s || path.startsWith(`${s}/`));
}

// ─── Request Interceptor ────────────────────────────────────────────────────
axiosInstance.interceptors.request.use(async (config) => {
  const [token, guestCookie, locale, filters, pagination] = await Promise.all([
    resolveCookie("tiremax_token"),
    resolveCookie(GUEST_COOKIE),
    resolveLocale(),
    resolveApiFilters(),
    resolveApiPagination(),
  ]);

  config.headers = config.headers ?? {};
  config.headers["x-locale"] = locale;
  if (token) config.headers.Authorization = `Bearer ${token}`;
  const guestToken =
    typeof window === "undefined" ? guestCookie : getOrCreateGuestToken();
  if (guestToken) config.headers["X-Guest-Token"] = guestToken;
  config.params = {
    ...(config.params ?? {}),
    ...pagination,
  };

  const endpointFilter = filters.find((filter) => {
    const urlSegments = config.url?.split("?")[0].split("/").filter(Boolean);

    return urlSegments?.includes(filter.targetEndpoint);
  });

  if (endpointFilter) {
    config.params = {
      ...(config.params ?? {}),
      ...endpointFilter.filters,
    };
  }

  return config;
});

// ─── Response Interceptor ────────────────────────────────────────────────────

axiosInstance.interceptors.response.use(
  (response) => response,
  async (error) => {
    if (error?.status === 401) {
      if (typeof window === "undefined") return Promise.reject(error);
      // guests may hit guest-capable endpoints: never bounce them to login
      if (!isProtectedEndpoint(error?.config?.url, error?.config?.method)) {
        return Promise.reject(error);
      }
      // // 1. Get current parameters from the browser URL
      // const urlParams = new URLSearchParams(window.location.search);

      // // 2. Set or update a specific parameter
      // urlParams.set("authDialog", "on");

      // // 3. Update the browser address bar smoothly
      // const newRelativePathQuery =
      //   window.location.pathname + "?" + urlParams.toString();
      // history.pushState(null, "", newRelativePathQuery);
      const locale = await getLocale();
      redirect(`/${locale}?authDialog=on`);
    }
    return Promise.reject(error);
  },
);

export default axiosInstance;
