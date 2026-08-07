"use client";
import { useFavorites } from "@/hooks/useFav";
import { ICustomerFav, IProduct } from "@/types";
import { createContext, useContext } from "react";

interface IFavContext {
  favorites: IProduct[];
  favoritesCount: number;
  isFavorite: (productId: number) => boolean;
  toggleFavorite: (product: IProduct) => void;
  isToggling: boolean;
  favIsLoading: boolean;
}

const initialState: IFavContext = {
  favorites: [],
  favoritesCount: 0,
  isFavorite() {
    return false;
  },
  toggleFavorite() {},
  isToggling: false,
  favIsLoading: true,
};

const favContext = createContext<IFavContext>(initialState);

export const FavProvider = ({ children }: { children: React.ReactNode }) => {
  const {
    favorites,
    favoritesCount,
    isFavorite,
    toggleFavorite,
    isToggling,
    favIsLoading,
  } = useFavorites();
  return (
    <favContext.Provider
      value={{
        favorites,
        favoritesCount,
        isFavorite,
        toggleFavorite,
        isToggling,
        favIsLoading,
      }}
    >
      {children}
    </favContext.Provider>
  );
};

export const useFavContext = () => useContext(favContext);
