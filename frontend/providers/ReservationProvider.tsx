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
import {
  createContext,
  ReactNode,
  useContext,
  useEffect,
  useState,
} from "react";
import toast from "react-hot-toast";
import { AiOutlineTool } from "react-icons/ai";
import { FaRegCheckCircle } from "react-icons/fa";
import { IoCalendarClearOutline } from "react-icons/io5";
import { IconType } from "react-icons/lib";
import { LuMapPin } from "react-icons/lu";
import { useAuthContext } from "./AuthProvider";

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
};

const reservationContext = createContext<IreservationContext>(initialState);

export const ReservationProvider = ({
  children,
}: {
  children: React.ReactNode;
}) => {
  const { protectedWithAuth } = useAuthContext();
  const [reservationData, setReservationData] = useState<
    IreservationContext["reservationData"]
  >({ service: null, branch: null, date: null, time: null });
  const useSteps = useChakraSteps({
    defaultStep: 0,
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
  //   mutation booking
  const { mutate: mutateBooking, isPending: isCreatingBooking } = useMutation({
    mutationKey: ["createBooking"],
    mutationFn: async (body: {
      branch_id: number;
      service_id: number;
      scheduled_at: string;
    }) => {
      const { data } = await axiosInstance.post("bookings", body);
      return data;
    },
    onError: () => {
      toast.error("Oops! something want wrang");
    },
  });
  //   set service
  const setService = (serviceId: number) => {
    const service =
      (servicesList ?? []).find((s) => s.id === serviceId) ?? null;
    setReservationData({
      branch: null,
      date: null,
      time: null,
      service,
    });
  };
  //   set branch
  const setBrach = (serviceId: number) => {
    const branch = (branchesList ?? []).find((s) => s.id === serviceId) ?? null;
    setReservationData((p) => ({ ...p, date: null, time: null, branch }));
  };
  //   set date
  const setDate = (date: string) => {
    setReservationData((p) => ({ ...p, time: null, date }));
  };
  //   set time
  const setTime = (time: string) => {
    setReservationData((p) => ({ ...p, time }));
  };
  // create booking
  const createBooking = () => {
    const { service, branch, date, time } = reservationData;
    if (!service || !branch || !date || !time) return;
    const body = {
      service_id: service.id,
      branch_id: branch.id,
      scheduled_at: `${reservationData.date}T${reservationData.time}`,
    };
    protectedWithAuth(() => mutateBooking(body));
  };

  useEffect(() => {
    console.log(reservationData);
    return () => {};
  }, [reservationData]);

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
        isCreatingBooking,
      }}
    >
      {children}
    </reservationContext.Provider>
  );
};

export const useReservationContext = () => useContext(reservationContext);
