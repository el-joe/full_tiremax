import { z } from "zod";
import { isValidIraqiPhone } from "@/helpers/phone";

export const createOrderSchema = z
  .object({
    type: z.enum(["delivery", "basra"], "selectOrderTypeIsRequired"),
    branch_id: z.string().optional(),
    governorate_id: z.string("selectGovernorateIsRequired").optional(),
    shipping_address: z
      .string("theAddressIsRequired")
      .min(12, "theAddressMustBeMoreThen12Character")
      .max(255, "theAddressMustBeLessThen12Character")
      .optional(),

    payment_method: z.string("selectPaymentMethodIsRequired"),
    customer_name: z
      .string("fullNameRequired")
      .trim()
      .min(1, "fullNameRequired")
      .max(120, "nameMaxLength"),
    customer_phone: z
      .string("phoneRequired")
      .trim()
      .min(1, "phoneRequired")
      .max(20, "phoneNumberMaxLength")
      .refine(isValidIraqiPhone, "phoneInvalid"),
    customer_email: z
      .string()
      .trim()
      .email("invalidEmail")
      .max(120, "emailMaxLength")
      .optional()
      .or(z.literal("")),
    create_account: z.boolean().optional(),
    password: z.string().optional(),
    notes: z.string().max(500).optional(),
  })
  .superRefine((data, ctx) => {
    if (data.create_account && (data.password ?? "").length < 6) {
      ctx.addIssue({
        code: "custom",
        message: "passwordMinLength",
        path: ["password"],
      });
    }
    if (data.type === "basra" && !data.branch_id) {
      ctx.addIssue({
        code: "custom",
        message: "selectBranchIsRequired",
        path: ["branch_id"],
      });
    }
    if (data.type === "delivery" && !data.governorate_id) {
      ctx.addIssue({
        code: "custom",
        message: "selectGovernorateIsRequired",
        path: ["governorate_id"],
      });
    }
  });

export type CreateOrderInput = z.infer<typeof createOrderSchema>;
