import { z } from "zod";

export const contactSchema = z.object({
  name: z
    .string()
    .trim()
    .min(1, "nameIsRequired")
    .max(120, "nameMustBeLessThan120Characters"),
  phone: z
    .string()
    .trim()
    .min(1, "phoneIsRequired")
    .max(30, "phoneMustBeLessThan30Characters"),
  subject: z
    .string()
    .trim()
    .min(1, "subjectIsRequired")
    .max(190, "subjectMustBeLessThan190Characters"),
  message: z
    .string()
    .trim()
    .min(1, "messageIsRequired")
    .max(5000, "messageMustBeLessThan5000Characters"),
});

export type ContactInput = z.infer<typeof contactSchema>;
