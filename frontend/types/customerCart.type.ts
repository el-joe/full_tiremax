export interface ICustomerCart {
    id: number;
    governorate_id: null;
    items: Item[];
    subtotal: number;
    items_count: number;
}

export interface Item {
    id: number;
    product_id: number;
    product: Product;
    quantity: number;
    unit_price: number;
    total: number;
}

export interface Product {
    id: number;
    name: string;
    effective_price: number;
    primary_image: string;
}
