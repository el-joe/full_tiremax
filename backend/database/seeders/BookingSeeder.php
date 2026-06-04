<?php

namespace Database\Seeders;

use App\Models\Booking;
use App\Models\Branch;
use App\Models\Customer;
use App\Models\Order;
use App\Models\Service;
use Illuminate\Database\Seeder;

class BookingSeeder extends Seeder
{
    public function run(): void
    {
        $branch = Branch::where('code', 'BAS-MAIN')->first();

        if (!$branch) {
            return;
        }

        $install = Service::where('slug', 'tire-installation')->first();
        $balance = Service::where('slug', 'wheel-balancing')->first();
        $alignment = Service::where('slug', 'wheel-alignment')->first();
        $battery = Service::where('slug', 'battery-replacement')->first();
        $puncture = Service::where('slug', 'puncture-repair')->first();

        $c1 = Customer::where('phone', '+9647701234561')->first();
        $c2 = Customer::where('phone', '+9647701234562')->first();
        $c3 = Customer::where('phone', '+9647701234563')->first();
        $c4 = Customer::where('phone', '+9647701234564')->first();
        $c5 = Customer::where('phone', '+9647701234565')->first();
        $c6 = Customer::where('phone', '+9647701234566')->first();
        $c7 = Customer::where('phone', '+9647701234567')->first();

        // Link completed booking to a delivered order
        $deliveredOrder = Order::where('reference', 'ORD-20260420-0001')->first();
        $confirmedOrder = Order::where('reference', 'ORD-20260428-0002')->first();

        $bookings = [
            [
                'reference' => 'BK-20260410-0001',
                'customer' => $c1,
                'service' => $install,
                'order' => $deliveredOrder,
                'scheduled_at' => now()->subDays(20)->setTime(10, 0),
                'status' => 'completed',
                'customer_notes' => 'Please check tyre pressure after installation.',
                'admin_notes' => 'Done. All 4 tyres installed and balanced.',
            ],
            [
                'reference' => 'BK-20260428-0002',
                'customer' => $c2,
                'service' => $balance,
                'order' => $confirmedOrder,
                'scheduled_at' => now()->addDays(2)->setTime(9, 30),
                'status' => 'confirmed',
                'customer_notes' => null,
                'admin_notes' => null,
            ],
            [
                'reference' => 'BK-20260501-0003',
                'customer' => $c4,
                'service' => $alignment,
                'order' => null,
                'scheduled_at' => now()->addDays(1)->setTime(11, 0),
                'status' => 'pending',
                'customer_notes' => 'Car pulls to the right.',
                'admin_notes' => null,
            ],
            [
                'reference' => 'BK-20260430-0004',
                'customer' => $c3,
                'service' => $battery,
                'order' => null,
                'scheduled_at' => now()->subDays(1)->setTime(14, 0),
                'status' => 'completed',
                'customer_notes' => null,
                'admin_notes' => 'Battery replaced. Tested OK.',
            ],
            [
                'reference' => 'BK-20260501-0005',
                'customer' => $c5,
                'service' => $puncture,
                'order' => null,
                'scheduled_at' => now()->addHours(3),
                'status' => 'confirmed',
                'customer_notes' => 'Rear left tyre.',
                'admin_notes' => null,
            ],
            [
                'reference' => 'BK-20260502-0006',
                'customer' => $c6,
                'service' => $install,
                'order' => null,
                'scheduled_at' => now()->addDays(3)->setTime(8, 0),
                'status' => 'pending',
                'customer_notes' => null,
                'admin_notes' => null,
            ],
            [
                'reference' => 'BK-20260420-0007',
                'customer' => $c7,
                'service' => $alignment,
                'order' => null,
                'scheduled_at' => now()->subDays(11)->setTime(15, 0),
                'status' => 'no_show',
                'customer_notes' => null,
                'admin_notes' => 'Customer did not arrive.',
            ],
        ];

        foreach ($bookings as $data) {
            if (!$data['customer'] || !$data['service']) {
                continue;
            }

            Booking::updateOrCreate(
                ['reference' => $data['reference']],
                [
                    'customer_id' => $data['customer']->id,
                    'branch_id' => $branch->id,
                    'service_id' => $data['service']->id,
                    'order_id' => $data['order']?->id,
                    'scheduled_at' => $data['scheduled_at'],
                    'duration_minutes' => $data['service']->duration_minutes,
                    'status' => $data['status'],
                    'customer_notes' => $data['customer_notes'],
                    'admin_notes' => $data['admin_notes'],
                ]
            );
        }
    }
}
