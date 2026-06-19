import OrdersHeader from "@/components/pages/orders/OrdersHeader";
import OrdersList from "@/components/pages/orders/OrdersList";
import { IApiMetaRes, IOrder } from "@/types";
import axiosInstance from "@/utils/axiosInstance";
import { AxiosError } from "axios";
import React from "react";

const orders = [
  {
    id: 1,
    reference: "ORD-20260604-0001",
    type: "delivery",
    status: "processing",
    payment_method: "cod",
    payment_status: "pending",
    subtotal: 330000,
    discount: 33000,
    shipping_fee: 0,
    installation_fee: 0,
    total: 297000,
    customer_name: "Ahmed Hassan",
    customer_phone: "07701234567",
    customer_email: "ahmed@example.com",
    shipping_address: "Basra, Al-Ashar, Block 5, House 12",
    tracking_number: "TRK-00001234",
    placed_at: "2026-06-04T10:15:00+03:00",
    governorate: {
      id: 1,
      code: "BSR",
      name: "Basra",
      is_basra: true,
      shipping_fee: 0,
    },
    branch: null,
    items: [
      {
        id: 1,
        product_id: 1,
        product_name: "Michelin Pilot Sport 5 225/50R17",
        product_sku: "MCH-PS5-22550R17",
        quantity: 2,
        unit_price: 165000,
        total: 330000,
      },
    ],
  },
  {
    id: 1,
    reference: "ORD-20260604-0001",
    type: "delivery",
    status: "processing",
    payment_method: "cod",
    payment_status: "pending",
    subtotal: 330000,
    discount: 33000,
    shipping_fee: 0,
    installation_fee: 0,
    total: 297000,
    customer_name: "Ahmed Hassan",
    customer_phone: "07701234567",
    customer_email: "ahmed@example.com",
    shipping_address: "Basra, Al-Ashar, Block 5, House 12",
    tracking_number: "TRK-00001234",
    placed_at: "2026-06-04T10:15:00+03:00",
    governorate: {
      id: 1,
      code: "BSR",
      name: "Basra",
      is_basra: true,
      shipping_fee: 0,
    },
    branch: null,
    items: [
      {
        id: 1,
        product_id: 1,
        product_name: "Michelin Pilot Sport 5 225/50R17",
        product_sku: "MCH-PS5-22550R17",
        quantity: 2,
        unit_price: 165000,
        total: 330000,
      },
    ],
  },
  {
    id: 1,
    reference: "ORD-20260604-0001",
    type: "delivery",
    status: "processing",
    payment_method: "cod",
    payment_status: "pending",
    subtotal: 330000,
    discount: 33000,
    shipping_fee: 0,
    installation_fee: 0,
    total: 297000,
    customer_name: "Ahmed Hassan",
    customer_phone: "07701234567",
    customer_email: "ahmed@example.com",
    shipping_address: "Basra, Al-Ashar, Block 5, House 12",
    tracking_number: "TRK-00001234",
    placed_at: "2026-06-04T10:15:00+03:00",
    governorate: {
      id: 1,
      code: "BSR",
      name: "Basra",
      is_basra: true,
      shipping_fee: 0,
    },
    branch: null,
    items: [
      {
        id: 1,
        product_id: 1,
        product_name: "Michelin Pilot Sport 5 225/50R17",
        product_sku: "MCH-PS5-22550R17",
        quantity: 2,
        unit_price: 165000,
        total: 330000,
      },
    ],
  },
];

export default async function page() {
  try {
    const { data } = await axiosInstance.get<{
      data: IOrder[];
      meta: IApiMetaRes;
    }>("orders");

    if (data) {
      return (
        <>
          <OrdersHeader ordersCount={data.meta?.pagination?.total} />
          <OrdersList
            data={data.data}
            //  paginationInfo={data.meta}
          />
        </>
      );
    }
  } catch (error: unknown) {
    if (error instanceof AxiosError) {
      return (
        <>
          <OrdersHeader ordersCount={0} />
          <OrdersList
            data={[]}
            //  paginationInfo={data.meta}
          />
        </>
      );
    }
    return <div>Unexpected error</div>;
  }
}
