"use client"
import type { ButtonProps } from "@chakra-ui/react";
import { Button, Container, HStack } from "@chakra-ui/react";
import React from "react";
import { BellIcon, CarIcon, CartIcon, DeviceMaintenanceIcon, HeartIcon, SearchIcon, SpannerIcon, UserCircleIcon } from "../Icons";
import Logo from "../shared/Logo";
import { Link, usePathname } from "@/i18n/navigation";
import { useTranslations } from "next-intl";
import Input from "../ui/Input";


const Header = () => {
  const t = useTranslations("header")
  const pathname = usePathname();
  return (
    <header>
      <Container pt={{ base: '16px', xl: "30px", "2xl": "40px" }}>
        <HStack justify={"center"} mb={{ base: "16px", xl: "30px", "2xl": "40px" }} gap={{ base: '8px', sm: "12px", xl: "20px", "2xl": "38px" }} flexWrap={{ base: "wrap" }}>
          <Logo />
          <HStack gap={{ base: "2px", xl: "8px" }}>
            <HeaderButton href={"/"} variant={pathname === "/" ? "solid" : "ghost"}>{t("home")}</HeaderButton>
            <HeaderButton href={"/store"} variant={pathname === "/store" ? "solid" : "ghost"}><CarIcon />{t("store")}</HeaderButton>
            <HeaderButton href={"/services"} variant={pathname === "/services" ? "solid" : "ghost"}><SpannerIcon />{t("services")}</HeaderButton>
            <HeaderButton href={"/reservation"} variant={pathname === "/reservation" ? "solid" : "ghost"}><DeviceMaintenanceIcon />{t("reservation")}</HeaderButton>
          </HStack>
          {/* search */}
          <Input startElement={<SearchIcon size={"md"} />} placeholder={t("search")} bg={"white"} rounded={"20px"} rootProps={{ flex: 1 }} minW={"120px"} />
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
            bg={{ base: "white", md: "none" }}>
            <HeaderButton href={"/"} ><CartIcon /></HeaderButton>
            <HeaderButton href={"/"}><BellIcon /></HeaderButton>
            <HeaderButton href={"/"}><UserCircleIcon /></HeaderButton>
            <HeaderButton href={"/"}><HeartIcon /></HeaderButton>
            <HeaderButton href={"/"}>{t("bookNow")}</HeaderButton>
          </HStack>
        </HStack>
      </Container>
    </header >
  );
};

export default Header;

type THeaderButtonProps = ButtonProps & {
  children: React.ReactNode;
  href?: string
}

const HeaderButton = ({ children, href, ...props }: THeaderButtonProps) => {
  if (href) {
    return (<Link href={href}>
      <Button rounded={"4xl"} gap={{ base: "1px", md: "12px" }} {...props} px={{ base: '4px', xl: "5px", "2xl": "14px" }} py={{ base: "2px", md: "8px" }} h={{ base: "auto", md: "32px" }} fontSize={{ base: '12px', xl: "14px", "2xl": "16px" }}>
        {children}
      </Button>
    </Link>)
  }
  return (
    <Button rounded={"4xl"} gap={{ base: "1px", md: "12px" }} {...props} px={{ base: '4px', xl: "5px", "2xl": "14px" }} py={{ base: "2px", md: "8px" }} h={{ base: "auto", md: "32px" }} fontSize={{ base: '12px', xl: "14px", "2xl": "16px" }}>
      {children}
    </Button>)
}
