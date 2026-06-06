export interface IProduct {
  id: number;
  sku: string;
  type: string;
  name: string;
  short_description: string;
  description: null;
  pattern_name: string;
  usage_notes: null;
  price: number;
  sale_price: null;
  effective_price: number;
  has_discount: boolean;
  is_flash_sale: boolean;
  flash_sale: null;
  stock: number;
  in_stock: boolean;
  manufacture_year: number;
  manufacturer_warranty_months: number;
  agency_warranty_months: number;
  expert_rating: number;
  sales_count: number;
  views_count: number;
  is_featured: boolean;
  badges: string[];
  images: string[];
  primary_image: null;
  brand: Brand;
  tire_spec: TireSpec;
  battery_spec: null;
}

export interface Brand {
  id: number;
  slug: string;
  name: string;
  description: null;
  logo: null;
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
