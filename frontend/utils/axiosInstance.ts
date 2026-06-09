import axios from "axios";
import { resolveApiFilters } from "@/helpers/resolveApiFilters";
import { resolveLocale } from "@/helpers/resolveLocale";

const axiosInstance = axios.create({
  baseURL: process.env.NEXT_PUBLIC_BASE_API_URL,
});

axiosInstance.interceptors.request.use(async (config) => {
  const [locale, filters] = await Promise.all([
    resolveLocale(),
    resolveApiFilters(),
  ]);

  config.headers = config.headers ?? {};
  config.headers["x-locale"] = locale;

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

export default axiosInstance;
