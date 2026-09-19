"use client";
import { useAuthContext } from "@/providers/AuthProvider";
import { ICustomerCart, IProduct } from "@/types";
import { IApplyOfferResult, ICartProduct } from "@/types/customerCart.type";
import axiosInstance from "@/utils/axiosInstance";
import { useMutation } from "@tanstack/react-query";
import { AxiosError } from "axios";
import { useTranslations } from "next-intl";
import { useCallback, useEffect, useState } from "react";
import toast from "react-hot-toast";

const EMPTY_CART: ICustomerCart = {
  id: 0,
  items: [],
  items_count: 0,
  subtotal: 0,
  governorate_id: null,
  governorate: null,
};

export const useCart = () => {
  const t = useTranslations();
  const [cart, setCart] = useState<ICustomerCart>(EMPTY_CART);
  const { isLogged } = useAuthContext();
  const [cartIsLoading, setCartIsLoading] = useState(true);
  const [appliedOffer, setAppliedOffer] = useState<{
    discount: number;
    offer: { code: string; title: string };
  } | null>(null);

  // get Cart
  const { mutate: getCart } = useMutation({
    mutationKey: ["cart"],
    mutationFn: async () => {
      const { data } = await axiosInstance<{ data: ICustomerCart }>("cart");
      return data.data;
    },
    onSuccess: (res) => {
      setCart(res);
      setCartIsLoading(false);
    },
    onError: () => setCartIsLoading(false),
  });

  useEffect(() => {
    // guests have a server-side cart keyed by X-Guest-Token; refetch on login/logout (merge)
    getCart();
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [isLogged]);

  // handle general error
  const onError = (err: AxiosError) => {
    if (err.status === 401) return;
    toast.error("Something went wrong.");
  };

  const { mutate: addToCart, isPending: isAdding } = useMutation({
    mutationFn: async (body: { product_id: number; quantity: number }) => {
      const { data } = await axiosInstance.post<{ data: ICustomerCart }>(
        "cart/items",
        body,
      );
      return data.data;
    },
    onSuccess: (res) => {
      setCart(res);
      setAppliedOffer(null);
    },
    onError,
  });

  const { mutate: updateCart, isPending: isUpdating } = useMutation({
    mutationFn: async (body: { itemId: number; quantity: number }) => {
      const { data } = await axiosInstance.put<{ data: ICustomerCart }>(
        `cart/items/${body.itemId}`,
        { quantity: body.quantity },
      );
      return data.data;
    },
    onSuccess: (res) => {
      setCart(res);
      setAppliedOffer(null);
    },
    onError,
  });

  const { mutate: removeItem, isPending: isRemoving } = useMutation({
    mutationFn: async (product_id: number) => {
      const cartItem = cart?.items.find((i) => i.product_id === product_id);
      const { data } = await axiosInstance.delete<{
        data: ICustomerCart;
        message: string;
      }>(`cart/items/${cartItem?.id}`);
      return data;
    },
    onSuccess: (res) => {
      setCart(res.data);
      setAppliedOffer(null);
      toast.success(res.message);
    },
    onError,
  });

  const [applyOfferError, setApplyOfferError] = useState<string | null>(null);

  const { mutate: applyOffer, isPending: isApplyingOffer } = useMutation({
    mutationFn: async (code: string) => {
      const { data } = await axiosInstance.post<{ data: IApplyOfferResult }>(
        "cart/apply-offer",
        { code },
      );
      return data.data;
    },
    onSuccess: (res) => {
      setCart((prev) => ({
        ...prev,
        subtotal: res.subtotal,
      }));
      setAppliedOffer({ discount: res.discount, offer: res.offer });
      setApplyOfferError(null);
      toast.success(res.offer.title);
    },
    onError: (err: AxiosError<{ message: string }>) => {
      if (err.status === 401) return;
      setApplyOfferError(
        err?.response?.data?.message ?? "Something went wrong.",
      );
    },
  });

  const { mutate: clearCart, isPending: isClearing } = useMutation({
    mutationFn: async () => {
      const { data } = await axiosInstance.delete<{ data: ICustomerCart }>(
        `cart`,
      );
      return data.data;
    },
    onSuccess: () => {
      setCart(EMPTY_CART);
      setAppliedOffer(null);
    },
    onError,
  });

  const addOrUpdateItem = useCallback(
    (product: IProduct | ICartProduct, quantity: number) => {
      const existing = cart?.items.find((i) => i.product_id === product.id);
      if (existing) {
        updateCart({ itemId: existing.id, quantity });
      } else {
        addToCart({ product_id: product.id, quantity });
      }
      toast.success(`"${product.name}". ${t("addedToTheCart")}`);
    },
    [addToCart, cart?.items, t, updateCart],
  );

  return {
    cart,
    totalQuantity: cart?.items_count,
    addOrUpdateItem,
    removeItem,
    clearCart,
    applyOffer,
    appliedOffer,
    applyOfferError,
    cartIsLoading,
    isAdding,
    isUpdating,
    isRemoving,
    isClearing,
    isApplyingOffer,
  };
};
