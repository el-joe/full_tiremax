export interface IPayment {
  id: number;
  order_id: number;
  payment_gateway_id: number;
  amount: number;
  currency: string;
  status: string;
  transaction_id: string | null;
  redirect_url: string | null;
  gateway_response: Record<string, unknown> | null;
  paid_at: string | null;
  gateway: {
    id: number;
    name: string;
    display_name: string;
    driver: string;
  };
}
