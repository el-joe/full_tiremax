export interface IOrder {
    id: number;
    reference: string;
    type: string;
    status: string;
    payment_method: string;
    payment_status: string;
    subtotal: number;
    discount: number;
    shipping_fee: number;
    installation_fee: number;
    total: number;
    customer_name: string;
    customer_phone: string;
    customer_email: string;
    shipping_address: string;
    tracking_number: string;
    placed_at: Date | string;
    governorate: Governorate;
    branch: null;
    items: Item[];
}

export interface Governorate {
    id: number;
    code: string;
    name: string;
    is_basra: boolean;
    shipping_fee: number;
}

export interface Item {
    id: number;
    product_id: number;
    product_name: string;
    product_sku: string;
    quantity: number;
    unit_price: number;
    total: number;
}
