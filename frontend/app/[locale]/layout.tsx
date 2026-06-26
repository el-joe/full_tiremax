import type { Metadata } from "next";
import { Geist, Geist_Mono, Almarai } from "next/font/google";
import "./globals.css";
import { getLocale } from "next-intl/server";
import { NextIntlClientProvider } from "next-intl";
import ReactQueryProvider from "@/providers/ReactQueryProvider";
import { Toaster } from "react-hot-toast";
import { NuqsAdapter } from "nuqs/adapters/next/app";
import "swiper/css";
import "swiper/css/pagination";
import "swiper/css/navigation";
import "swiper/css/thumbs";
import "swiper/css/free-mode";
import Header from "@/components/layout/Header";
import { ChakraUiProvider } from "@/providers/ChakraUiProvider";
import Footer from "@/components/layout/Footer";
import { CartProvider } from "@/providers/CartProvider";
import { AuthProvider } from "@/providers/AuthProvider";
import { FavProvider } from "@/providers/FavProvider";
import { ProductFilterProvider } from "@/providers/ProductFilterProvider";
import AuthDialog from "@/components/dialogs/AuthDialog";
import getDir from "@/helpers/getDir";

const geistSans = Geist({
  variable: "--font-geist-sans",
  subsets: ["latin"],
});

const geistMono = Geist_Mono({
  variable: "--font-geist-mono",
  subsets: ["latin"],
});
// arabic font
const almarai = Almarai({
  weight: ["300", "400", "700", "800"],
  variable: "--font-almarai",
  subsets: ["latin"],
});

export const metadata: Metadata = {
  title: {
    default: "TIREMAX",
    template: "TIREMAX | %s",
  },
  description:
    "TireMax Iraq – Iraq’s leading online store for tires, batteries, and car oils. Shop Bridgestone, Nexen, Kumho, Pirelli, and more at competitive prices with fast delivery across Iraq, genuine warranty, and trusted automotive products",
  keywords: ["tires", "car tires", "tiremax", "iraq tires", "bridgestone"],
  icons: {
    icon: "/images/logo.svg",
  },
};

export default async function RootLayout({
  children,
}: Readonly<{
  children: React.ReactNode;
}>) {
  const locale = await getLocale();
  const dir = await getDir();
  return (
    <html
      lang={locale}
      dir={dir}
      suppressHydrationWarning
      className={`${geistSans.variable} ${geistMono.variable} ${almarai.variable} h-full antialiased`}
    >
      <body suppressHydrationWarning className="bg-black pb-20! md:pb-0!">
        <NuqsAdapter>
          <NextIntlClientProvider>
            <ReactQueryProvider>
              <ChakraUiProvider>
                <AuthProvider>
                  <FavProvider>
                    <CartProvider>
                      <ProductFilterProvider>
                        <Toaster
                          position="bottom-right"
                          toastOptions={{ duration: 6000 }}
                        />
                        <Header />
                        <main className="md:pt-26">{children}</main>
                        <Footer />
                        {/* dialogs */}
                        <AuthDialog />
                      </ProductFilterProvider>
                    </CartProvider>
                  </FavProvider>
                </AuthProvider>
              </ChakraUiProvider>
            </ReactQueryProvider>
          </NextIntlClientProvider>
        </NuqsAdapter>
      </body>
    </html>
  );
}
