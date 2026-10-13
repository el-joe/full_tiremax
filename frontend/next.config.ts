import type { NextConfig } from "next";
import createNextIntlPlugin from "next-intl/plugin";

const nextConfig: NextConfig = {
  allowedDevOrigins: ["127.0.0.1",'tiremaxiq.com'],
};

const withNextIntl = createNextIntlPlugin();
export default withNextIntl(nextConfig);
