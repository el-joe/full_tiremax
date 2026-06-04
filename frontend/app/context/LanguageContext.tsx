"use client";
import { createContext, useContext, useState, ReactNode } from "react";
import ar from "../../messages/ar.json";
import en from "../../messages/en.json";

type Locale = "ar" | "en";
type Messages = typeof ar;

interface LanguageContextType {
  locale: Locale;
  t: Messages;
  toggleLocale: () => void;
  dir: "rtl" | "ltr";
}

const LanguageContext = createContext<LanguageContextType | null>(null);

export function LanguageProvider({ children }: { children: ReactNode }) {
  const [locale, setLocale] = useState<Locale>("ar");

  const toggleLocale = () => setLocale((prev) => (prev === "ar" ? "en" : "ar"));

  const t = locale === "ar" ? ar : (en as unknown as Messages);
  const dir = locale === "ar" ? "rtl" : "ltr";

  return (
    <LanguageContext.Provider value={{ locale, t, toggleLocale, dir }}>
      <div dir={dir} lang={locale} style={{ fontFamily: "'Almarai', sans-serif" }}>
        {children}
      </div>
    </LanguageContext.Provider>
  );
}

export function useLang() {
  const ctx = useContext(LanguageContext);
  if (!ctx) throw new Error("useLang must be used inside LanguageProvider");
  return ctx;
}
