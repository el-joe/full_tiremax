import ProductCardSkeleton from "@/components/skeletons/ProductCardSkeleton";
import { Text } from "@chakra-ui/react";

import React, { Suspense } from "react";

type props = {
  children: React.ReactNode;
};

const page = async ({ children }: props) => {
  return <Suspense fallback={<ProductCardSkeleton />}>{children}</Suspense>;
};

export default page;
