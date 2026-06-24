<?php

namespace App\Services;

use App\Events\OrderPlaced;
use App\Notifications\OrderPlacedNotification;
use App\Notifications\OrderStatusChangedNotification;
use App\Models\Branch;
use App\Models\Customer;
use App\Models\Governorate;
use App\Models\Order;
use App\Models\OrderStatusLog;
use App\Models\Payment;
use App\Models\Product;
use App\Support\ApiException;
use Illuminate\Contracts\Pagination\LengthAwarePaginator;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Str;

class OrderService
{
    public function __construct(
        protected CartService $cartService,
        protected PaymentService $paymentService,
    ) {}


    public function paginateForCustomer(Customer $customer, array $filters = []): LengthAwarePaginator
    {
        return $customer->orders()
            ->with(['items.product', 'governorate', 'branch'])
            ->latest()
            ->paginate((int) ($filters['per_page'] ?? 15));
    }

    public function checkout(Customer $customer, array $data): Order
    {
        return DB::transaction(function () use ($customer, $data) {
            $cart = $this->cartService->show($customer);
            if ($cart->items->isEmpty()) {
                throw ApiException::badRequest(__('messages.cart_empty'));
            }

            $type = $data['type']; // basra | delivery
            $branch = null;
            $governorate = null;
            $shippingFee = 0;
            $installationFee = 0;

            if ($type === Order::TYPE_BASRA) {
                $branch = Branch::findOrFail($data['branch_id']);
                $installationFee = (float) ($data['installation_fee'] ?? 0);
            } else {
                $governorate = Governorate::findOrFail($data['governorate_id']);
                if ($governorate->is_basra) {
                    throw ApiException::badRequest(__('messages.basra_use_branch'));
                }
                $shippingFee = (float) $governorate->shipping_fee;
            }

            $subtotal = 0;
            $itemsData = [];

            foreach ($cart->items as $item) {
                $product = Product::lockForUpdate()->find($item->product_id);
                if (!$product || !$product->is_active) {
                    throw ApiException::badRequest(__('messages.product_unavailable'));
                }
                if ($product->stock < $item->quantity) {
                    throw ApiException::badRequest(__('messages.insufficient_stock'));
                }
                $price = (float) $product->effective_price;
                $line = round($price * $item->quantity, 2);
                $subtotal += $line;

                $itemsData[] = [
                    'product_id' => $product->id,
                    'product_name' => $product->name,
                    'product_sku' => $product->sku,
                    'quantity' => $item->quantity,
                    'unit_price' => $price,
                    'total' => $line,
                ];

                $product->decrement('stock', $item->quantity);
                $product->increment('real_sales_count', $item->quantity);
            }

            $discount = (float) ($data['discount'] ?? 0);
            $total = max(0, $subtotal - $discount + $shippingFee + $installationFee);

            $order = Order::create([
                'reference' => $this->generateReference(),
                'customer_id' => $customer->id,
                'governorate_id' => $governorate?->id,
                'branch_id' => $branch?->id,
                'type' => $type,
                'status' => Order::STATUS_PENDING,
                'payment_method' => $data['payment_method'] ?? 'cod',
                'payment_status' => 'pending',
                'subtotal' => $subtotal,
                'discount' => $discount,
                'shipping_fee' => $shippingFee,
                'installation_fee' => $installationFee,
                'total' => $total,
                'customer_name' => $data['customer_name'] ?? $customer->name,
                'customer_phone' => $data['customer_phone'] ?? $customer->phone,
                'customer_email' => $data['customer_email'] ?? $customer->email,
                'shipping_address' => $data['shipping_address'] ?? null,
                'notes' => $data['notes'] ?? null,
                'placed_at' => now(),
            ]);

            $order->items()->createMany($itemsData);

            OrderStatusLog::create([
                'order_id' => $order->id,
                'from_status' => null,
                'to_status' => Order::STATUS_PENDING,
                'note' => 'Order placed by customer',
                'actor_type' => Customer::class,
                'actor_id' => $customer->id,
            ]);

            $this->cartService->clear($customer);

            $driver = $data['payment_method'] ?? 'cod';
            $this->paymentService->initiate($order, $driver);

            OrderPlaced::dispatch($order);
            $customer->notify(new OrderPlacedNotification($order));

            return $order->load('items.product', 'governorate', 'branch', 'payments.gateway');
        });
    }

    public function cancel(Order $order, ?Customer $by = null): Order
    {
        if (!in_array($order->status, [Order::STATUS_PENDING, Order::STATUS_CONFIRMED], true)) {
            throw ApiException::badRequest(__('messages.cannot_cancel'));
        }
        return $this->changeStatus($order, Order::STATUS_CANCELLED, 'Cancelled', $by);
    }

    public function changeStatus(Order $order, string $status, ?string $note = null, mixed $actor = null): Order
    {
        return DB::transaction(function () use ($order, $status, $note, $actor) {
            $from = $order->status;
            $order->update(['status' => $status]);

            // Restore stock if cancelled
            if ($status === Order::STATUS_CANCELLED && in_array($from, [Order::STATUS_PENDING, Order::STATUS_CONFIRMED], true)) {
                foreach ($order->items as $item) {
                    if ($item->product) {
                        $item->product->increment('stock', $item->quantity);
                        $item->product->decrement('real_sales_count', $item->quantity);
                    }
                }
            }

            OrderStatusLog::create([
                'order_id' => $order->id,
                'from_status' => $from,
                'to_status' => $status,
                'note' => $note,
                'actor_type' => $actor ? get_class($actor) : null,
                'actor_id' => $actor?->getKey(),
            ]);

            if ($order->customer) {
                $order->customer->notify(new OrderStatusChangedNotification($order, $from));
            }

            return $order->fresh('items.product');
        });
    }

    protected function generateReference(): string
    {
        return 'ORD-' . now()->format('ymd') . '-' . strtoupper(Str::random(6));
    }
}
