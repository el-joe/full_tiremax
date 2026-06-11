export interface ICustomerCart {
    id: number;
    governorate_id: number | null;
    governorate: string | null;
    items: ICartItem[];
    subtotal: number;
    items_count: number;
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
    name: string;
    price: number;
    sale_price: number | null;
    effective_price: number;
    in_stock: boolean;
    primary_image: string | null;
    brand: Brand;
}

export interface Brand {
    id: number;
    name: string;
}