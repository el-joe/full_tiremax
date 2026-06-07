import { resolveLocale } from "@/helpers/resolveLocale";
import axios from "axios";

const baseAPI = process.env.NEXT_PUBLIC_BASE_API_URL;

const axiosInstance = axios.create({
  baseURL: baseAPI,
});

export default axiosInstance;

axiosInstance.interceptors.request.use(async (config) => {
  const locale = await resolveLocale();
  config.headers["x-locale"] = locale;
  return config;
});
