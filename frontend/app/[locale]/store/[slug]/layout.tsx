import Container from "@/components/ui/Container";
import { Text } from "@chakra-ui/react";
import React, { Suspense } from "react";

type Props = {
  children: React.ReactNode;
};

const layout = ({ children }: Props) => {
  return (
    <Container>
      <Suspense fallback={<Text fontSize={"48px"}>Loading</Text>}>
        {children}
      </Suspense>
    </Container>
  );
};

export default layout;
