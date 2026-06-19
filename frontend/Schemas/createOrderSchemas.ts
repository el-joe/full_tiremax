import { z } from "zod";

export const createOrderSchema = z.object({
  governorate_id: z.string("selectGovernorateIsRequired"),
  shipping_address: z
    .string("theAddressIsRequired")
    .min(12, "theAddressMustBeMoreThen12Character")
    .max(255, "theAddressMustBeLessThen12Character"),

  payment_method: z.enum(["cod", "card", "transfer"]).default("cod").optional(),
  customer_name: z.string().max(120).optional(),
  customer_phone: z.string().max(20).optional(),
  customer_email: z.string().email().max(120).optional(),
  notes: z.string().max(500).optional(),
});

export type CreateOrderInput = z.infer<typeof createOrderSchema>;
