import BannersGridSection from "@/components/pages/home/BannersGridSection";
import HeroSection from "@/components/pages/home/HeroSection";
import RecommendedOffersSection from "@/components/pages/home/RecommendedOffersSection";
import RecommendedSection from "@/components/pages/home/RecommendedSection";
import ReservationSection from "@/components/pages/home/ReservationSection";
import { IHomeResponse } from "@/types";
import axiosInstance from "@/utils/axiosInstance";

export default async function Home() {
  const endpoint = "home"
  const { data } = await axiosInstance<{ data: IHomeResponse }>(endpoint)
  return <>
    <HeroSection />
    <RecommendedSection data={data.data.featured} />
    <BannersGridSection />
    <ReservationSection />
    <RecommendedOffersSection data={data.data.offers} />
  </>;
}