import { ReservationProvider } from "@/providers/ReservationProvider";
import React from "react";

export default function layout({ children }: { children: React.ReactNode }) {
  return <ReservationProvider>{children}</ReservationProvider>;
}
