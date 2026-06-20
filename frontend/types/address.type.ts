export interface IAddress {
  id: number;
  full_name: string;
  phone: string;
  governorate: Governorate;
  city: City;
  address: string;
  is_default: boolean;
}

export interface City {
  id: number;
  name_ar: string;
  name_en: string;
}

export interface Governorate {
  id: number;
  code: string;
  name: string;
  is_basra: boolean;
  shipping_fee: number;
}
