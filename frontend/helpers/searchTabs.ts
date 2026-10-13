export const SEARCH_TAB_PARAM = "searchTab";

export type TSearchTab = "foundByVehicle" | "foundBySize";

export const SEARCH_TAB_QUERY: Record<TSearchTab, string> = {
  foundByVehicle: "vehicle",
  foundBySize: "size",
};

// /store link that opens the catalog with the given search tab active
export const buildStoreHref = (filtersString: string, tab: TSearchTab) => {
  const params = new URLSearchParams(filtersString);
  params.set(SEARCH_TAB_PARAM, SEARCH_TAB_QUERY[tab]);
  return `/store?${params.toString()}`;
};
