import AddressesList from "@/components/pages/profile/addresses/AddressesList";
import { IAddress, IApiMetaRes } from "@/types";
import axiosInstance from "@/utils/axiosInstance";
import { AxiosError } from "axios";
import React from "react";
import { FiHome } from "react-icons/fi";
import { MdWork } from "react-icons/md";

// const addresses = [
//   {
//     id: 1,
//     icon: FiHome,
//     title: "المنزل",
//     address_line1: "البصرة، البصرة",
//     address_line2: "حي الجمهورية، شارع الكويت، بناية 12، الطابق الثالث",
//     full_address:
//       "البصرة، البصرة حي الجمهورية، شارع الكويت، بناية 12، الطابق الثالث",
//     phone: "9999999999",
//     is_default: true,
//   },
//   {
//     id: 2,
//     icon: MdWork,
//     title: "العمل",
//     address_line1: "ميسان، العمارة",
//     address_line2: "شارع الحبوبي، مجمع الأعمال، الطابق الخامس، مكتب 502",
//     full_address:
//       "ميسان، العمارة شارع الحبوبي، مجمع الأعمال، الطابق الخامس، مكتب 502",
//     phone: "9999999999",
//     is_default: false,
//   },
// ];

export default async function page() {
  try {
    const { data } = await axiosInstance.get<{
      data: IAddress[];
      meta: IApiMetaRes;
    }>("addresses");

    if (data) {
      return (
        <AddressesList
          data={data.data}
          //  paginationInfo={data.meta}
        />
      );
    }
  } catch (error: unknown) {
    if (error instanceof AxiosError) {
      return (
        <AddressesList
          data={[]}
          //  paginationInfo={data.meta}
        />
      );
    }
    return <div>Unexpected error</div>;
  }
}
