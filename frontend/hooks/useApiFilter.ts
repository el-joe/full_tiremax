"use client";

import { useCallback, useMemo, useState } from "react";
import { useSearchParams } from "next/navigation";
import { usePathname, useRouter } from "@/i18n/navigation";

export type QueryParam = {
  targetEndpoint: string;
  filterBy: string;
  query: string;
};

const FILTER_PREFIX = process.env.NEXT_PUBLIC_FILTER_PREFIX ?? "filter";

const useApiFilter = () => {
  const router = useRouter();
  const pathname = usePathname();
  const searchParams = useSearchParams();
  const [filters, setFilters] = useState<QueryParam[]>([...(() => {
    const result: QueryParam[] = [];

    for (const [key, value] of searchParams.entries()) {
      if (!key.startsWith(`${FILTER_PREFIX}_`)) continue;

      const segments = key.replace(`${FILTER_PREFIX}_`, "").split("_");

      if (segments.length < 2) continue;

      const [targetEndpoint, ...filterParts] = segments;

      result.push({
        targetEndpoint,
        filterBy: filterParts.join("_"),
        query: value,
      });
    }

    return result;
  })()])
  const setFilter = (newFilter: QueryParam) => {
    setFilters(p => [...p, newFilter])
  }


  const applyFilter = useCallback(
    () => {
      const params = new URLSearchParams(searchParams.toString());

      filters.forEach(({ targetEndpoint, filterBy, query }) => {
        const key = `${FILTER_PREFIX}_${targetEndpoint}_${filterBy}`;
        const value = query.trim();

        if (!value) {
          params.delete(key);
          return;
        }

        params.set(key, value);
      });

      const queryString = params.toString();

      router.push(queryString ? `${pathname}?${queryString}` : pathname);
    },
    [filters, pathname, router, searchParams]
  );

  const removeAllFilters = useCallback(() => {
    const params = new URLSearchParams(searchParams.toString());

    Array.from(params.keys())
      .filter((key) => key.startsWith(`${FILTER_PREFIX}_`))
      .forEach((key) => params.delete(key));

    const queryString = params.toString();

    router.push(queryString ? `${pathname}?${queryString}` : pathname);
    setFilters([])
  }, [pathname, router, searchParams]);

  return {
    filters,
    applyFilter,
    // exFilters,
    setFilter,
    removeAllFilters,
  };
};

export default useApiFilter;
