import { z } from "zod";

export const createOrderSchema = z
    .object({
        // type: z.enum(["basra", "delivery"]),

        // branch_id: z.number().int().optional(),
        governorate_id: z.string(),
        shipping_address: z.string().min(12).max(255),

        payment_method: z.enum(["cod", "card", "transfer"]).default("cod").optional(),
        customer_name: z.string().max(120).optional(),
        customer_phone: z.string().max(20).optional(),
        customer_email: z.string().email().max(120).optional(),
        notes: z.string().max(500).optional(),
        // discount: z.coerce.number().min(0).optional(),
        // installation_fee: z.coerce.number().min(0).optional(),
    })
// .superRefine((data, ctx) => {
//     if (data.type === "basra" && data.branch_id == null) {
//         ctx.addIssue({
//             code: z.ZodIssueCode.custom,
//             path: ["branch_id"],
//             message: "Branch is required.",
//         });
//     }

//     if (data.type === "delivery") {
//         if (data.governorate_id == null) {
//             ctx.addIssue({
//                 code: z.ZodIssueCode.custom,
//                 path: ["governorate_id"],
//                 message: "Governorate is required.",
//             });
//         }

//         if (!data.shipping_address) {
//             ctx.addIssue({
//                 code: z.ZodIssueCode.custom,
//                 path: ["shipping_address"],
//                 message: "Shipping address is required.",
//             });
//         }
//     }
// });

export type CreateOrderInput = z.infer<typeof createOrderSchema>;