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
import { useQuery } from "@tanstack/react-query";
import {
  createContext,
  ReactNode,
  useContext,
  useEffect,
  useState,
} from "react";
import { AiOutlineTool } from "react-icons/ai";
import { FaRegCheckCircle } from "react-icons/fa";
import { IoCalendarClearOutline } from "react-icons/io5";
import { IconType } from "react-icons/lib";
import { LuMapPin } from "react-icons/lu";

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
  };
  setService: (serviceId: number) => void;
  setBrach: (branchId: number) => void;
}

const initialState: IreservationContext = {
  steps,
  useSteps: {} as UseStepsReturn,
  servicesList: [],
  branchesList: [],
  isServicesListLoading: true,
  isBranchesListLoading: true,
  reservationData: { service: null, branch: null },
  setService: () => {},
  setBrach: () => {},
};

const reservationContext = createContext<IreservationContext>(initialState);

export const ReservationProvider = ({
  children,
}: {
  children: React.ReactNode;
}) => {
  const [reservationData, setReservationData] = useState<
    IreservationContext["reservationData"]
  >({ service: null, branch: null });
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
  //   set service
  const setService = (serviceId: number) => {
    const service =
      (servicesList ?? []).find((s) => s.id === serviceId) ?? null;
    setReservationData((p) => ({ ...p, service }));
  };
  //   set branch
  const setBrach = (serviceId: number) => {
    const branch = (branchesList ?? []).find((s) => s.id === serviceId) ?? null;
    setReservationData((p) => ({ ...p, branch }));
  };

  useEffect(() => {
    console.log(reservationData);
    // switch (true) {
    //   case reservationData.service && !reservationData.branch:
    //     useSteps.setStep(1);
    // }
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
      }}
    >
      {children}
    </reservationContext.Provider>
  );
};

export const useReservationContext = () => useContext(reservationContext);
