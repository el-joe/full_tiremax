import OrdersHeader from "@/components/pages/profile/orders/OrdersHeader";
import OrdersList from "@/components/pages/profile/orders/OrdersList";
import { IApiMetaRes, IOrder } from "@/types";
import axiosInstance from "@/utils/axiosInstance";
import { AxiosError } from "axios";
import React from "react";

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
          <OrdersList data={data.data} paginationInfo={data.meta} />
        </>
      );
    }
  } catch (error: unknown) {
    if (error instanceof AxiosError) {
      return (
        <>
          <OrdersHeader ordersCount={0} />
          <OrdersList data={[]} />
        </>
      );
    }
    return <div>Unexpected error</div>;
  }
}
