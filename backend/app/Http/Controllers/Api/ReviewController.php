<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Http\Requests\Api\StoreReviewRequest;
use App\Http\Resources\ReviewResource;
use App\Models\Product;
use App\Models\Review;
use App\Support\ApiResponse;

class ReviewController extends Controller
{
    public function index(Product $product)
    {
        $reviews = $product->reviews()
            ->where('is_approved', true)
            ->with('customer')
            ->latest()
            ->paginate(15);

        return ApiResponse::success(ReviewResource::collection($reviews), null, 200, [
            'pagination' => [
                'total' => $reviews->total(),
                'per_page' => $reviews->perPage(),
                'current_page' => $reviews->currentPage(),
                'last_page' => $reviews->lastPage(),
            ],
            'rating_avg' => round((float) $product->reviews()->where('is_approved', true)->avg('rating'), 2),
            'rating_count' => $product->reviews()->where('is_approved', true)->count(),
        ]);
    }

    public function store(StoreReviewRequest $request, Product $product)
    {
        $review = Review::create([
            'customer_id' => $request->user()->id,
            'product_id' => $product->id,
            'type' => Review::TYPE_CUSTOMER,
            'rating' => $request->rating,
            'comment' => $request->comment,
            'is_approved' => null, // pending moderation
        ]);
        return ApiResponse::created(new ReviewResource($review), __('messages.review_submitted'));
    }
}
