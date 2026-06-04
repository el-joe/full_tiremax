<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Http\Requests\Api\StoreOrderRequest;
use App\Http\Resources\OrderResource;
use App\Models\Order;
use App\Services\OrderService;
use App\Support\ApiException;
use App\Support\ApiResponse;
use Illuminate\Http\Request;

class OrderController extends Controller
{
    public function __construct(protected OrderService $service)
    {
    }

    public function index(Request $request)
    {
        $paginator = $this->service->paginateForCustomer($request->user(), $request->all());
        return ApiResponse::success(OrderResource::collection($paginator), null, 200, [
            'pagination' => [
                'total' => $paginator->total(),
                'per_page' => $paginator->perPage(),
                'current_page' => $paginator->currentPage(),
                'last_page' => $paginator->lastPage(),
            ],
        ]);
    }

    public function store(StoreOrderRequest $request)
    {
        $order = $this->service->checkout($request->user(), $request->validated());
        return ApiResponse::created(new OrderResource($order), __('messages.order_placed'));
    }

    public function show(Request $request, Order $order)
    {
        if ($order->customer_id !== $request->user()->id) {
            throw ApiException::forbidden();
        }
        $order->load(['items.product', 'governorate', 'branch']);
        return ApiResponse::success(new OrderResource($order));
    }

    public function cancel(Request $request, Order $order)
    {
        if ($order->customer_id !== $request->user()->id) {
            throw ApiException::forbidden();
        }
        $order = $this->service->cancel($order, $request->user());
        return ApiResponse::success(new OrderResource($order), __('messages.cancelled'));
    }
}
