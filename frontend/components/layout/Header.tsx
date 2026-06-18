"use client";
import type { ButtonProps } from "@chakra-ui/react";
import { Button, Container, HStack } from "@chakra-ui/react";
import React from "react";
import {
  CarIcon,
  DeviceMaintenanceIcon,
  SearchIcon,
  SpannerIcon,
} from "../Icons";
import Logo from "../shared/Logo";
import { Link, usePathname } from "@/i18n/navigation";
import { useTranslations } from "next-intl";
import Input from "../ui/Input";
import useToggleLang from "@/hooks/useToggleLang";
import { Tooltip } from "../ui/tooltip";
import { CiHeart } from "react-icons/ci";
import { FaRegUserCircle } from "react-icons/fa";
import { LuBellDot } from "react-icons/lu";
import { FiShoppingCart } from "react-icons/fi";
import HeaderSearch from "./HeaderSearch";

const Header = () => {
  const t = useTranslations("header");
  const pathname = usePathname();
  const toggleLang = useToggleLang();
  return (
    <header>
      <Container pt={{ base: "16px", xl: "30px", "2xl": "40px" }}>
        <HStack
          justify={"center"}
          mb={{ base: "16px", xl: "30px", "2xl": "40px" }}
          gap={{ base: "8px", sm: "12px", xl: "20px" }}
          flexWrap={{ base: "wrap" }}
        >
          <Logo />
          <HStack gap={{ base: "2px", xl: "8px" }}>
            <HeaderButton
              href={"/"}
              variant={pathname === "/" ? "solid" : "ghost"}
            >
              {t("home")}
            </HeaderButton>
            <HeaderButton
              href={"/store"}
              variant={pathname === "/store" ? "solid" : "ghost"}
            >
              <CarIcon />
              {t("store")}
            </HeaderButton>
            <HeaderButton
              href={"/services"}
              variant={pathname === "/services" ? "solid" : "ghost"}
            >
              <SpannerIcon />
              {t("services")}
            </HeaderButton>
            <HeaderButton
              href={"/services/reservation"}
              variant={pathname === "/services/reservation" ? "solid" : "ghost"}
            >
              <DeviceMaintenanceIcon />
              {t("reservation")}
            </HeaderButton>
          </HStack>
          {/* search */}
          <HeaderSearch />
          {/* icon buttons */}
          <HStack
            gap={"8px"}
            justify={"space-evenly"}
            w={{ base: "90%", md: "auto" }}
            position={{ base: "fixed", md: "static" }}
            bottom={2}
            rounded={{ base: "full", md: "0" }}
            shadow={"xl"}
            zIndex={"10"}
            py={{ base: "12px" }}
            bg={{ base: "white", md: "none" }}
          >
            <Tooltip content={t("toggleLang")}>
              <HeaderButton onClick={toggleLang}>{t("locale")}</HeaderButton>
            </Tooltip>
            <Tooltip content={t("cart")}>
              <HeaderButton href={"/cart"}>
                <FiShoppingCart />
              </HeaderButton>
            </Tooltip>
            <Tooltip content={t("notifications")}>
              <HeaderButton href={"/"}>
                <LuBellDot />
              </HeaderButton>
            </Tooltip>
            <Tooltip content={t("profile")}>
              <HeaderButton href={"/"}>
                <FaRegUserCircle />
              </HeaderButton>
            </Tooltip>
            <Tooltip content={t("favorites")}>
              <HeaderButton href={"/favorites"}>
                <CiHeart strokeWidth={"2px"} />
              </HeaderButton>
            </Tooltip>
            <HeaderButton href={"/services/reservation"}>
              {t("bookNow")}
            </HeaderButton>
          </HStack>
        </HStack>
      </Container>
    </header>
  );
};

export default Header;

type THeaderButtonProps = ButtonProps & {
  children: React.ReactNode;
  href?: string;
};

const HeaderButton = ({ children, href, ...props }: THeaderButtonProps) => {
  if (href) {
    return (
      <Link href={href}>
        <Button
          rounded={"4xl"}
          gap={{ base: "1px", md: "4px" }}
          {...props}
          px={{ base: "4px", xl: "5px", "2xl": "14px" }}
          py={{ base: "2px", md: "8px" }}
          h={{ base: "auto", md: "32px" }}
          fontSize={{ base: "12px", xl: "14px", "2xl": "16px" }}
        >
          {children}
        </Button>
      </Link>
    );
  }
  return (
    <Button
      rounded={"4xl"}
      gap={{ base: "1px", md: "4px" }}
      {...props}
      px={{ base: "4px", xl: "5px", "2xl": "14px" }}
      py={{ base: "2px", md: "8px" }}
      h={{ base: "auto", md: "32px" }}
      fontSize={{ base: "12px", xl: "14px", "2xl": "16px" }}
    >
      {children}
    </Button>
  );
};
