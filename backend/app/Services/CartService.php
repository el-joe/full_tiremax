<?php

namespace App\Services;

use App\Models\Cart;
use App\Models\CartItem;
use App\Models\Customer;
use App\Models\Offer;
use App\Models\Product;
use App\Support\ApiException;
use Illuminate\Support\Facades\DB;

class CartService
{
    public function getOrCreate(Customer $customer): Cart
    {
        return Cart::firstOrCreate(['customer_id' => $customer->id]);
    }

    public function show(Customer $customer): Cart
    {
        $cart = $this->getOrCreate($customer);
        return $cart->load(['items.product.brand', 'items.product.images', 'governorate']);
    }

    public function addItem(Customer $customer, int $productId, int $quantity = 1): Cart
    {
        return DB::transaction(function () use ($customer, $productId, $quantity) {
            $cart = $this->getOrCreate($customer);
            $product = Product::active()->findOrFail($productId);

            if ($product->stock < $quantity) {
                throw ApiException::badRequest(__('messages.insufficient_stock'));
            }

            $item = CartItem::firstOrNew([
                'cart_id' => $cart->id,
                'product_id' => $product->id,
            ]);
            $item->quantity = ($item->exists ? $item->quantity : 0) + $quantity;
            $item->unit_price = $product->effective_price;
            $item->save();

            return $cart->load('items.product');
        });
    }

    public function updateItem(Customer $customer, int $itemId, int $quantity): Cart
    {
        return DB::transaction(function () use ($customer, $itemId, $quantity) {
            $cart = $this->getOrCreate($customer);
            $item = $cart->items()->where('id', $itemId)->firstOrFail();

            if ($quantity <= 0) {
                $item->delete();
            } else {
                if ($item->product->stock < $quantity) {
                    throw ApiException::badRequest(__('messages.insufficient_stock'));
                }
                $item->update(['quantity' => $quantity]);
            }

            return $cart->fresh('items.product');
        });
    }

    public function removeItem(Customer $customer, int $itemId): Cart
    {
        $cart = $this->getOrCreate($customer);
        $cart->items()->where('id', $itemId)->delete();
        return $cart->fresh('items.product');
    }

    public function clear(Customer $customer): void
    {
        $cart = $this->getOrCreate($customer);
        $cart->items()->delete();
    }

    public function applyOffer(Customer $customer, string $code): array
    {
        $offer = Offer::where('code', $code)->firstOrFail();
        if (!$offer->isLive()) {
            throw ApiException::badRequest(__('messages.offer_invalid'));
        }

        $cart = $this->show($customer);
        $subtotal = $this->subtotal($cart);

        if ($subtotal < (float) $offer->min_subtotal) {
            throw ApiException::badRequest(__('messages.offer_min_subtotal'));
        }

        $discount = $offer->discount_type === 'percent'
            ? round($subtotal * ($offer->discount_value / 100), 2)
            : (float) $offer->discount_value;

        return [
            'offer' => $offer,
            'discount' => min($discount, $subtotal),
            'subtotal' => $subtotal,
            'total' => max(0, $subtotal - $discount),
        ];
    }

    public function subtotal(Cart $cart): float
    {
        return (float) $cart->items->sum(fn($i) => $i->unit_price * $i->quantity);
    }
}
