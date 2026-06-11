"use client"
import { useAuth } from "@/hooks/useAuth";
import { IUserProfile } from "@/types";
import { createContext, useContext } from "react";

interface IAuthContext {
    user: IUserProfile | null;
    isLogged: boolean;
}

const initialState: IAuthContext = {
    user: null,
    isLogged: false
}


const authContext = createContext<IAuthContext>(initialState)

export const AuthProvider = ({ children }: { children: React.ReactNode }) => {
    const { user, isLogged } = useAuth()
    return <authContext.Provider value={{ user, isLogged }}>{children}</authContext.Provider>
}

export const useAuthContext = () => useContext(authContext)