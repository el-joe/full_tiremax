import ReservationHeader from "@/components/pages/profile/reservation/ReservationHeader";
import { Center, Spinner } from "@chakra-ui/react";
import React, { Suspense } from "react";

type props = {
  children: React.ReactNode;
};

export default function layout({ children }: props) {
  return (
    <>
      <ReservationHeader />
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
