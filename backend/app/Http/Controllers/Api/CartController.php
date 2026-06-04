<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Http\Requests\Api\StoreCartItemRequest;
use App\Http\Resources\CartResource;
use App\Models\CartItem;
use App\Services\CartService;
use App\Support\ApiResponse;
use Illuminate\Http\Request;

class CartController extends Controller
{
    public function __construct(protected CartService $service)
    {
    }

    public function show(Request $request)
    {
        return ApiResponse::success(new CartResource($this->service->show($request->user())));
    }

    public function addItem(StoreCartItemRequest $request)
    {
        $cart = $this->service->addItem($request->user(), $request->product_id, (int) $request->quantity);
        return ApiResponse::success(new CartResource($cart->load(['items.product.brand', 'items.product.images'])), __('messages.added'));
    }

    public function updateItem(Request $request, CartItem $item)
    {
        $request->validate(['quantity' => ['required', 'integer', 'min:0', 'max:99']]);
        $cart = $this->service->updateItem($request->user(), $item->id, (int) $request->quantity);
        return ApiResponse::success(new CartResource($cart->load(['items.product.brand', 'items.product.images'])), __('messages.updated'));
    }

    public function removeItem(Request $request, CartItem $item)
    {
        $cart = $this->service->removeItem($request->user(), $item->id);
        return ApiResponse::success(new CartResource($cart->load(['items.product.brand', 'items.product.images'])), __('messages.deleted'));
    }

    public function clear(Request $request)
    {
        $this->service->clear($request->user());
        return ApiResponse::success(null, __('messages.deleted'));
    }

    public function applyOffer(Request $request)
    {
        $request->validate(['code' => ['required', 'string']]);
        $result = $this->service->applyOffer($request->user(), $request->code);
        return ApiResponse::success([
            'discount' => $result['discount'],
            'subtotal' => $result['subtotal'],
            'total' => $result['total'],
            'offer' => [
                'code' => $result['offer']->code,
                'title' => $result['offer']->title,
            ],
        ]);
    }
}
