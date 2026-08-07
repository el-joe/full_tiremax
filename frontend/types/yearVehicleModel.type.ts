export interface IYearVehicleModel {
    "id": number,
    "vehicle_model_id": number,
    "year_from": number,
    "year_to": number,
    "trim_code": string,
    "trim_name": string,
    "engine": string,
    "notes": string | null
}