import { ICustomerProfile } from "@/types";
import axiosInstance from "@/utils/axiosInstance";
import { useMutation } from "@tanstack/react-query";
import { useEffect, useState, useCallback } from "react";
import { setCookie, deleteCookie, getCookie } from "cookies-next";
import { AxiosError } from "axios";
import { useQueryState } from "nuqs";
import toast from "react-hot-toast";
import { useTranslations } from "next-intl";
import { useDialog } from "@chakra-ui/react";

export type TLoginCredential = { login: string; password: string };
export type TRegisterCredential = {
  name: string;
  phone: string;
  email?: string;
  password: string;
  password_confirmation: string;
  address?: string;
  locale?: string;
};

export const useAuth = () => {
  const t = useTranslations("auth");
  const authDialog = useDialog();
  const [authDialogParam, setAuthDialogParam] = useQueryState("authDialog");

  const [customer, setCustomer] = useState<ICustomerProfile | null>(() => {
    if (typeof window === "undefined") return null;
    const storedUser = localStorage.getItem("customerInfo");
    const token = getCookie("tiremax_token");
    return !!storedUser && !!token ? JSON.parse(storedUser) : null;
  });

  const [isLogged, setIsLogged] = useState<boolean>(() => {
    if (typeof window === "undefined") return false;
    const storedUser = localStorage.getItem("customerInfo");
    const token = getCookie("tiremax_token");
    return !!storedUser && !!token;
  });

  // login mutation
  const {
    mutate: login,
    error: loginError,
    isPending: loginIsPending,
    isError: loginIsError,
  } = useMutation({
    mutationKey: ["login"],
    mutationFn: async (body: TLoginCredential) => {
      const { data } = await axiosInstance.post<{
        data: {
          customer: ICustomerProfile;
          access_token: string;
          expires_in: number;
        };
      }>("auth/login", body);
      return data.data;
    },
    onSuccess: (res) => {
      saveUser({
        customerInfo: res?.customer,
        token: res.access_token,
        expiresIn: res.expires_in,
      });
      toast.success(`${t("welcome")} ${res.customer.name}`);
    },
    onError: (err: AxiosError<{ message?: string }>) => {
      const apiMessage = err.response?.data?.message;
      if (apiMessage) {
        // propagate API message into the error object so UI can display it
        err.message = apiMessage;
      }
    },
  });

  // register mutation
  const {
    mutate: register,
    error: registerError,
    isPending: registerIsPending,
    isError: registerIsError,
  } = useMutation({
    mutationKey: ["register"],
    mutationFn: async (body: TRegisterCredential) => {
      const { data } = await axiosInstance.post<{
        data: {
          customer: ICustomerProfile;
          access_token: string;
          expires_in: number;
        };
      }>("auth/register", body);
      return data.data;
    },
    onSuccess: (res) => {
      saveUser({
        customerInfo: res?.customer,
        token: res.access_token,
        expiresIn: res.expires_in,
      });
      toast.success(`${t("welcome")} ${res.customer.name}`);
    },
    onError: (err: AxiosError<{ message?: string }>) => {
      const apiMessage = err.response?.data?.message;
      if (apiMessage) {
        err.message = apiMessage;
      }
    },
  });

  // memoize saveUser to avoid re-creating it every render
  const saveUser = useCallback(
    ({
      customerInfo,
      token,
      expiresIn,
    }: {
      customerInfo: ICustomerProfile;
      token: string;
      expiresIn: number;
    }) => {
      if (!customerInfo || !token) return;
      setCustomer(customerInfo);
      localStorage.setItem("customerInfo", JSON.stringify(customerInfo));
      setCookie("tiremax_token", token, { maxAge: expiresIn });
      setIsLogged(true);
      setAuthDialogParam(null);
      authDialog.setOpen(false);
    },
    [authDialog, setAuthDialogParam],
  );

  const protectedWithAuth = useCallback(
    (fn: () => void) => {
      if (!isLogged) {
        authDialog.setOpen(true);
        return;
      }
      return fn();
    },
    [authDialog, isLogged],
  );

  const logout = () => {
    localStorage.removeItem("customerInfo");
    deleteCookie("tiremax_token");
    setCustomer(null);
    setIsLogged(false);
  };

  useEffect(() => {
    const storedUser = localStorage.getItem("customerInfo");
    const token = getCookie("tiremax_token");
    if (!storedUser || !token) {
      localStorage.removeItem("customerInfo");
      deleteCookie("tiremax_token");
    }
  }, []);

  useEffect(() => {
    if (authDialogParam === "on" && isLogged) {
      setAuthDialogParam(null);
    } else if (authDialogParam === "on" && !isLogged) {
      authDialog.setOpen(true);
    }
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [authDialogParam, isLogged]);

  return {
    customer,
    isLogged,
    isLogging: loginIsPending,
    login,
    loginIsError,
    loginError,
    isRegistering: registerIsPending,
    register,
    registerIsError,
    registerError,
    logout,
    authDialog,
    protectedWithAuth,
  };
};
