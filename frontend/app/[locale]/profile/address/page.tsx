import AddressesList from "@/components/pages/profile/addresses/AddressesList";
import { IAddress, IApiMetaRes } from "@/types";
import axiosInstance from "@/utils/axiosInstance";
import { AxiosError } from "axios";

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
