import Container from "@/components/ui/Container";
import TrackForm from "@/components/pages/trackOrder/TrackForm";
import { Heading } from "@chakra-ui/react";
import { getTranslations } from "next-intl/server";
import { Suspense } from "react";

export default async function page() {
  const t = await getTranslations("trackOrder");
  return (
    <Container>
      <Heading as="h1" fontSize={"40px"} fontWeight={"extrabold"} mb={"24px"}>
        {t("title")}
      </Heading>
      <Suspense>
        <TrackForm />
      </Suspense>
    </Container>
  );
}
