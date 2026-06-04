<?php

namespace Database\Seeders;

use App\Models\Branch;
use App\Models\Customer;
use App\Models\Governorate;
use App\Models\Order;
use App\Models\OrderItem;
use App\Models\OrderStatusLog;
use App\Models\Product;
use Illuminate\Database\Seeder;

class OrderSeeder extends Seeder
{
    public function run(): void
    {
        $basra = Governorate::where('code', 'BAS')->first();
        $baghdad = Governorate::where('code', 'BGD')->first();
        $najaf = Governorate::where('code', 'NJF')->first();

        $branch = Branch::where('code', 'BAS-MAIN')->first();

        $c1 = Customer::where('phone', '+9647701234561')->first(); // أحمد — Baghdad
        $c2 = Customer::where('phone', '+9647701234562')->first(); // Mohammed — Basra
        $c3 = Customer::where('phone', '+9647701234563')->first(); // فاطمة — Najaf
        $c4 = Customer::where('phone', '+9647701234564')->first(); // علي — Basra
        $c5 = Customer::where('phone', '+9647701234565')->first(); // Sara — Baghdad

        // Products
        $mch4 = Product::where('sku', 'MCH-PRI4-205-55-16')->first();  // 88 000 IQD
        $mchps4 = Product::where('sku', 'MCH-PS4-225-45-17')->first();   // 115 000 IQD
        $varAgm = Product::where('sku', 'VAR-AGM-F21-80')->first();      // 98 000 IQD
        $bshS4 = Product::where('sku', 'BSH-S4-024-60')->first();       // 62 000 IQD
        $cntLx2 = Product::where('sku', 'CNT-CCLX2-265-65-17')->first(); // 105 000 IQD
        $hnkKe2 = Product::where('sku', 'HNK-KE2-195-65-15')->first();   // 40 000 IQD

        $orders = [

            // ── 1. Delivered order — Baghdad delivery ──────────────────────
            [
                'reference' => 'ORD-20260420-0001',
                'customer' => $c1,
                'governorate' => $baghdad,
                'branch' => null,
                'type' => 'delivery',
                'status' => 'delivered',
                'payment_method' => 'cod',
                'payment_status' => 'paid',
                'shipping_fee' => 25000,
                'discount' => 0,
                'placed_at' => now()->subDays(10),
                'items' => [
                    ['product' => $mch4, 'qty' => 4, 'unit_price' => 88000],
                ],
                'history' => [
                    ['from' => null, 'to' => 'pending', 'daysAgo' => 10],
                    ['from' => 'pending', 'to' => 'confirmed', 'daysAgo' => 10],
                    ['from' => 'confirmed', 'to' => 'processing', 'daysAgo' => 9],
                    ['from' => 'processing', 'to' => 'shipped', 'daysAgo' => 8],
                    ['from' => 'shipped', 'to' => 'delivered', 'daysAgo' => 6],
                ],
            ],

            // ── 2. Confirmed order — Basra pickup ─────────────────────────
            [
                'reference' => 'ORD-20260428-0002',
                'customer' => $c2,
                'governorate' => $basra,
                'branch' => $branch,
                'type' => 'basra',
                'status' => 'confirmed',
                'payment_method' => 'cod',
                'payment_status' => 'pending',
                'shipping_fee' => 0,
                'discount' => 0,
                'placed_at' => now()->subDays(3),
                'items' => [
                    ['product' => $hnkKe2, 'qty' => 4, 'unit_price' => 40000],
                    ['product' => $bshS4, 'qty' => 1, 'unit_price' => 62000],
                ],
                'history' => [
                    ['from' => null, 'to' => 'pending', 'daysAgo' => 3],
                    ['from' => 'pending', 'to' => 'confirmed', 'daysAgo' => 3],
                ],
            ],

            // ── 3. Pending order — Najaf delivery ────────────────────────
            [
                'reference' => 'ORD-20260501-0003',
                'customer' => $c3,
                'governorate' => $najaf,
                'branch' => null,
                'type' => 'delivery',
                'status' => 'pending',
                'payment_method' => 'cod',
                'payment_status' => 'pending',
                'shipping_fee' => 20000,
                'discount' => 0,
                'placed_at' => now(),
                'items' => [
                    ['product' => $varAgm, 'qty' => 1, 'unit_price' => 98000],
                ],
                'history' => [
                    ['from' => null, 'to' => 'pending', 'daysAgo' => 0],
                ],
            ],

            // ── 4. Shipped order — Basra pickup with offer discount ────────
            [
                'reference' => 'ORD-20260425-0004',
                'customer' => $c4,
                'governorate' => $basra,
                'branch' => $branch,
                'type' => 'basra',
                'status' => 'shipped',
                'payment_method' => 'cod',
                'payment_status' => 'pending',
                'shipping_fee' => 0,
                'discount' => 15000,
                'placed_at' => now()->subDays(6),
                'items' => [
                    ['product' => $cntLx2, 'qty' => 4, 'unit_price' => 105000],
                ],
                'history' => [
                    ['from' => null, 'to' => 'pending', 'daysAgo' => 6],
                    ['from' => 'pending', 'to' => 'confirmed', 'daysAgo' => 6],
                    ['from' => 'confirmed', 'to' => 'processing', 'daysAgo' => 5],
                    ['from' => 'processing', 'to' => 'shipped', 'daysAgo' => 4],
                ],
            ],

            // ── 5. Cancelled order — Baghdad ──────────────────────────────
            [
                'reference' => 'ORD-20260415-0005',
                'customer' => $c5,
                'governorate' => $baghdad,
                'branch' => null,
                'type' => 'delivery',
                'status' => 'cancelled',
                'payment_method' => 'cod',
                'payment_status' => 'pending',
                'shipping_fee' => 25000,
                'discount' => 0,
                'placed_at' => now()->subDays(16),
                'items' => [
                    ['product' => $mchps4, 'qty' => 4, 'unit_price' => 115000],
                ],
                'history' => [
                    ['from' => null, 'to' => 'pending', 'daysAgo' => 16],
                    ['from' => 'pending', 'to' => 'cancelled', 'daysAgo' => 15, 'note' => 'Customer requested cancellation'],
                ],
            ],
        ];

        foreach ($orders as $data) {
            if (!$data['customer']) {
                continue;
            }

            // Calculate totals
            $subtotal = collect($data['items'])->sum(fn($i) => $i['qty'] * $i['unit_price']);
            $total = $subtotal - $data['discount'] + $data['shipping_fee'];

            $order = Order::updateOrCreate(
                ['reference' => $data['reference']],
                [
                    'customer_id' => $data['customer']->id,
                    'governorate_id' => $data['governorate']?->id,
                    'branch_id' => $data['branch']?->id,
                    'type' => $data['type'],
                    'status' => $data['status'],
                    'payment_method' => $data['payment_method'],
                    'payment_status' => $data['payment_status'],
                    'subtotal' => $subtotal,
                    'discount' => $data['discount'],
                    'shipping_fee' => $data['shipping_fee'],
                    'installation_fee' => 0,
                    'total' => $total,
                    'customer_name' => $data['customer']->name,
                    'customer_phone' => $data['customer']->phone,
                    'customer_email' => $data['customer']->email,
                    'shipping_address' => $data['customer']->address,
                    'placed_at' => $data['placed_at'],
                ]
            );

            // Order items
            foreach ($data['items'] as $item) {
                if (!$item['product']) {
                    continue;
                }
                OrderItem::updateOrCreate(
                    ['order_id' => $order->id, 'product_id' => $item['product']->id],
                    [
                        'product_name' => $item['product']->translate('en')?->name ?? $item['product']->sku,
                        'product_sku' => $item['product']->sku,
                        'quantity' => $item['qty'],
                        'unit_price' => $item['unit_price'],
                        'total' => $item['qty'] * $item['unit_price'],
                    ]
                );
            }

            // Status history
            OrderStatusLog::where('order_id', $order->id)->delete();
            foreach ($data['history'] as $log) {
                OrderStatusLog::create([
                    'order_id' => $order->id,
                    'from_status' => $log['from'],
                    'to_status' => $log['to'],
                    'note' => $log['note'] ?? null,
                    'actor_type' => 'App\\Models\\Admin',
                    'actor_id' => 1,
                    'created_at' => now()->subDays($log['daysAgo']),
                    'updated_at' => now()->subDays($log['daysAgo']),
                ]);
            }
        }
    }
}
