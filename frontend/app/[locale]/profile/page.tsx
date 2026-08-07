import FavProductSection from "@/components/pages/profile/FavProductSection";
import RecentOrders from "@/components/pages/profile/RecentOrdersCard";
import PersonalInfoCard from "@/components/pages/profile/PersonalInfoCard";
import ProfileHeader from "@/components/pages/profile/ProfileHeader";
import ReservationComingCard from "@/components/pages/profile/ReservationComingCard";
import { VStack } from "@chakra-ui/react";
import React from "react";

export default function page() {
  return (
    <VStack gap={{ base: "12px", lg: "22px", xl: "40px" }} align={"stretch"}>
      <ProfileHeader />
      <PersonalInfoCard />
      <ReservationComingCard />
      <FavProductSection />
      <RecentOrders />
    </VStack>
  );
}
