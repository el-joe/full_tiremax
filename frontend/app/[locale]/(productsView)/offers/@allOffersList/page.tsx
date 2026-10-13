import { redirect } from "next/navigation";
import { getLocale } from "next-intl/server";

// Special offers are just the catalog filtered by the "special_offer" badge
const page = async () => {
  const locale = await getLocale();
  redirect(`/${locale}/store?filter_products_badge=special_offer`);
};

export default page;
