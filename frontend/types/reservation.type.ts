export interface IReservation {
  id: number;
  reference: string;
  scheduled_at: Date;
  duration_minutes: number;
  status: string;
  customer_notes: string;
  branch: Branch;
  service: Service;
}

export interface Branch {
  id: number;
  code: string;
  name: string;
  address: string;
  phone: string;
  latitude: number;
  longitude: number;
}

export interface Service {
  id: number;
  slug: string;
  name: string;
  description: string;
  duration_minutes: number;
  price: number;
}
