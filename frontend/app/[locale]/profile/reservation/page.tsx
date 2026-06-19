import ReservationList from "@/components/pages/profile/reservation/ReservationList";
import { IApiMetaRes, IReservation } from "@/types";
import axiosInstance from "@/utils/axiosInstance";
import { AxiosError } from "axios";
import React from "react";

const reservation = [
  {
    id: 1,
    reference: "BKG-20260604-0001",
    scheduled_at: new Date("2026-06-10T10:00:00+03:00"),
    duration_minutes: 30,
    status: "confirmed",
    customer_notes: "Please use nitrogen for inflation",
    branch: {
      id: 1,
      code: "BSR-MAIN",
      name: "Basra Main Branch",
      address: "Basra, Abu Al-Khaseeb Highway",
      phone: "0771-000-0001",
      latitude: 30.5085,
      longitude: 47.7834,
    },
    service: {
      id: 1,
      slug: "tire-fitting",
      name: "Tire Fitting",
      description: "Professional mounting and fitting of new tires",
      duration_minutes: 30,
      price: 5000,
    },
  },
  {
    id: 2,
    reference: "BKG-20260604-0001",
    scheduled_at: new Date("2026-06-10T10:00:00+03:00"),
    duration_minutes: 30,
    status: "confirmed",
    customer_notes: "Please use nitrogen for inflation",
    branch: {
      id: 1,
      code: "BSR-MAIN",
      name: "Basra Main Branch",
      address: "Basra, Abu Al-Khaseeb Highway",
      phone: "0771-000-0001",
      latitude: 30.5085,
      longitude: 47.7834,
    },
    service: {
      id: 3,
      slug: "tire-fitting",
      name: "Tire Fitting",
      description: "Professional mounting and fitting of new tires",
      duration_minutes: 30,
      price: 5000,
    },
  },
  {
    id: 3,
    reference: "BKG-20260604-0001",
    scheduled_at: new Date("2026-06-10T10:00:00+03:00"),
    duration_minutes: 30,
    status: "complete",
    customer_notes: "Please use nitrogen for inflation",
    branch: {
      id: 1,
      code: "BSR-MAIN",
      name: "Basra Main Branch",
      address: "Basra, Abu Al-Khaseeb Highway",
      phone: "0771-000-0001",
      latitude: 30.5085,
      longitude: 47.7834,
    },
    service: {
      id: 1,
      slug: "tire-fitting",
      name: "Tire Fitting",
      description: "Professional mounting and fitting of new tires",
      duration_minutes: 30,
      price: 5000,
    },
  },
];

export default async function page() {
  try {
    const { data } = await axiosInstance.get<{
      data: IReservation[];
      meta: IApiMetaRes;
    }>("bookings");

    if (data) {
      return (
        <ReservationList
          data={data.data}
          //  paginationInfo={data.meta}
        />
      );
    }
  } catch (error: unknown) {
    if (error instanceof AxiosError) {
      return (
        <ReservationList
          data={reservation}
          //  paginationInfo={data.meta}
        />
      );
    }
    return <div>Unexpected error</div>;
  }
}
