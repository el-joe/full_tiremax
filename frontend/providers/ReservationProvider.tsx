"use client";
import ChooseAppointment from "@/components/pages/reservation/ChooseAppointment";
import ChooseBranch from "@/components/pages/reservation/ChooseBranch";
import ChooseService from "@/components/pages/reservation/ChooseService";
import ConfirmBooking from "@/components/pages/reservation/ConfirmBooking";
import { IBranch, IService } from "@/types";
import axiosInstance from "@/utils/axiosInstance";
import {
  useSteps as useChakraSteps,
  type UseStepsReturn,
} from "@chakra-ui/react";
import { useMutation, useQuery } from "@tanstack/react-query";
import { useSearchParams } from "next/navigation";
import { createContext, ReactNode, useContext, useMemo, useState } from "react";
import { isValidIraqiPhone } from "@/helpers/phone";
import { useLocale, useTranslations } from "next-intl";
import toast from "react-hot-toast";
import { AiOutlineTool } from "react-icons/ai";
import { FaRegCheckCircle } from "react-icons/fa";
import { IoCalendarClearOutline } from "react-icons/io5";
import { IconType } from "react-icons/lib";
import { LuMapPin } from "react-icons/lu";
import { useAuthContext } from "./AuthProvider";
import { AxiosError } from "axios";

const steps = [
  {
    id: 1,
    icon: AiOutlineTool,
    stepName: "chooseService",
    stepNum: "step1",
    content: <ChooseService />,
  },
  {
    id: 2,
    icon: LuMapPin,
    stepName: "chooseBranch",
    stepNum: "step2",
    content: <ChooseBranch />,
  },
  {
    id: 3,
    icon: IoCalendarClearOutline,
    stepName: "chooseAppointment",
    stepNum: "step3",
    content: <ChooseAppointment />,
  },
  {
    id: 4,
    icon: FaRegCheckCircle,
    stepName: "confirmBooking",
    stepNum: "step4",
    content: <ConfirmBooking />,
  },
];

type TAvailableTimeSlot = {
  time: string;
  available: boolean;
  capacity_remaining: number;
};

export interface IBookingContact {
  name: string;
  phone: string;
  email: string;
}
export interface IBookingResult {
  id: number;
  reference: string;
  is_guest?: boolean;
  customer_phone?: string;
}

interface IreservationContext {
  steps: {
    id: number;
    icon: IconType;
    stepName: string;
    stepNum: string;
    content: ReactNode;
  }[];
  useSteps: UseStepsReturn;
  servicesList: IService[];
  branchesList: IBranch[];
  isServicesListLoading: boolean;
  isBranchesListLoading: boolean;
  reservationData: {
    service: IService | null;
    branch: IBranch | null;
    date: string | null;
    time: string | null;
  };
  isCreatingBooking: boolean;
  setService: (serviceId: number) => void;
  setBrach: (branchId: number) => void;
  setDate: (date: string) => void;
  setTime: (time: string) => void;
  createBooking: () => void;
  contact: IBookingContact;
  setContact: (c: Partial<IBookingContact>) => void;
  contactErrors: Partial<Record<keyof IBookingContact | "date", string>>;
  bookingResult: IBookingResult | null;
  availableTimeSlots: TAvailableTimeSlot[];
  isAvailableTimeSlotsLoading: boolean;
}

const initialState: IreservationContext = {
  steps,
  useSteps: {} as UseStepsReturn,
  servicesList: [],
  branchesList: [],
  isServicesListLoading: true,
  isBranchesListLoading: true,
  reservationData: { service: null, branch: null, date: null, time: null },
  isCreatingBooking: false,
  setService: () => {},
  setBrach: () => {},
  setDate: () => {},
  setTime: () => {},
  createBooking: () => {},
  contact: { name: "", phone: "", email: "" },
  setContact: () => {},
  contactErrors: {},
  bookingResult: null,
  availableTimeSlots: [],
  isAvailableTimeSlotsLoading: false,
};

const reservationContext = createContext<IreservationContext>(initialState);

