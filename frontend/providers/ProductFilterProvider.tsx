"use client"
import useApiFilter from "@/hooks/useApiFilter";
import { createContext, useContext } from "react";

interface IFilterContext {
    applyFilter: () => void;
    filters: {
        targetEndpoint: string;
        filterBy: string;
        query: string;
    }[];
    removeAllFilters: () => void;
    setFilter: ({
        targetEndpoint,
        filterBy,
        query,
    }: {
        targetEndpoint: string;
        filterBy: string;
        query: string;
    }) => void,
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
