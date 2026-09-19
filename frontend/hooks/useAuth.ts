import { ICustomerProfile } from "@/types";
import axiosInstance from "@/utils/axiosInstance";
import { useMutation, useQueryClient } from "@tanstack/react-query";
import { useEffect, useState, useCallback } from "react";
import { setCookie, deleteCookie, getCookie } from "cookies-next";
import { AxiosError } from "axios";
import { useQueryState } from "nuqs";
import toast from "react-hot-toast";
import { useTranslations } from "next-intl";
import { clearGuestToken } from "@/helpers/guestToken";
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
export type TUpdateCustomer = {
  name?: string;
  email?: string;
  password?: string;
  password_confirmation?: string;
  locale?: string;
};

type TLinkMeta = { linked_orders?: number; linked_bookings?: number };

export const useAuth = () => {
  const t = useTranslations("auth");
  const queryClient = useQueryClient();
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
        meta?: TLinkMeta;
      }>("auth/login", body);
      return { ...data.data, meta: data.meta };
    },
    onSuccess: (res) => {
      saveUser({
        customerInfo: res?.customer,
        token: res.access_token,
        expiresIn: res.expires_in,
      });
      toast.success(`${t("welcome")} ${res.customer.name}`);
      afterAuth(res.meta);
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
        meta?: TLinkMeta;
      }>("auth/register", body);
      return { ...data.data, meta: data.meta };
    },
    onSuccess: (res) => {
      saveUser({
        customerInfo: res?.customer,
        token: res.access_token,
        expiresIn: res.expires_in,
      });
      toast.success(`${t("welcome")} ${res.customer.name}`);
      afterAuth(res.meta);
    },
    onError: (err: AxiosError<{ message?: string }>) => {
      const apiMessage = err.response?.data?.message;
      if (apiMessage) {
        err.message = apiMessage;
      }
    },
  });

  // update customer info mutation
  const {
    mutate: updateCustomer,
    error: updateCustomerError,
    isPending: updateCustomerIsPending,
    isError: updateCustomerIsError,
  } = useMutation({
    mutationKey: ["updateCustomerInfo"],
    mutationFn: async (body: TUpdateCustomer) => {
      const { data } = await axiosInstance.put<{
        data: ICustomerProfile;
        message: string;
      }>("auth/me", body);
      return data;
    },
    onSuccess: (res) => {
      saveUser({
        customerInfo: res.data,
      });
      toast.success(res.message ?? `${t("profileUpdated")}`);
    },
    onError: (err: AxiosError<{ message?: string }>) => {
      const apiMessage = err.response?.data?.message;
      if (apiMessage) {
        err.message = apiMessage;
      }
    },
  });

  // after login/register the server links guest data to the account
  const afterAuth = (meta?: TLinkMeta) => {
    const orders = meta?.linked_orders ?? 0;
    const bookings = meta?.linked_bookings ?? 0;
    if (orders + bookings > 0) {
      toast.success(t("linkedItems", { orders, bookings }));
    }
    clearGuestToken();
    ["orders", "bookings", "cart"].forEach((key) =>
      queryClient.invalidateQueries({ queryKey: [key] }),
    );
  };

  const saveUser = useCallback(
    ({
      customerInfo,
      token,
      expiresIn,
    }: {
      customerInfo: ICustomerProfile;
      token?: string;
      expiresIn?: number;
    }) => {
      if (!customerInfo && !token) return;
      setCustomer(customerInfo);
      localStorage.setItem("customerInfo", JSON.stringify(customerInfo));
      if (token) {
        setCookie("tiremax_token", token, { maxAge: expiresIn });
      }
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
    } else if (authDialogParam === "on") {
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
    updateCustomer,
    updateCustomerError,
    updateCustomerIsPending,
    updateCustomerIsError,
  };
};
