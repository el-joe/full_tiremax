
"use client"
import { ICustomerCart, IProduct } from "@/types";
import { ICartItem, ICartProduct } from "@/types/customerCart.type";
import axiosInstance from "@/utils/axiosInstance";
import { useMutation } from "@tanstack/react-query";
import { AxiosError } from "axios";
import { useTranslations } from "next-intl";
import { useCallback, useEffect, useMemo, useState } from "react";
import toast from "react-hot-toast";

const LOCAL_STORAGE_CART_KEY = "customerCart";

const EMPTY_CART: ICustomerCart = {
    governorate_id: 0,
    governorate: "",
    id: 0,
    items: [],
    items_count: 0,
    subtotal: 0,
};

export const useCart = () => {
    const t = useTranslations()
    const [cart, setCart] = useState<ICustomerCart>(() => {
        try {
            return JSON.parse(localStorage.getItem(LOCAL_STORAGE_CART_KEY) ?? "null") ?? EMPTY_CART;
        } catch {
            return EMPTY_CART;
        }
    });

    const recalculate = useCallback((items: ICartItem[]) => {
        const subtotal = items.reduce((a, i) => a + i.unit_price * i.quantity, 0);

        return {
            ...EMPTY_CART,
            ...cart,
            items,
            items_count: items.reduce((a, i) => a + i.quantity, 0),
            subtotal,
        };
    }, [cart]);

    useEffect(() => {
        localStorage.setItem(LOCAL_STORAGE_CART_KEY, JSON.stringify(cart));
    }, [cart]);

    const onError = (err: AxiosError) => {
        toast.error(err.status === 401 ? "You need to login first." : "Something went wrong.");
    };

    const addMutation = useMutation({
        mutationFn: (body: { product_id: number; quantity: number }) =>
            axiosInstance.post("cart/items", body),
        onError,
    });

    const removeMutation = useMutation({
        mutationFn: (id: number) => axiosInstance.delete(`cart/items/${id}`),
        onError,
    });

    const clearMutation = useMutation({
        mutationFn: () => axiosInstance.delete("cart"),
        onError,
    });

    const addOrUpdateItem = useCallback((product: IProduct | ICartProduct, quantity: number) => {
        setCart(prev => {
            const existing = prev.items.find(i => i.product_id === product.id);

            const items = existing
                ? prev.items.map(i =>
                    i.product_id === product.id
                        ? {
                            ...i,
                            quantity,
                            unit_price: product.effective_price,
                            total: product.effective_price * quantity,
                        }
                        : i,
                )
                : [
                    ...prev.items,
                    {
                        id: product.id,
                        product_id: product.id,
                        quantity,
                        unit_price: product.effective_price,
                        total: product.effective_price * quantity,
                        product: {
                            id: product.id,
                            name: product.name,
                            brand: product.brand,
                            sku: product.sku,
                            price: product.price,
                            sale_price: product.sale_price,
                            effective_price: product.effective_price,
                            in_stock: product.in_stock,
                            primary_image: product.primary_image,
                        },
                    },
                ];

            const subtotal = items.reduce((sum, item) => sum + item.unit_price * item.quantity, 0);

            return {
                ...prev,
                items,
                items_count: items.reduce((sum, item) => sum + item.quantity, 0),
                subtotal,
            };
        });
        toast.success(`"${product.name}". ${t('addedToTheCart')}`)
    }, [t]);

    const removeItem = useCallback((productId: number) => {
        const removedItem = cart.items.find(i => i.product_id === productId)
        setCart(prev => {
            const items = prev.items.filter(i => i.product_id !== productId);
            const subtotal = items.reduce((sum, item) => sum + item.unit_price * item.quantity, 0);

            return {
                ...prev,
                items,
                items_count: items.reduce((sum, item) => sum + item.quantity, 0),
                subtotal,
            };
        });
        toast.success(`"${removedItem?.product.name}". ${t("removedFromTheCart")}`)
    }, [cart.items, t]);

    const clearCart = useCallback(() => setCart(EMPTY_CART), []);

    const totalQuantity = useMemo(
        () => cart.items.reduce((sum, i) => sum + i.quantity, 0),
        [cart.items],
    );

    return {
        cart,
        totalQuantity,
        addOrUpdateItem,
        removeItem,
        clearCart,
        // addToCart: addMutation.mutate,
        // removeFromCart: removeMutation.mutate,
        // clearCart: clearMutation.mutate,
        isLoading:
            addMutation.isPending ||
            removeMutation.isPending ||
            clearMutation.isPending,
    };
};
