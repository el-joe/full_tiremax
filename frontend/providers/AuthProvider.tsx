"use client";
import {
  TLoginCredential,
  TRegisterCredential,
  useAuth,
} from "@/hooks/useAuth";
import { ICustomerProfile } from "@/types";
import { UseDialogReturn } from "@chakra-ui/react";
import { createContext, useContext } from "react";

interface IAuthContext {
  customer: ICustomerProfile | null;
  isLogged: boolean;
  isLogging: boolean;
  loginIsError: boolean;
  loginError: Error | null;
  login: (credential: TLoginCredential) => void;
  logout: () => void;
  authDialog: UseDialogReturn;
  isRegistering: boolean;
  register: (credential: TRegisterCredential) => void;
  registerError: Error | null;
  registerIsError: boolean;
  protectedWithAuth: (fn: () => void) => void;
}

const initialState: IAuthContext = {
  customer: null,
  isLogged: false,
  isLogging: false,
  loginIsError: false,
  loginError: null,
  login: () => {},
  logout: () => {},
  authDialog: {} as UseDialogReturn,
  isRegistering: false,
  register: () => {},
  registerError: null,
  registerIsError: false,
  protectedWithAuth() {},
};

const authContext = createContext<IAuthContext>(initialState);

export const AuthProvider = ({ children }: { children: React.ReactNode }) => {
  const {
    customer,
    isLogged,
    isLogging,
    login,
    loginError,
    loginIsError,
    logout,
    authDialog,
    isRegistering,
    register,
    registerError,
    registerIsError,
    protectedWithAuth,
  } = useAuth();
  return (
    <authContext.Provider
      value={{
        customer,
        isLogged,
        isLogging,
        login,
        loginError,
        loginIsError,
        logout,
        authDialog,
        isRegistering,
        register,
        registerError,
        registerIsError,
        protectedWithAuth,
      }}
    >
      {children}
    </authContext.Provider>
  );
};

export const useAuthContext = () => useContext(authContext);
