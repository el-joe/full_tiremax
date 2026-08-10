import { z } from "zod";

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
    customer_name: z.string().max(120).optional(),
    customer_phone: z.string().max(20).optional(),
    customer_email: z.string().email().max(120).optional(),
    notes: z.string().max(500).optional(),
  })
  .superRefine((data, ctx) => {
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
