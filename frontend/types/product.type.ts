export interface IProduct {
  id: number;
  sku: string;
  type: string;
  name: string;
  short_description: string;
  description: string | null;
  pattern_name: string;
  usage_notes: string | null;
  price: number;
  sale_price: number | null;
  effective_price: number;
  has_discount: boolean;
  is_flash_sale: boolean;
  flash_sale: {
    id: number;
    title: string;
    discount_percent: number;
    ends_at: string;
    countdown_seconds: number;
  } | null;
  stock: number;
  in_stock: boolean;
  manufacture_year: number;
  manufacturer_warranty_months: number;
  agency_warranty_months: number;
  expert_rating: number | null;
  sales_count: number;
  views_count: number;
  is_featured: boolean;
  badges: string[];
  images: { url: string; is_primary: boolean }[];
  primary_image: string | null;
  brand: Brand;
  category: ICategory;
  tire_spec: TireSpec;
  battery_spec: IBatterySpec;
}

export interface Brand {
  id: number;
  slug: string;
  name: string;
  description: string | null;
  logo: string | null;
  country: string;
  is_active: boolean;
}

export interface TireSpec {
  width: number;
  aspect_ratio: number;
  rim_diameter: number;
  load_index: string;
  speed_rating: string;
  usage_type: string;
  runflat: boolean;
  size_string: string;
}

export interface IBatterySpec {
  voltage: number,
  ampere_hour: number,
  cca: number,
  battery_type: string,
  terminal_position: string,
  size_code: string
}

export interface ICategory {
  id: number,
  slug: string,
  name: string,
  description: string | null,
  product_type: string,
  icon: string | null
}
