import axios from "axios";
import { resolveApiFilters } from "@/helpers/resolveApiFilters";
import { resolveLocale } from "@/helpers/resolveLocale";
import { resolveApiPagination } from "@/helpers/resolveApiPagination";
import resolveCookie from "@/helpers/resolveCookie";
import { getLocale } from "next-intl/server";
import { redirect } from "next/navigation";

const axiosInstance = axios.create({
  baseURL: process.env.NEXT_PUBLIC_BASE_API_URL,
});

// ─── Request Interceptor ────────────────────────────────────────────────────
axiosInstance.interceptors.request.use(async (config) => {
  const [token, locale, filters, pagination] = await Promise.all([
    resolveCookie("tiremax_token"),
    resolveLocale(),
    resolveApiFilters(),
    resolveApiPagination(),
  ]);

  config.headers = config.headers ?? {};
  config.headers["x-locale"] = locale;
  config.headers.Authorization = `Bearer ${token}`;
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
