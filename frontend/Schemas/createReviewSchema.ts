import { z } from "zod";

export const createReviewSchema = z.object({
  rating: z.number().min(1, "ratingIsRequired").max(5),
  comment: z
    .string()
    .min(10, "commentMustBeAtLeast10Characters")
    .max(1000, "commentMustBeLessThan1000Characters"),
});

export type CreateReviewInput = z.infer<typeof createReviewSchema>;
