import { IconType } from "react-icons/lib";

export interface IAddress {
  id: number;
  icon: IconType;
  title: string;
  name: string;
  address_line1: string;
  address_line2: string;
  full_address: string;
  phone: string;
  is_default: boolean;
}
