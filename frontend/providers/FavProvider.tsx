"use client"
import { useFavorites } from "@/hooks/useFav";
import { ICustomerFav, IProduct } from "@/types";
import { createContext, useContext } from "react";

interface IFavContext {
    addFavorite: (product: IProduct) => void;
    clearFavorites: () => void;
    favoriteIds: Set<number>;
    favorites: ICustomerFav[];
    favoritesCount: number;
    isFavorite: (productId: number) => boolean;
    removeFavorite: (productId: number) => void;
    toggleFavorite: (product: IProduct) => void
}

const initialState: IFavContext = {
    addFavorite() { },
    clearFavorites() { },
    favoriteIds: new Set(),
    favorites: [],
    favoritesCount: 0,
    isFavorite() { return false },
    removeFavorite() { },
    toggleFavorite() { },
}


const favContext = createContext<IFavContext>(initialState)

export const FavProvider = ({ children }: { children: React.ReactNode }) => {
    const { addFavorite, clearFavorites, favoriteIds, favorites, favoritesCount, isFavorite, removeFavorite, toggleFavorite } = useFavorites()
    return <favContext.Provider value={{ addFavorite, clearFavorites, favoriteIds, favorites, favoritesCount, isFavorite, removeFavorite, toggleFavorite }}>{children}</favContext.Provider>
}

export const useFavContext = () => useContext(favContext)
