"use client";
import { useCallback, useEffect, useMemo, useState } from "react";
import { ICustomerFav, IProduct } from "@/types";
import toast from "react-hot-toast";
import { useTranslations } from "next-intl";
import { useMutation } from "@tanstack/react-query";
import axiosInstance from "@/utils/axiosInstance";
import { useAuthContext } from "@/providers/AuthProvider";
import { AxiosError } from "axios";

const LOCAL_STORAGE_KEY = "customerFavorites";

export const useFavorites = () => {
  const t = useTranslations();
  const [favorites, setFavorites] = useState<IProduct[]>([]);
  const { isLogged } = useAuthContext();
  const [favIsLoading, setFavIsLoading] = useState(true);
  const isFavorite = useCallback(
    (productId: number) => {
      return favorites.some((item) => item.id === productId);
    },
    [favorites],
  );

  const onError = (err: AxiosError<{ message: string }>) => {
    if (err.status === 401) return;
    const errMes = err?.response?.data?.message ?? "Something went wrong.";
    toast.error(errMes);
  };

  // get favorites
  const { mutate: getFav } = useMutation({
    mutationKey: ["cart"],
    mutationFn: async () => {
      const { data } = await axiosInstance<{ data: IProduct[] }>("favorites");
      return data.data;
    },
    onSuccess: (res) => {
      setFavorites(res);
      setFavIsLoading(false);
    },
    onError: () => {
      setFavIsLoading(false);
    },
  });

  useEffect(() => {
    if (isLogged) {
      getFav();
    }
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [isLogged]);

  const { mutate: toggleFavorite, isPending: isToggling } = useMutation({
    mutationFn: async (product: IProduct) => {
      const { data } = await axiosInstance.post<{ message: string }>(
        `favorites/${product.id}/toggle`,
      );
      return data;
    },
    onSuccess: (res) => {
      getFav();
      toast.success(res.message);
    },
    onError,
  });

  return {
    favorites,
    favoritesCount: favorites.length,
    isFavorite,
    toggleFavorite,
    isToggling,
    favIsLoading,
  };
};
