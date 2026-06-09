"use client"
import useApiFilter from "@/hooks/useApiFilter";
import { createContext, useContext } from "react";

type TFilterBody = {
    targetEndpoint: string;
    filterBy: string;
    query: string;
}

interface IFilterContext {
    applyFilter: (newFilter?: TFilterBody) => void;
    filters: TFilterBody[];
    removeAllFilters: () => void;
    setFilter: (newFilter: TFilterBody) => void,
}


const filterContext = createContext<IFilterContext>({
    applyFilter() { },
    filters: [],
    removeAllFilters() { },
    setFilter() { },
})

export const ProductFilterProvider = ({ children }: { children: React.ReactNode }) => {
    const { applyFilter, filters, removeAllFilters, setFilter } = useApiFilter()
    return <filterContext.Provider value={{ applyFilter, filters, removeAllFilters, setFilter }}>{children}</filterContext.Provider>
}

export const useProductFilterContext = () => useContext(filterContext)
