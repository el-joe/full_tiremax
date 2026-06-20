"use client";
import { useAuthContext } from "@/providers/AuthProvider";
import { Button, HStack, Icon, Image, Text, VStack } from "@chakra-ui/react";
import React from "react";
import { FaRegCalendarAlt, FaRegUserCircle } from "react-icons/fa";
import { BsBoxSeam } from "react-icons/bs";
import { IoLocationOutline } from "react-icons/io5";
import { GoGear } from "react-icons/go";
import { Link, usePathname } from "@/i18n/navigation";
import { FiPlusCircle } from "react-icons/fi";
import { useTranslations } from "next-intl";
import { MdLogout } from "react-icons/md";
import LogoutDialog from "@/components/dialogs/LogoutDialog";
import useDir from "@/hooks/useDir";

const NAV_LIST = [
  {
    id: 1,
    icon: FaRegUserCircle,
    href: "/profile",
    label: "profile",
  },
  {
    id: 2,
    icon: BsBoxSeam,
    href: "/profile/orders",
    label: "orders",
  },
  {
    id: 3,
    icon: IoLocationOutline,
    href: "/profile/address",
    label: "addresses",
  },
  {
    id: 4,
    icon: FaRegCalendarAlt,
    href: "/profile/reservation",
    label: "bookings",
  },
  {
    id: 5,
    icon: GoGear,
    href: "/profile/settings",
    label: "settings",
  },
];

export default function ProfileNav() {
  const { customer } = useAuthContext();
  const t = useTranslations("profile");
  const pathname = usePathname();
  const dir = useDir();
  return (
    <VStack
      bg="#FAFAFA"
      flex={"0.3"}
      // ms={{ md: "-30px", xl: "-40px", "2xl": "-60px" }}
      my={{ base: "-22px 22px", md: "-42px", xl: "-80px" }}
      mx={{ base: "-16px", md: "-30px 0", xl: "-40px 0", "2xl": "-60px 0" }}
      align={{ base: "center", md: "stretch" }}
      borderEnd={"1px solid #E5E5E5"}
      flexDir={{ base: "row", md: "column" }}
      flexWrap={"wrap"}
      p={{ base: "6px", md: "unset" }}
      gap={0}
    >
      {/* customer info (image, name, role) */}
      <VStack
        p={{
          base: "8px",
          md: "12px 8px",
          lg: "18px 12px",
          "2xl": "32px 24px",
        }}
        gap={0}
      >
        {/* avatar */}
        <Image
          src={"/images/defaultUserAvatar.jpg"}
          alt="user avatar"
          rounded={"16px"}
          w={{ base: "42px", md: "66px", lg: "80px" }}
          aspectRatio={"square"}
        />
        {/* name */}
        <Text
          fontSize={{ base: "10px", md: "16px", lg: "20px" }}
          fontWeight={"bold"}
          mt={{ base: "0", md: "6px", lg: "16px" }}
        >
          {customer?.name}
        </Text>
        {/* role */}
        <Text
          fontSize={"14px"}
          fontWeight={"bold"}
          color={"gray-2"}
          display={{ base: "none", md: "block" }}
        >
          {customer?.name}
        </Text>
      </VStack>
      {/* nav links */}
      <VStack
        gap={"8px"}
        align={"stretch"}
        flexDir={{ base: "row", md: "column" }}
        flex={1}
        justify={{ base: "space-between", md: "start" }}
      >
        {NAV_LIST.map((e) => (
          <Link href={e.href} key={e.id} className="flex-1 md:flex-0">
            <HStack
              py={{ base: "4px", md: "8px", lg: "12px" }}
              pe={{ base: "4px", md: "0" }}
              ps={{ base: "4px", md: "12px", lg: "24px" }}
              _hover={{ bg: pathname === e.href ? "primary" : "gray-4" }}
              bg={pathname === e.href ? "primary" : "transparent"}
              color={pathname === e.href ? "white" : "gray-2"}
              flexDir={{ base: "column", md: "row" }}
              rounded={{ base: "12px", md: "0" }}
            >
              <Icon size={{ base: "sm", md: "md" }}>
                <e.icon />
              </Icon>
              <Text
                fontSize={{ base: "8px", md: "14px", lg: "16px" }}
                whiteSpace={"nowrap"}
              >
                {t(e.label)}
              </Text>
            </HStack>
          </Link>
        ))}
      </VStack>
      <VStack
        align="stretch"
        mt={"auto"}
        p={{ md: "40px 16px" }}
        gap={{ base: "8px", md: "20px", lg: "32px" }}
        flexDir={{ base: "row", md: "column" }}
        mx={"auto"}
      >
        <Link href={"/services/reservation"} className="flex-1">
          <Button fontWeight={"bold"} h={"48px"} rounded={"8px"} w="full">
            <FiPlusCircle /> {t("bookNewService")}
          </Button>
        </Link>
        <LogoutDialog
          trigger={
            <Button
              fontWeight={"bold"}
              variant={"ghost"}
              color={"#BA1A1A"}
              _hover={{ bg: "transparent" }}
              dir={dir}
              //   onClick={() => logout()}
            >
              <MdLogout /> {t("logout")}
            </Button>
          }
        />
      </VStack>
    </VStack>
  );
}
