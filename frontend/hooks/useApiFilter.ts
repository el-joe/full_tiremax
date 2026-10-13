"use client";

import { useCallback, useState } from "react";
import { useSearchParams } from "next/navigation";
import { usePathname, useRouter } from "@/i18n/navigation";

export type QueryParam = {
  targetEndpoint: string;
  filterBy: string;
  query: string;
};

const FILTER_PREFIX = process.env.NEXT_PUBLIC_FILTER_PREFIX ?? "filter";
const PAGINATION_PREFIX = process.env.NEXT_PUBLIC_PAGINATION_PREFIX ?? "paginate";

// a changed filter set invalidates the current page number
const resetPagination = (params: URLSearchParams) =>
  Array.from(params.keys())
    .filter((key) => key.startsWith(`${PAGINATION_PREFIX}_`))
    .forEach((key) => params.delete(key));

const parseFilters = (search: string): QueryParam[] => {
  const result: QueryParam[] = [];

  for (const [key, value] of new URLSearchParams(search).entries()) {
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
};

const useApiFilter = () => {
  const router = useRouter();
  const pathname = usePathname();
  const searchParams = useSearchParams();
  const searchString = searchParams.toString();
  const [filters, setFilters] = useState<QueryParam[]>(() =>
    parseFilters(searchString),
  );

  // The provider lives in the root layout, so keep local state in sync with the URL
  // (e.g. arriving on /store from the home page search)
  const [syncedSearch, setSyncedSearch] = useState(searchString);
  if (syncedSearch !== searchString) {
    setSyncedSearch(searchString);
    setFilters(parseFilters(searchString));
  }

  const setFilter = (newFilter: QueryParam) => {
    if (filters.find((f) => f.filterBy === newFilter.filterBy)) {
      return setFilters((p) => [
        ...p.filter((f) => f.filterBy !== newFilter.filterBy),
        newFilter,
      ]);
    }

    setFilters((p) => [...p, newFilter]);
  };

  const applyFilter = (newFilter?: QueryParam) => {
    if (!filters.length && !newFilter) return;
    const params = new URLSearchParams(searchParams.toString());
    if (!!newFilter) setFilter(newFilter);
    [...filters, newFilter]
      .filter((f) => f !== undefined)
      .forEach(({ targetEndpoint, filterBy, query }) => {
        const key = `${FILTER_PREFIX}_${targetEndpoint}_${filterBy}`;
        const value = query?.trim();

        if (!value) {
          params.delete(key);
          setFilters((p) => [...p.filter((f) => f.filterBy !== filterBy)]);
          return;
        }

        params.set(key, value);
      });

    resetPagination(params);
    const queryString = params.toString();

    router.push(queryString ? `${pathname}?${queryString}` : pathname);
  };

  // Pure: called during render (e.g. for link hrefs), so it must not set state
  const getFiltersString = (newFilter?: QueryParam) => {
    const params = new URLSearchParams(searchParams.toString());
    [...filters, newFilter]
      .filter((f) => f !== undefined)
      .forEach(({ targetEndpoint, filterBy, query }) => {
        const key = `${FILTER_PREFIX}_${targetEndpoint}_${filterBy}`;
        const value = query?.trim();

        if (!value) {
          params.delete(key);
          return;
        }

        params.set(key, value);
      });
    return params.toString();
  };

  const removeAllFilters = useCallback(
    (except?: { targetEndpoint: string; filterName: string }[]) => {
      const params = new URLSearchParams(searchParams.toString());

      Array.from(params.keys())
        .filter(
          (key) =>
            key.startsWith(`${FILTER_PREFIX}_`) &&
            !except?.find(
              (e) =>
                key ===
                `${FILTER_PREFIX}_${e?.targetEndpoint}_${e?.filterName}`,
            ),
        )
        .forEach((key) => params.delete(key));

      resetPagination(params);
      const queryString = params.toString();

      router.push(queryString ? `${pathname}?${queryString}` : pathname);
      setFilters([]);
    },
    [pathname, router, searchParams],
  );

  return {
    filters,
    applyFilter,
    setFilter,
    removeAllFilters,
    getFiltersString,
  };
};

export default useApiFilter;