export const ReservationProvider = ({
  children,
}: {
  children: React.ReactNode;
}) => {
  const { customer, isLogged } = useAuthContext();
  const locale = useLocale();
  const t = useTranslations("reservation");
  const searchParams = useSearchParams();
  // selection kept as ids/values; full objects are derived from the loaded lists
  const [selection, setSelection] = useState<{
    serviceId: number | null;
    branchId: number | null;
    date: string | null;
    time: string | null;
  }>(() => {
    const serviceId = Number(searchParams.get("service_id")) || null;
    const branchId = serviceId
      ? Number(searchParams.get("branch_id")) || null
      : null;
    return { serviceId, branchId, date: null, time: null };
  });
  const [contactInput, setContactInput] = useState<Partial<IBookingContact>>(
    {},
  );
  const [contactErrors, setContactErrors] = useState<
    IreservationContext["contactErrors"]
  >({});
  const [bookingResult, setBookingResult] = useState<IBookingResult | null>(
    null,
  );
  const contact: IBookingContact = {
    name: contactInput.name ?? customer?.name ?? "",
    phone: contactInput.phone ?? customer?.phone ?? "",
    email: contactInput.email ?? customer?.email ?? "",
  };
  const setContact = (c: Partial<IBookingContact>) =>
    setContactInput((p) => ({ ...p, ...c }));
  const useSteps = useChakraSteps({
    defaultStep: selection.serviceId ? (selection.branchId ? 2 : 1) : 0,
    count: steps.length,
  });
  //   fetch the services data
  const { data: servicesList, isLoading: isServicesListLoading } = useQuery({
    queryKey: ["services"],
    queryFn: async () => {
      const { data } = await axiosInstance<{ data: IService[] }>("services");
      return data.data;
    },
  });
  //   fetch the branches data
  const { data: branchesList, isLoading: isBranchesListLoading } = useQuery({
    queryKey: ["branches"],
    queryFn: async () => {
      const { data } = await axiosInstance<{ data: IBranch[] }>("branches");
      return data.data;
    },
  });
  const reservationData = useMemo<IreservationContext["reservationData"]>(
    () => ({
      service:
        (servicesList ?? []).find((x) => x.id === selection.serviceId) ??
        null,
      branch:
        (branchesList ?? []).find((x) => x.id === selection.branchId) ?? null,
      date: selection.date,
      time: selection.time,
    }),
    [servicesList, branchesList, selection],
  );
  //   fetch the available time slots
  const {
    data: availableTimeSlots = [],
    isFetching: isAvailableTimeSlotsLoading,
    refetch: getAvailableTimesSlots,
  } = useQuery({
    queryKey: ["availableTimes"],
    queryFn: async () => {
      const { data } = await axiosInstance<{ data: TAvailableTimeSlot[] }>(
        `bookings/branch/${reservationData.branch?.id}/slots`,
        {
          params: {
            date: reservationData.date,
          },
        },
      );
      return data.data;
    },
    enabled: false,
  });
  //   mutation booking
  const { mutate: mutateBooking, isPending: isCreatingBooking } = useMutation({
    mutationKey: ["createBooking"],
    mutationFn: async (body: {
      branch_id: number;
      service_id: number;
      scheduled_at: string;
      customer_name?: string;
      customer_phone?: string;
      customer_email?: string;
      locale?: string;
    }) => {
      const { data } = await axiosInstance.post<{ data: IBookingResult }>(
        "bookings",
        body,
      );
      return data.data;
    },
    onSuccess: (res) => setBookingResult(res),
    onError: (err: AxiosError<{ message?: string }>) => {
      if (err.status === 401) return;
      const errorMessage =
        err.response?.data?.message ?? "Oops! something went wrong";
      toast.error(errorMessage);
    },
  });
  //   set service
  const setService = (serviceId: number) =>
    setSelection({ serviceId, branchId: null, date: null, time: null });
  //   set branch
  const setBrach = (branchId: number) =>
    setSelection((p) => ({ ...p, date: null, time: null, branchId }));
  //   set date
  const setDate = (date: string) => {
    setSelection((p) => ({ ...p, time: null, date }));
    if (reservationData.branch) {
      getAvailableTimesSlots();
    }
  };
  //   set time
  const setTime = (time: string) => setSelection((p) => ({ ...p, time }));
  // create booking
  const createBooking = () => {
    const { service, branch, date, time } = reservationData;
    if (!service || !branch || !date || !time) return;
    const errs: IreservationContext["contactErrors"] = {};
    const scheduled = new Date(`${date}T${time}`);
    if (Number.isNaN(scheduled.getTime()) || scheduled.getTime() <= Date.now()) {
      errs.date = "bookingDateInPast";
    }
    if (!isLogged) {
      if (!contact.name.trim()) errs.name = "fullNameRequired";
      if (!contact.phone.trim()) errs.phone = "phoneRequired";
      else if (!isValidIraqiPhone(contact.phone)) errs.phone = "phoneInvalid";
      if (
        contact.email.trim() &&
        !/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(contact.email.trim())
      ) {
        errs.email = "invalidEmail";
      }
    }
    setContactErrors(errs);
    if (Object.keys(errs).length) {
      if (errs.date) toast.error(t("bookingDateInPast"));
      return;
    }
    mutateBooking({
      service_id: service.id,
      branch_id: branch.id,
      scheduled_at: `${date}T${time}`,
      locale,
      ...(isLogged
        ? {}
        : {
            customer_name: contact.name.trim(),
            customer_phone: contact.phone.trim(),
            customer_email: contact.email.trim() || undefined,
          }),
    });
  };

  return (
    <reservationContext.Provider
      value={{
        steps,
        useSteps,
        servicesList: servicesList ?? [],
        branchesList: branchesList ?? [],
        isServicesListLoading,
        isBranchesListLoading,
        reservationData,
        setService,
        setBrach,
        setDate,
        setTime,
        createBooking,
        contact,
        setContact,
        contactErrors,
        bookingResult,
        isCreatingBooking,
        availableTimeSlots,
        isAvailableTimeSlotsLoading,
      }}
    >
      {children}
    </reservationContext.Provider>
  );
};

export const useReservationContext = () => useContext(reservationContext);
