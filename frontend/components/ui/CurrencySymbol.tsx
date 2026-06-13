"use client";
import { Span, TextProps } from "@chakra-ui/react";
import { useTranslations } from "next-intl";

interface props extends TextProps {
  type?: "short" | "long";
}

const CurrencySymbol = ({ type, ...rest }: props) => {
  const t = useTranslations();
  return (
    <Span display={"inline-block"} {...rest}>
      {type === "long" ? t("iraqiDinar") : t("iqd")}
    </Span>
  );
};

export default CurrencySymbol;
