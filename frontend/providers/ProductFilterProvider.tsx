"use client";
import useApiFilter from "@/hooks/useApiFilter";
import { createContext, useContext } from "react";

type TFilterBody = {
  targetEndpoint: string;
  filterBy: string;
  query: string;
};

interface IFilterContext {
  applyFilter: (newFilter?: TFilterBody) => void;
  filters: TFilterBody[];
  removeAllFilters: (
    except?: { targetEndpoint: string; filterName: string }[],
  ) => void;
  setFilter: (newFilter: TFilterBody) => void;
  getFiltersString: () => string;
}

const filterContext = createContext<IFilterContext>({
  applyFilter() {},
  filters: [],
  removeAllFilters() {},
  setFilter() {},
  getFiltersString: () => "",
});

export const ProductFilterProvider = ({
  children,
}: {
  children: React.ReactNode;
}) => {
  const {
    applyFilter,
    filters,
    removeAllFilters,
    setFilter,
    getFiltersString,
  } = useApiFilter();
  return (
    <filterContext.Provider
      value={{
        applyFilter,
        filters,
        removeAllFilters,
        setFilter,
        getFiltersString,
      }}
    >
      {children}
    </filterContext.Provider>
  );
};

export const useProductFilterContext = () => useContext(filterContext);
