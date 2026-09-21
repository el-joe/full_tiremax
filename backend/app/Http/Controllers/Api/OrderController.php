<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Http\Requests\Api\StoreOrderRequest;
use App\Http\Resources\OrderResource;
use App\Models\Order;
use App\Services\OrderService;
use App\Support\Actor;
use App\Support\ApiException;
use App\Support\Phone;
use App\Support\ApiResponse;
use Illuminate\Http\Request;

class OrderController extends Controller
{
    public function __construct(protected OrderService $service)
    {
    }

    public function index(Request $request)
    {
        $paginator = $this->service->paginateForCustomer(Actor::fromRequest($request)->customer ?? throw ApiException::unauthorized(__('messages.unauthenticated')), $request->all());
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
        $actor = Actor::fromRequest($request)->require();
        $order = $this->service->checkout($actor, $request->validated());
        return ApiResponse::created(new OrderResource($order), __('messages.order_placed'));
    }

    public function show(Request $request, string $orderRef)
    {
        $actor = Actor::fromRequest($request);
        $order = ctype_digit($orderRef)
            ? Order::find($orderRef)
            : Order::where('reference', $orderRef)->first();

        $allowed = $order && $actor->owns($order);
        // Guests may also look up their own (guest) order by reference + the phone used at checkout.
        if ($order && !$allowed && !ctype_digit($orderRef) && $order->customer_id === null && $request->filled('phone')) {
            $n = Phone::normalize((string) $request->query('phone'));
            $allowed = $n !== null && $order->phone_normalized !== null && hash_equals($order->phone_normalized, $n);
        }
        if (!$allowed) {
            // Same response for "missing" and "not yours": no enumeration.
            throw ApiException::notFound();
        }

        $order->load(['items.product', 'governorate', 'governorate.translations', 'branch', 'branch.translations']);
        return ApiResponse::success(new OrderResource($order));
    }

    public function cancel(Request $request, Order $order)
    {
        $actor = Actor::fromRequest($request)->require();
        if (!$actor->owns($order)) {
            throw ApiException::forbidden();
        }
        $order = $this->service->cancel($order, $actor->customer);
        return ApiResponse::success(new OrderResource($order), __('messages.cancelled'));
    }
}
