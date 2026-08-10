import { IGovernorate } from "./governorate.type";

export interface ICustomerCart {
  id: number;
  items: ICartItem[];
  subtotal: number;
  items_count: number;
  governorate_id: number | null;
  governorate: IGovernorate | null;
}

export interface IApplyOfferResult {
  discount: number;
  subtotal: number;
  total: number;
  offer: {
    code: string;
    title: string;
  };
}

export interface ICartItem {
  id: number;
  product_id: number;
  product: ICartProduct;
  quantity: number;
  unit_price: number;
  total: number;
}

export interface ICartProduct {
  id: number;
  sku: string;
  type: string;
  name: string;
  short_description: string;
  description: string;
  pattern_name: string;
  usage_notes: string;
  price: number;
  sale_price: number;
  effective_price: number;
  has_discount: boolean;
  is_flash_sale: boolean;
  flash_sale: number;
  stock: number;
  in_stock: boolean;
  manufacture_year: number;
  manufacturer_warranty_months: number;
  agency_warranty_months: number;
  expert_rating: number;
  sales_count: number;
  views_count: number;
  is_featured: boolean;
  images: string[];
  primary_image: null;
  brand: Brand;
}

export interface Brand {
  id: number;
  slug: string;
  name: string;
  description: string;
  logo: string;
  country: string;
  is_active: boolean;
}
