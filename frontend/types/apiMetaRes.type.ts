export interface IApiMetaRes {
    pagination: {
        total: number,
        per_page: number,
        current_page: number,
        last_page: number
    }
}

export interface IProductReviewMeta extends IApiMetaRes {
    rating_avg: number,
    rating_count: number
}