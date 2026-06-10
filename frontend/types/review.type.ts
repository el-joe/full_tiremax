export interface IReview {
    id: number;
    type: string;
    rating: number;
    comment: string;
    created_at: Date;
    customer: Customer;
}

export interface Customer {
    id: number;
    name: string;
}
