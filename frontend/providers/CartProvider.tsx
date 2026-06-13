"use client";
import { useCart } from "@/hooks/useCart";
import { ICustomerCart, IProduct } from "@/types";
import { ICartItem, ICartProduct } from "@/types/customerCart.type";
import { createContext, useContext } from "react";

interface ICartContext {
  cart: ICustomerCart;
  addOrUpdateItem: (product: IProduct | ICartProduct, quantity: number) => void;
  removeItem: (productId: number) => void;
  clearCart: () => void;
  totalQuantity: number;
  isLoading: boolean;
}

const initialState: ICartContext = {
  cart: {
    governorate_id: 0,
    id: 0,
    items: [],
    items_count: 0,
    subtotal: 0,
    governorate: "",
  },
  addOrUpdateItem() {},
  removeItem() {},
  clearCart() {},
  totalQuantity: 0,
  isLoading: false,
};

const cartContext = createContext<ICartContext>(initialState);

export const CartProvider = ({ children }: { children: React.ReactNode }) => {
  const {
    cart,
    addOrUpdateItem,
    clearCart,
    isLoading,
    removeItem,
    totalQuantity,
  } = useCart();
  return (
    <cartContext.Provider
      value={{
        cart,
        addOrUpdateItem,
        removeItem,
        clearCart,
        totalQuantity,
        isLoading,
      }}
    >
      {children}
    </cartContext.Provider>
  );
};

export const useCartContext = () => useContext(cartContext);
