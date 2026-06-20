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
  cartIsLoading: boolean;
  isAdding: boolean;
  isUpdating: boolean;
  isRemoving: boolean;
  isClearing: boolean;
}

const initialState: ICartContext = {
  cart: {
    id: 0,
    items: [],
    items_count: 0,
    subtotal: 0,
  },
  addOrUpdateItem() {},
  removeItem() {},
  clearCart() {},
  totalQuantity: 0,
  cartIsLoading: true,
  isAdding: false,
  isUpdating: false,
  isRemoving: false,
  isClearing: false,
};

const cartContext = createContext<ICartContext>(initialState);

export const CartProvider = ({ children }: { children: React.ReactNode }) => {
  const {
    cart,
    totalQuantity,
    addOrUpdateItem,
    removeItem,
    clearCart,
    cartIsLoading,
    isAdding,
    isUpdating,
    isRemoving,
    isClearing,
  } = useCart();
  return (
    <cartContext.Provider
      value={{
        cart,
        addOrUpdateItem,
        removeItem,
        clearCart,
        totalQuantity,
        cartIsLoading,
        isAdding,
        isUpdating,
        isRemoving,
        isClearing,
      }}
    >
      {children}
    </cartContext.Provider>
  );
};

export const useCartContext = () => useContext(cartContext);
