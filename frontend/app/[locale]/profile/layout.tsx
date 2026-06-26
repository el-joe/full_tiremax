import ProfileNav from "@/components/pages/profile/ProfileNav";
import Container from "@/components/ui/Container";
import { Box, HStack } from "@chakra-ui/react";
import { Metadata } from "next";
import React from "react";

export const metadata: Metadata = {
  title: "profile",
};

type Props = {
  children: React.ReactNode;
};

export default function layout({ children }: Props) {
  return (
    <Container>
      <HStack gap={0} align={"stretch"} flexDir={{ base: "column", md: "row" }}>
        <ProfileNav />
        <Box px={{ md: "18px", lg: "40px", "2xl": "60px" }} flex={1}>
          {children}
        </Box>
      </HStack>
    </Container>
  );
}
