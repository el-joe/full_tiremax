import { Text } from "@chakra-ui/react";
import { Metadata } from "next";

import React, { Suspense } from "react";

export const metadata: Metadata = {
  title: "offers",
};

type props = {
  allOffersList: React.ReactNode;
};

const page = async ({ allOffersList }: props) => {
  return (
    <Suspense fallback={<Text fontSize={"48px"}>Loading</Text>}>
      {allOffersList}
    </Suspense>
  );
};

export default page;
