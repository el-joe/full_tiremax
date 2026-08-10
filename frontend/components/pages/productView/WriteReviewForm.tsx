"use client";
import Textarea from "@/components/ui/Textarea";
import { useAuthContext } from "@/providers/AuthProvider";
import {
  CreateReviewInput,
  createReviewSchema,
} from "@/Schemas/createReviewSchema";
import { IReview } from "@/types";
import axiosInstance from "@/utils/axiosInstance";
import { zodResolver } from "@hookform/resolvers/zod";
import { Box, Button, Field, RatingGroup, VStack } from "@chakra-ui/react";
import { useMutation, useQueryClient } from "@tanstack/react-query";
import { AxiosError } from "axios";
import { useTranslations } from "next-intl";
import useDir from "@/hooks/useDir";
import { SubmitHandler, useForm } from "react-hook-form";
import toast from "react-hot-toast";

type Props = {
  productId: number;
};

const WriteReviewForm = ({ productId }: Props) => {
  const t = useTranslations("productView");
  const dir = useDir();
  const { protectedWithAuth } = useAuthContext();
  const queryClient = useQueryClient();
  const {
    handleSubmit,
    control,
    setValue,
    watch,
    reset,
    formState: { errors },
  } = useForm<CreateReviewInput>({
    resolver: zodResolver(createReviewSchema),
    defaultValues: { rating: 0, comment: "" },
  });

  const { mutate: submitReview, isPending } = useMutation({
    mutationKey: ["createReview", productId],
    mutationFn: async (data: CreateReviewInput) => {
      const { data: res } = await axiosInstance.post<{
        success: boolean;
        message: string;
        data: IReview;
      }>(`reviews/${productId}`, data);
      return res;
    },
    onSuccess: () => {
      toast.success(t("reviewSubmittedPendingApproval"));
      reset({ rating: 0, comment: "" });
      queryClient.invalidateQueries({ queryKey: ["reviews", productId] });
    },
    onError: (err: AxiosError<{ message: string }>) => {
      if (err.status === 401) return;
      const errMes = err?.response?.data?.message ?? "Oops! something went wrong";
      toast.error(errMes);
    },
  });

  const onSubmit: SubmitHandler<CreateReviewInput> = (data) => {
    protectedWithAuth(() => submitReview(data));
  };

  return (
    <Box
      as="form"
      onSubmit={handleSubmit(onSubmit)}
      p={"20px"}
      rounded={"16px"}
      border={"2px solid {colors.primary}"}
    >
      <VStack gap={"16px"} align={"stretch"}>
        <Field.Root invalid={!!errors?.rating?.message}>
          <Field.Label>{t("yourRating")}</Field.Label>
          <RatingGroup.Root
            count={5}
            value={watch("rating")}
            onValueChange={(e) => setValue("rating", e.value)}
            size={{ base: "sm", md: "lg" }}
            colorPalette={"yellow"}
          >
            <RatingGroup.HiddenInput />
            <RatingGroup.Control dir={dir} />
          </RatingGroup.Root>
          {errors?.rating?.message && (
            <Field.ErrorText>{t(errors.rating.message)}</Field.ErrorText>
          )}
        </Field.Root>

        <Textarea
          label={t("yourComment")}
          placeholder={t("commentPlaceholder")}
          maxLength={1000}
          value={watch("comment")}
          onChange={(e) => setValue("comment", e.target.value)}
          err={!!errors?.comment?.message}
          errMes={errors?.comment?.message ? t(errors.comment.message) : ""}
        />

        <Button
          type="submit"
          alignSelf={"flex-start"}
          loading={isPending}
          rounded={"8px"}
        >
          {t("submitReview")}
        </Button>
      </VStack>
    </Box>
  );
};

export default WriteReviewForm;
