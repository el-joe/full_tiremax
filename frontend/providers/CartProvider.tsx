"use client"
import { useCart } from "@/hooks/useCart";
import { ICustomerCart, IProduct } from "@/types";
import { createContext, useContext } from "react";

interface ICartContext {
    cart: ICustomerCart
    addOrUpdateItem: (product: IProduct, quantity: number) => void,
}

const initialState: ICartContext = {
    cart: { governorate_id: 0, id: 0, items: [], items_count: 0, subtotal: 0, governorate: "" },
    addOrUpdateItem({ }) { },
}


const cartContext = createContext<ICartContext>(initialState)

export const CartProvider = ({ children }: { children: React.ReactNode }) => {
    const { cart, addOrUpdateItem, clearCart, isLoading, removeItem, totalQuantity } = useCart()
    return <cartContext.Provider value={{ cart, addOrUpdateItem }}>{children}</cartContext.Provider>
}

export const useCartContext = () => useContext(cartContext)
