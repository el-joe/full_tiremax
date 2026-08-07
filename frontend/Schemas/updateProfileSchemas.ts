import { z } from "zod";

const emptyToUndefined = (value: unknown) => (value === "" ? undefined : value);

export const settingsSchema = z
  .object({
    name: z.preprocess(
      emptyToUndefined,
      z.string().min(6, "nameMinLength").max(120, "nameMaxLength").optional(),
    ),

    phone: z.preprocess(
      emptyToUndefined,
      z
        .string()
        .min(9, "phoneNumberMinLength")
        .max(20, "phoneNumberMaxLength")
        .optional(),
    ),

    email: z.preprocess(
      emptyToUndefined,
      z.string().email("invalidEmail").max(120, "emailMaxLength").optional(),
    ),

    newPassword: z.preprocess(
      emptyToUndefined,
      z.string().min(6, "passwordMinLength").optional(),
    ),

    password_confirmation: z.preprocess(
      emptyToUndefined,
      z.string().min(6, "passwordConfirmationRequired").optional(),
    ),
  })
  .refine(
    (data) =>
      !data.newPassword || data.newPassword === data.password_confirmation,
    {
      message: "passwordsMustMatch",
      path: ["password_confirmation"],
    },
  );
export type TSettingsSchema = z.infer<typeof settingsSchema>;
