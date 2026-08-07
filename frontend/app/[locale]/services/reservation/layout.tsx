import { ReservationProvider } from "@/providers/ReservationProvider";
import { Metadata } from "next";
import React from "react";

export const metadata: Metadata = {
  title: "reservation",
};

export default function layout({ children }: { children: React.ReactNode }) {
  return <ReservationProvider>{children}</ReservationProvider>;
}
