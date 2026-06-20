import { z } from "zod";

export const createAddressSchema = z.object({
  governorate_id: z.string("selectGovernorateIsRequired"),
  city_id: z.string("selectCityIsRequired"),
  address: z
    .string("theAddressIsRequired")
    .min(12, "theAddressMustBeMoreThen12Character")
    .max(255, "theAddressMustBeLessThen12Character"),

  full_name: z.string().max(120).optional(),
  phone: z.string().max(20).optional(),
});

export type TCreateAddressSchema = z.infer<typeof createAddressSchema>;
