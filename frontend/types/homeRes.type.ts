import { IBrand } from "./brand.type";
import { IGovernorate } from "./governorate.type";
import { IProduct } from "./product.type";

export interface IHomeResponse {
  featured: IProduct[];
  best_sellers: IProduct[];
  new_arrivals: IProduct[];
  offers: IProduct[];
  brands: IBrand[];
  governorates: IGovernorate[];
}
