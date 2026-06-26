import ProductCardSkeleton from "@/components/skeletons/ProductCardSkeleton";
import { Text } from "@chakra-ui/react";
import { Metadata } from "next";

import React, { Suspense } from "react";

export const metadata: Metadata = {
  title: "store",
};

type props = {
  children: React.ReactNode;
};

const page = async ({ children }: props) => {
  return <Suspense fallback={<ProductCardSkeleton />}>{children}</Suspense>;
};

export default page;
