"use client";
import { useCart } from "@/hooks/useCart";
import { ICustomerCart, IProduct } from "@/types";
import { ICartItem, ICartProduct } from "@/types/customerCart.type";
import { createContext, useContext } from "react";

interface IAppliedOffer {
  discount: number;
  offer: { code: string; title: string };
}

interface ICartContext {
  cart: ICustomerCart;
  existsInCart: (productId: number) => boolean;
  addOrUpdateItem: (product: IProduct | ICartProduct, quantity: number) => void;
  removeItem: (productId: number) => void;
  clearCart: () => void;
  refetchCart: () => void;
  applyOffer: (code: string) => void;
  appliedOffer: IAppliedOffer | null;
  applyOfferError: string | null;
  totalQuantity: number;
  targetedCartItem: number | null;
  cartIsLoading: boolean;
  isAdding: boolean;
  isUpdating: boolean;
  isRemoving: boolean;
  isClearing: boolean;
  isApplyingOffer: boolean;
}

const initialState: ICartContext = {
  cart: {
    id: 0,
    items: [],
    items_count: 0,
    subtotal: 0,
    governorate_id: null,
    governorate: null,
  },
  existsInCart: () => false,
  addOrUpdateItem() {},
  removeItem() {},
  clearCart() {},
  refetchCart() {},
  applyOffer() {},
  appliedOffer: null,
  applyOfferError: null,
  totalQuantity: 0,
  targetedCartItem: null,
  cartIsLoading: true,
  isAdding: false,
  isUpdating: false,
  isRemoving: false,
  isClearing: false,
  isApplyingOffer: false,
};

const cartContext = createContext<ICartContext>(initialState);

export const CartProvider = ({ children }: { children: React.ReactNode }) => {
  const {
    cart,
    existsInCart,
    totalQuantity,
    addOrUpdateItem,
    removeItem,
    clearCart,
    refetchCart,
    applyOffer,
    appliedOffer,
    applyOfferError,
    cartIsLoading,
    targetedCartItem,
    isAdding,
    isUpdating,
    isRemoving,
    isClearing,
    isApplyingOffer,
  } = useCart();
  return (
    <cartContext.Provider
      value={{
        cart,
        existsInCart,
        addOrUpdateItem,
        removeItem,
        clearCart,
        refetchCart,
        applyOffer,
        appliedOffer,
        applyOfferError,
        totalQuantity,
        cartIsLoading,
        targetedCartItem,
        isAdding,
        isUpdating,
        isRemoving,
        isClearing,
        isApplyingOffer,
      }}
    >
      {children}
    </cartContext.Provider>
  );
};

export const useCartContext = () => useContext(cartContext);
