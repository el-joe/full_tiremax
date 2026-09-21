<?php

namespace App\Services;

use App\Models\Cart;
use App\Models\CartItem;
use App\Models\Customer;
use App\Support\Actor;
use App\Models\Offer;
use App\Models\Product;
use App\Support\ApiException;
use Illuminate\Support\Facades\DB;

class CartService
{
    public function getOrCreate(Actor|Customer $actor): Cart
    {
        $actor = $actor instanceof Customer ? new Actor($actor, null) : $actor;
        if ($actor->customer) {
            return Cart::firstOrCreate(['customer_id' => $actor->customer->id]);
        }
        if (!$actor->guestToken) {
            throw ApiException::unauthorized(__('messages.unauthenticated'));
        }
        return Cart::firstOrCreate(['guest_token' => $actor->guestToken]);
    }

    public function show(Actor|Customer $customer): Cart
    {
        $cart = $this->getOrCreate($customer);
        return $cart->load(['items.product.brand', 'items.product.brand.translations', 'items.product.images', 'items.product.translations', 'governorate', 'governorate.translations']);
    }

    public function addItem(Actor|Customer $customer, int $productId, int $quantity = 1): Cart
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

            return $cart->load(['items.product', 'items.product.brand', 'items.product.brand.translations', 'items.product.translations']);
        });
    }

    public function updateItem(Actor|Customer $customer, int $itemId, int $quantity): Cart
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

    public function removeItem(Actor|Customer $customer, int $itemId): Cart
    {
        $cart = $this->getOrCreate($customer);
        $cart->items()->where('id', $itemId)->delete();
        return $cart->fresh('items.product');
    }

    public function clear(Actor|Customer $customer): void
    {
        $cart = $this->getOrCreate($customer);
        $cart->items()->delete();
    }

    public function applyOffer(Actor|Customer $customer, string $code): array
    {
        $cart = $this->show($customer);
        return $this->computeOffer($cart, $code);
    }

    /** Server-side offer/discount computation for a cart (never trust client amounts). */
    public function computeOffer(Cart $cart, string $code): array
    {
        $cart->loadMissing('items');
        return $this->computeOfferForSubtotal($code, $this->subtotal($cart));
    }

    public function computeOfferForSubtotal(string $code, float $subtotal): array
    {
        $offer = Offer::where('code', $code)->firstOrFail();
        if (!$offer->isLive()) {
            throw ApiException::badRequest(__('messages.offer_invalid'));
        }

        if ($subtotal < (float) $offer->min_subtotal) {
            throw ApiException::badRequest(__('messages.offer_min_subtotal'));
        }

        $discount = $offer->discount_type === 'percent'
            ? round($subtotal * ($offer->discount_value / 100), 2)
            : (float) $offer->discount_value;
        $discount = min($discount, $subtotal);

        return [
            'offer' => $offer,
            'discount' => $discount,
            'subtotal' => $subtotal,
            'total' => max(0, $subtotal - $discount),
        ];
    }

    public function subtotal(Cart $cart): float
    {
        return (float) $cart->items->sum(fn($i) => $i->unit_price * $i->quantity);
    }
}
