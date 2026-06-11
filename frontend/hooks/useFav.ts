"use client"
import { useCallback, useEffect, useMemo, useState } from "react";
import { ICustomerFav, IProduct } from "@/types";
import toast from "react-hot-toast";
import { useTranslations } from "next-intl";

const LOCAL_STORAGE_KEY = "customerFavorites";

export const useFavorites = () => {
    const t = useTranslations()
    const [favorites, setFavorites] = useState<ICustomerFav[]>(() => {
        try {
            const stored = localStorage.getItem(LOCAL_STORAGE_KEY);
            return stored ? JSON.parse(stored) : [];
        } catch {
            return [];
        }
    });

    useEffect(() => {
        localStorage.setItem(
            LOCAL_STORAGE_KEY,
            JSON.stringify(favorites)
        );
    }, [favorites]);

    const isFavorite = useCallback(
        (productId: number) => {
            return favorites.some((item) => item.id === productId);
        },
        [favorites]
    );

    const addFavorite = useCallback((product: IProduct) => {
        setFavorites((prev) => {
            if (prev.some((item) => item.id === product.id)) {
                return prev;
            }

            return [...prev, product];
        });
        toast.success(`"${product.name}". ${t("addedToYourFavorites")}`)
    }, [t]);

    const removeFavorite = useCallback((productId: number) => {
        setFavorites((prev) =>
            prev.filter((item) => item.id !== productId)
        );
        toast.success(`"${favorites.find(i => i.id === productId)?.name}". ${t("removedFromYourFavorites")}`)
    }, [favorites, t]);

    const toggleFavorite = useCallback((product: IProduct) => {
        const exists = favorites.some((item) => item.id === product.id);
        if (exists) {
            removeFavorite(product.id)
        } else {
            addFavorite(product)
        }
    }, [addFavorite, favorites, removeFavorite]);

    const clearFavorites = useCallback(() => {
        setFavorites([]);
    }, []);

    const favoriteIds = useMemo(
        () => new Set(favorites.map((item) => item.id)),
        [favorites]
    );

    return {
        favorites,
        favoriteIds,
        favoritesCount: favorites.length,
        isFavorite,
        addFavorite,
        removeFavorite,
        toggleFavorite,
        clearFavorites,
    };
};