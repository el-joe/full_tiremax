export interface IPaymentMethod {
  id: number;
  name: string;
  display_name: string;
  driver: string;
  is_active: boolean;
}
