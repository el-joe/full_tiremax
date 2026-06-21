export interface IVehicle {
  id: number;
  vehicle_model_id: number;
  year_from: number;
  year_to: number;
  trim_code: string;
  trim_name: string;
  engine: string;
  notes: string;
  model: Model;
}

export interface Model {
  id: number;
  slug: string;
  name: string;
  vehicle_make_id: number;
}
