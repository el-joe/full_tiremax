"use client"
import type { ButtonProps } from "@chakra-ui/react";
import { Button, Container, HStack, Input, InputGroup } from "@chakra-ui/react";
import React from "react";
import { BellIcon, CarIcon, CartIcon, DeviceMaintenanceIcon, HeartIcon, SearchIcon, SpannerIcon, UserCircleIcon } from "../Icons";
import Logo from "../shared/Logo";
import { Link, usePathname } from "@/i18n/navigation";
import { useTranslations } from "next-intl";


const Header = () => {
  const t = useTranslations("header")
  const pathname = usePathname();
  return (
    <header>
      <Container pt={"40px"}>
        <HStack height="80px" mb={"40px"} gap={{ base: '8px', md: "16px", xl: "30px", "2xl": "38px" }}>
          <Logo />
          <HStack gap={"8px"}>
            <HeaderButton href={"/"} variant={pathname === "/" ? "solid" : "ghost"}>{t("home")}</HeaderButton>
            <HeaderButton href={"/store"} variant={pathname === "/store" ? "solid" : "ghost"}><CarIcon />{t("store")}</HeaderButton>
            <HeaderButton href={"/services"} variant={pathname === "/services" ? "solid" : "ghost"}><SpannerIcon />{t("services")}</HeaderButton>
            <HeaderButton href={"/reservation"} variant={pathname === "/reservation" ? "solid" : "ghost"}><DeviceMaintenanceIcon />{t("reservation")}</HeaderButton>
          </HStack>
          {/* search */}
          <InputGroup flex={1} startElement={<SearchIcon size={"md"} />}>
            <Input placeholder={t("search")} bg={"white"} rounded={"20px"} />
          </InputGroup>
          <HStack gap={"8px"}>
            <HeaderButton href={"/"} ><CartIcon /></HeaderButton>
            <HeaderButton href={"/"}><BellIcon /></HeaderButton>
            <HeaderButton href={"/"}><UserCircleIcon /></HeaderButton>
            <HeaderButton href={"/"}><HeartIcon /></HeaderButton>
            <HeaderButton href={"/"}>{t("bookNow")}</HeaderButton>
          </HStack>
        </HStack>
      </Container>
    </header>
  );
};

export default Header;

type THeaderButtonProps = ButtonProps & {
  children: React.ReactNode;
  href: string
}

const HeaderButton = ({ children, href, ...props }: THeaderButtonProps) => {
  return (<Link href={href}>
    <Button rounded={"4xl"} {...props}>
      {children}
    </Button>
  </Link>)
}
