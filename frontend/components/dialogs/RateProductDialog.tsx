"use client";
import React from "react";
import { Heading, Text, useDialog } from "@chakra-ui/react";
import { useTranslations } from "next-intl";
import useDir from "@/hooks/useDir";
import { useRouter } from "@/i18n/navigation";
import Dialog from "../ui/Dialog";
import WriteReviewForm from "../pages/productView/WriteReviewForm";

type props = {
  trigger: React.ReactNode;
  productId: number;
  productName: string;
  orderId: number;
};

export default function RateProductDialog({
  trigger,
  productId,
  productName,
  orderId,
}: props) {
  const dir = useDir();
  const dialog = useDialog();
  const router = useRouter();
  const t = useTranslations("profile");

  return (
    <Dialog
      value={dialog}
      placement={"center"}
      closeIconButton
      trigger={trigger}
      contentProps={{ minW: "min(420px, 92vw)" }}
    >
      <div dir={dir}>
        <Heading size="md" mb={1}>
          {t("rateProduct")}
        </Heading>
        <Text mb={4} color={"gray-2"} fontSize={"14px"}>
          {productName}
        </Text>
        <WriteReviewForm
          productId={productId}
          orderId={orderId}
          onSuccess={() => {
            dialog.setOpen(false);
            router.refresh();
          }}
        />
      </div>
    </Dialog>
  );
}
