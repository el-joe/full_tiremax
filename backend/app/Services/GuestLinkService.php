<?php

namespace App\Services;

use App\Models\Booking;
use App\Models\Cart;
use App\Models\CartItem;
use App\Models\Customer;
use App\Models\Order;
use App\Models\WhatsappLog;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Log;

class GuestLinkService
{
    /**
     * Attach guest data (orders, bookings, cart) to a customer.
     * Matches by guest token, normalised phone, or email (only when the customer's email is verified).
     *
     * @return array{orders:int,bookings:int}
     */
    public function attach(Customer $customer, ?string $guestToken = null): array
    {
        $token = \App\Support\Actor::sanitizeToken($guestToken);

        return DB::transaction(function () use ($customer, $token) {
            $match = function ($q) use ($customer, $token) {
                $q->where(function ($w) use ($customer, $token) {
                    $has = false;
                    if ($token) {
                        $w->where('guest_token', $token);
                        $has = true;
                    }
                    if ($customer->phone_normalized) {
                        $has ? $w->orWhere('phone_normalized', $customer->phone_normalized) : $w->where('phone_normalized', $customer->phone_normalized);
                        $has = true;
                    }
                    if ($customer->email && $customer->email_verified_at) {
                        $has ? $w->orWhere('customer_email', $customer->email) : $w->where('customer_email', $customer->email);
                        $has = true;
                    }
                    if (!$has) {
                        $w->whereRaw('1 = 0');
                    }
                });
            };

            $orderIds = Order::whereNull('customer_id')->where($match)->pluck('id');
            $bookingIds = Booking::whereNull('customer_id')->where($match)->pluck('id');

            if ($orderIds->isNotEmpty()) {
                Order::whereIn('id', $orderIds)->update(['customer_id' => $customer->id, 'is_guest' => false, 'guest_token' => null]);
            }
            if ($bookingIds->isNotEmpty()) {
                Booking::whereIn('id', $bookingIds)->update(['customer_id' => $customer->id, 'is_guest' => false, 'guest_token' => null]);
            }

            WhatsappLog::whereNull('customer_id')->where(function ($q) use ($orderIds, $bookingIds) {
                $q->whereIn('order_id', $orderIds)->orWhereIn('booking_id', $bookingIds);
            })->update(['customer_id' => $customer->id]);

            if ($token) {
                $this->mergeCart($customer, $token);
            }

            if ($orderIds->count() || $bookingIds->count()) {
                Log::info('Guest data linked to customer', [
                    'customer_id' => $customer->id, 'orders' => $orderIds->count(), 'bookings' => $bookingIds->count(),
                ]);
            }

            return ['orders' => $orderIds->count(), 'bookings' => $bookingIds->count()];
        });
    }

    protected function mergeCart(Customer $customer, string $token): void
    {
        $guestCart = Cart::where('guest_token', $token)->whereNull('customer_id')->with('items.product')->first();
        if (!$guestCart) {
            return;
        }
        $cart = Cart::firstOrCreate(['customer_id' => $customer->id]);

        foreach ($guestCart->items as $gi) {
            $product = $gi->product;
            if (!$product || !$product->is_active || $product->stock < 1) {
                continue;
            }
            $item = CartItem::firstOrNew(['cart_id' => $cart->id, 'product_id' => $gi->product_id]);
            $qty = ($item->exists ? $item->quantity : 0) + $gi->quantity;
            $item->quantity = max(1, min($qty, (int) $product->stock, 99));
            $item->unit_price = $product->effective_price;
            $item->save();
        }
        $guestCart->delete();
    }
}
