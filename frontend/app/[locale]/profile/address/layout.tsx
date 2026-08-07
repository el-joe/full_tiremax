import AddressesHeader from "@/components/pages/profile/addresses/AddressesHeader";
import { Center, Spinner } from "@chakra-ui/react";
import React, { Suspense } from "react";

type Props = {
  children: React.ReactNode;
};

export default function layout({ children }: Props) {
  return (
    <>
      <AddressesHeader />
      <Suspense
        fallback={
          <Center py={"40px"}>
            <Spinner size={"xl"} />
          </Center>
        }
      >
        {children}
      </Suspense>
    </>
  );
}
