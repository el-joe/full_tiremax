import z from "zod";

export const loginSchema = z.object({
    identifier: z.string().min(1, "emailOrPhoneNumberRequired"),
    password: z.string().min(6, "passwordMinLength"),
});
export type LoginFormValues = z.infer<typeof loginSchema>;

export const registerSchema = z.object({
    name: z.string().min(1, "fullNameRequired").max(120, "nameMaxLength"),
    phone: z.string().min(1, "phoneNumberRequired").max(20, "phoneNumberMaxLength"),
    email: z.string().email("invalidEmail").max(120, "emailMaxLength").optional().or(z.literal("")),
    password: z.string().min(6, "passwordMinLength"),
    password_confirmation: z.string().min(6, "passwordConfirmationRequired"),
    address: z.string().max(255, "addressMaxLength").optional().or(z.literal("")),
}).refine((data) => data.password === data.password_confirmation, {
    message: "passwordsMustMatch",
    path: ["password_confirmation"],
});
export type RegisterFormValues = z.infer<typeof registerSchema>;