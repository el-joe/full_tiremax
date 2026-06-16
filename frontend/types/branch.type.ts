export interface IBranch {
    id: number;
    code: string;
    name: string;
    address: string;
    description: string;
    phone: string;
    email: string;
    latitude: number;
    longitude: number;
    is_main: boolean;
    is_active: boolean;
    schedules: Schedule[];
}

export interface Schedule {
    day_of_week: number;
    opens_at: null | string;
    closes_at: null | string;
    capacity: number;
    is_closed: boolean;
}
