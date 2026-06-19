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
      ms={"-60px"}
      my={"-80px"}
      align={"stretch"}
      borderEnd={"1px solid #E5E5E5"}
    >
      {/* customer info (image, name, role) */}
      <VStack p={"32px 24px"} gap={0}>
        {/* avatar */}
        <Image
          src={"/images/defaultUserAvatar.jpg"}
          alt="user avatar"
          rounded={"16px"}
          w={"80px"}
          aspectRatio={"square"}
        />
        {/* name */}
        <Text fontSize={"20px"} fontWeight={"bold"} mt={"16px"}>
          {customer?.name}
        </Text>
        {/* role */}
        <Text fontSize={"14px"} fontWeight={"bold"} color={"gray-2"}>
          {customer?.name}
        </Text>
      </VStack>
      {/* nav links */}
      <VStack gap={"8px"} align={"stretch"}>
        {NAV_LIST.map((e) => (
          <Link href={e.href} key={e.id}>
            <HStack
              py={"12px"}
              ps={"24px"}
              _hover={{ bg: pathname === e.href ? "primary" : "gray-4" }}
              bg={pathname === e.href ? "primary" : "transparent"}
              color={pathname === e.href ? "white" : "gray-2"}
            >
              <Icon size={"md"}>
                <e.icon />
              </Icon>
              <Text>{t(e.label)}</Text>
            </HStack>
          </Link>
        ))}
      </VStack>
      <VStack align="stretch" mt={"auto"} p={"40px 16px"} gap={"32px"}>
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
