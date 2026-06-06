import HeroSection from "@/components/pages/home/HeroSection";
import RecommendedOffersSection from "@/components/pages/home/RecommendedOffersSection";
import RecommendedSection from "@/components/pages/home/RecommendedSection";
import { IHomeResponse } from "@/types";
import axiosInstance from "@/utils/axiosInstance";

export default async function Home() {
  const endpoint = "home"
  const { data } = await axiosInstance<{ data: IHomeResponse }>(endpoint)
  return <>
    <HeroSection />
    <RecommendedSection data={data.data.featured} />
    <RecommendedOffersSection data={data.data.offers}/>
  </>;
}