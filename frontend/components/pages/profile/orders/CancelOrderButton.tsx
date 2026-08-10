"use client";
import CancelOrderDialog from "@/components/dialogs/CancelOrderDialog";
import { Button, Icon } from "@chakra-ui/react";
import { useTranslations } from "next-intl";
import { useRouter } from "@/i18n/navigation";
import { IoMdClose } from "react-icons/io";

type props = {
  orderId: number;
};

export default function CancelOrderButton({ orderId }: props) {
  const t = useTranslations("profile");
  const router = useRouter();

  return (
    <CancelOrderDialog
      orderId={orderId}
      onSuccess={() => router.refresh()}
      trigger={
        <Button
          border="1px solid #FFC9C9"
          bg="transparent"
          color="#E7000B"
          rounded="12px"
          minW="auto"
          p={{ base: "4px", md: "12px" }}
          fontSize={{ base: "9px", md: "12px", lg: "16px" }}
          gap={{ base: "3px", md: "8px" }}
          h="auto"
        >
          <Icon size={{ base: "xs", md: "md" }}>
            <IoMdClose />
          </Icon>
          {t("cancelOrder")}
        </Button>
      }
    />
  );
}
