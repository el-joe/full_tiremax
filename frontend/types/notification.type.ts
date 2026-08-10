export interface INotification {
  id: string;
  type: string;
  title: string;
  body: string;
  data: Data;
  read_at: string | null;
  created_at: Date;
}

export interface Data {
  title: string;
  body: string;
  order_id?: number;
  [key: string]: unknown;
}
