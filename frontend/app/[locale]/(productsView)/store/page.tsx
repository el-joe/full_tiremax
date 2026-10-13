import { getTranslations } from "next-intl/server";
import ProductListView from "@/components/pages/productsView/ProductListView";
import { IApiMetaRes, IProduct } from "@/types";
import axiosInstance from "@/utils/axiosInstance";
import React from "react";

const page = async () => {
  try {
    const { data } = await axiosInstance.get<{
      data: IProduct[];
      meta: IApiMetaRes;
    }>("products");

    if (data) {
      return <ProductListView data={data.data} paginationInfo={data.meta} />;
    }
  } catch (error: unknown) {
    if (error instanceof Error) {
      return <div>{error.message}</div>;
    }

    return <div>{(await getTranslations())("unexpectedError")}</div>;
  }
};

export default page;
