import { Link } from "@/i18n/navigation";
import { IService } from "@/types";
import {
  Box,
  Button,
  Card,
  HStack,
  Image,
  Text,
  VStack,
} from "@chakra-ui/react";
import { getTranslations } from "next-intl/server";
import React from "react";

type Props = {
  services: IService[];
};

export default async function ServicesList({ services }: Props) {
  const t = await getTranslations("services");
  return (
    <HStack
      gap={{ base: "16px", md: "32px" }}
      flexWrap={"wrap"}
      mb={{ base: "34px", lg: "66px" }}
      align={"stretch"}
    >
      {services.map((service) => (
        <ServiceCard key={service.id} service={service} />
      ))}
      <VStack
        justify={"end"}
        align={"start"}
        rounded={"24px"}
        p={"32px"}
        position={"relative"}
        h={"400px"}
        zIndex={1}
        overflow={"hidden"}
        w={{
          base: "calc((100% - 14px) / 2)",
          sm: "140px",
          md: "230px",
          lg: "calc((100% - 64px) / 3)",
        }}
        flex={1}
      >
        <Image
          src={"/images/serviceBanner.png"}
          alt="bg"
          position={"absolute"}
          inset={"0"}
          h="full"
          w={"full"}
          zIndex={-1}
        />
        <Box
          position={"absolute"}
          inset="0"
          bg="linear-gradient(
            0deg,
            rgba(0, 0, 0, 0.9) 0%,
            rgba(0, 0, 0, 0.4) 50%,
            rgba(0, 0, 0, 0) 100%
          )"
          zIndex={0}
        />
        <Text
          fontSize={"12px"}
          fontWeight={"bold"}
          color={"primary"}
          zIndex={1}
        >
          {t("modernTechnology")}
        </Text>
        <Text zIndex={1} fontSize={"30px"} fontWeight={"bold"} color={"white"}>
          {t("modernTechnologyDescription")}
        </Text>
      </VStack>
    </HStack>
  );
}

const ServiceCard = async ({ service }: { service: IService }) => {
  const t = await getTranslations("services");
  return (
    <Card.Root
      overflow="hidden"
      w={{
        base: "calc((100% - 16px) / 2)",
        md: "calc((100% - 64px) / 3)",
      }}
      rounded={"24px"}
      border={"none"}
      boxShadow={"0 10px 40px -10px #0000000D"}
    >
      <Image
        src={service?.image_url ?? "/images/serviceImage.jpg"}
        alt="Green double couch with wooden legs"
        h={{ base: "140px", lg: "200px" }}
      />
      <Card.Body gap="2" p={{ base: "8px", sm: "16px", xl: "32px" }}>
        <Card.Title fontSize={{ xl: "24px" }} fontWeight={"bold"}>
          {service?.name}
        </Card.Title>
        <Card.Description color={"gray-2"}>
          {service?.description}
        </Card.Description>
      </Card.Body>
      <Card.Footer justifyContent={"stretch"}>
        <Link href={"#"} className="flex-1">
          <Button
            w={"full"}
            h={{ base: "36px", xl: "56px" }}
            fontWeight={"bold"}
          >
            {t("bookNow")}
          </Button>
        </Link>
      </Card.Footer>
    </Card.Root>
  );
};
