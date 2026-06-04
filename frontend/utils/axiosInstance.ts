import axios from "axios";

const baseAPI = process.env.NEXT_PUBLIC_BASE_API_URL;

const axiosInstance = axios.create({
  baseURL: baseAPI,
});

export default axiosInstance;
