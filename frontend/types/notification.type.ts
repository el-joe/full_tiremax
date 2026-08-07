export interface INotification {
  id: string;
  type: string;
  data: Data;
  read_at: null;
  created_at: Date;
}

export interface Data {
  title: string;
  body: string;
  order_id: number;
}
