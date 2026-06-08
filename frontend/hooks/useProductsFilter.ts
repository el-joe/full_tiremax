"use client";

import { usePathname, useRouter } from "@/i18n/navigation";
import { useSearchParams } from "next/navigation";
import { useCallback, useState } from "react";

type QueryParam = {
  filterBy: string;
  query: string;
};

const filterPrefix = process.env.NEXT_PUBLIC_FILTER_PREFIX || "filter_";

const useProductFilter = () => {
  const router = useRouter();
  const pathname = usePathname();
  const params = useSearchParams();
  const [filters, setFilters] = useState<QueryParam[]>([]);

  for (const [key, value] of params.entries()) {
    if (key.startsWith(filterPrefix)) {
      setFilters((p) => [
        ...p,
        { filterBy: key.replace(filterPrefix, ""), query: value },
      ]);
    }
  }

  const createQueryString = useCallback(
    (newParams: QueryParam[]) => {
      const currentParams = new URLSearchParams(params.toString());
      newParams.forEach(({ filterBy, query }) => {
        const trimmedValue = query.trim();
        const currentValue = params.get(`${filterPrefix}${filterBy}`);
        if (!trimmedValue && !currentValue) return;
        if (!trimmedValue && currentValue) {
          currentParams.delete(`${filterPrefix}${filterBy}`);
          return;
        }
        if (trimmedValue !== currentValue) {
          currentParams.set(`${filterPrefix}${filterBy}`, trimmedValue);
        }
      });
      return currentParams.toString();
    },
    [params]
  );

  const applyFilter = useCallback(() => {
    if (!filters?.length) return;
    const queryString = createQueryString(
      filters?.map(({ filterBy, query }) => ({
        filterBy,
        query,
      }))
    );
    const url = queryString ? `${pathname}?${queryString}` : pathname;
    router.push(url);
  }, [createQueryString, filters, pathname, router]);

  const removeAllFilters = () => {
    const filterList = params
      .keys()
      .toArray()
      .filter((p) => p.startsWith(filterPrefix))
      .map((p) => ({ filterBy: p.replace(filterPrefix, ""), query: "" }));
    setFilters(filterList);
    applyFilter();
  };

  return { applyFilter, filters, removeAllFilters };
};

export default useProductFilter;
