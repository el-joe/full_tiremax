import { IAddress } from "@/types";
import {
  Badge,
  Box,
  Button,
  Center,
  Heading,
  HStack,
  Icon,
  Text,
  VStack,
} from "@chakra-ui/react";
import { getTranslations } from "next-intl/server";
import React from "react";
import { FiCheckCircle, FiMapPin } from "react-icons/fi";

type Props = {
  data: IAddress[];
};

export default async function AddressesList({ data }: Props) {
  const t = await getTranslations("profile");
  if (!data.length)
    return (
      <Center>
        <Text py="40px" fontSize={"28px"} fontWeight={"bold"}>
          No don&apos;t set your address yet
        </Text>
      </Center>
    );
  return (
    <HStack
      justify={"space-between"}
      mt={"24px"}
      align={"stretch"}
      flexWrap={"wrap"}
      gap={"16px"}
    >
      {data.map((address) => (
        <VStack
          key={address.id}
          position={"relative"}
          w={{ base: "full", md: "calc((100% - 16px) / 2)" }}
          maxW={"420px"}
          rounded="16px"
          p="24px"
          border={"1px solid"}
          borderColor={address.is_default ? "primary" : "#E5E7EB"}
          align={"stretch"}
          gap={"20px"}
          boxShadow={
            address.is_default
              ? "0 4px 6px -4px #FDB60433, 0 10px 15px -3px #FDB60433"
              : "unset"
          }
        >
          <HStack>
            <Center
              bg={address.is_default ? "#FDB6041A" : "#F3F4F6"}
              rounded={"14px"}
              w="48px"
              h="48px"
            >
              <Icon
                size={"md"}
                color={address.is_default ? "primary" : "black"}
              >
                <address.icon />
              </Icon>
            </Center>
            <Heading>{address.title}</Heading>
          </HStack>
          <HStack align={"start"}>
            <Icon color={"primary"}>
              <FiMapPin />
            </Icon>
            <Box>
              <Text fontSize={"14px"} fontWeight={"medium"}>
                {address.address_line1}
              </Text>
              <Text fontSize={"14px"} color={"gray-2"}>
                {address.address_line2}
              </Text>
              <Text mt="16px" fontSize={"14px"} color={"gray-2"}>
                {address.phone}
              </Text>
            </Box>
          </HStack>
          {/* set default button */}
          {!address.is_default && (
            <Button variant={"surface"} h="48px" rounded={"14px"}>
              {t("setAsDefaultAddress")}
            </Button>
          )}
          {/* default address badge */}
          {address.is_default && (
            <Badge
              position={"absolute"}
              top={"-15px"}
              right={"20px"}
              h="30px"
              rounded="14px"
              bg={"primary"}
              px="16px"
            >
              <Icon size={"sm"}>
                <FiCheckCircle />
              </Icon>
              <Text fontSize={"12px"} fontWeight={"bold"}>
                {t("defaultAddress")}
              </Text>
            </Badge>
          )}
        </VStack>
      ))}
    </HStack>
  );
}
