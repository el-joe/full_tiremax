export interface ICustomerFav {
    id: number;
    sku: string;
    name: string;
    price: number;
    sale_price: number | null;
    effective_price: number | null;
    has_discount: boolean;
    in_stock: boolean;
    is_featured: boolean;
    badges: string[];
    primary_image: string | null;
    brand: Brand;
}

export interface Brand {
    id: number;
    slug: string;
    name: string;
}
