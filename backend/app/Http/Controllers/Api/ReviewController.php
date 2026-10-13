<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Http\Requests\Api\StoreReviewRequest;
use App\Http\Resources\ReviewResource;
use App\Models\Order;
use App\Models\Product;
use App\Models\Review;
use App\Support\ApiException;
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
        $customerId = $request->user()->id;
        $order = Order::where('id', $request->order_id)->where('customer_id', $customerId)->first();

        if (!$order) {
            throw ApiException::forbidden(__('messages.forbidden'));
        }
        if (!in_array($order->status, [Order::STATUS_DELIVERED, Order::STATUS_COMPLETED], true)) {
            throw ApiException::badRequest(__('messages.review_order_not_delivered'));
        }
        if (!$order->items()->where('product_id', $product->id)->exists()) {
            throw ApiException::badRequest(__('messages.review_product_not_in_order'));
        }
        if (Review::where('order_id', $order->id)->where('product_id', $product->id)->where('customer_id', $customerId)->exists()) {
            throw ApiException::badRequest(__('messages.review_already_submitted'));
        }

        $review = Review::create([
            'customer_id' => $customerId,
            'order_id' => $order->id,
            'product_id' => $product->id,
            'type' => Review::TYPE_CUSTOMER,
            'rating' => $request->rating,
            'comment' => $request->comment,
            'is_approved' => null, // pending moderation
        ]);
        return ApiResponse::created(new ReviewResource($review), __('messages.review_submitted'));
    }
}
