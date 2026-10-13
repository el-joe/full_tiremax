import ContactUsSection from "@/components/shared/ContactUsSection";
import { Metadata } from "next";

export const metadata: Metadata = {
  title: "contact",
};

export default function page() {
  return <ContactUsSection />;
}
