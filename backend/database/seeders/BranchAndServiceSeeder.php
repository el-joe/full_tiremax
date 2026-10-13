<?php

namespace Database\Seeders;

use App\Models\Branch;
use App\Models\Service;
use Illuminate\Database\Seeder;
use Illuminate\Support\Str;

class BranchAndServiceSeeder extends Seeder
{
    public function run(): void
    {
        $branch = Branch::updateOrCreate(
            ['code' => 'BAS-MAIN'],
            [
                'phone' => '+9647700000001',
                'email' => 'basra@iraqmaxtire.iq',
                'is_main' => true,
                'is_active' => true,
                'default_capacity' => 3,
                'auto_confirm_bookings' => false,
                'latitude' => 30.5081,
                'longitude' => 47.7804,
            ]
        );
        $branch->translateOrNew('ar')->fill(['name' => 'فرع البصرة الرئيسي', 'address' => 'البصرة - شارع الكورنيش']);
        $branch->translateOrNew('en')->fill(['name' => 'Basra Main Branch', 'address' => 'Basra - Corniche St.']);
        $branch->save();

        // weekly working hours (Friday closed) - what the reservation calendar offers
        foreach (range(0, 6) as $dow) {
            \App\Models\BranchSchedule::updateOrCreate(
                ['branch_id' => $branch->id, 'day_of_week' => $dow],
                [
                    'opens_at' => $dow === 5 ? null : '09:00',
                    'closes_at' => $dow === 5 ? null : '18:00',
                    'capacity' => $branch->default_capacity,
                    'is_closed' => $dow === 5,
                ]
            );
        }

        $services = [
            ['en' => 'Tire Installation', 'ar' => 'تركيب الإطارات', 'duration' => 30, 'price' => 5000],
            ['en' => 'Wheel Balancing', 'ar' => 'موازنة العجلات', 'duration' => 30, 'price' => 7000],
            ['en' => 'Wheel Alignment', 'ar' => 'ضبط زوايا العجلات', 'duration' => 45, 'price' => 15000],
            ['en' => 'Battery Replacement', 'ar' => 'تبديل البطارية', 'duration' => 20, 'price' => 5000],
            ['en' => 'Tire Rotation', 'ar' => 'دوران الإطارات', 'duration' => 30, 'price' => 5000],
            ['en' => 'Puncture Repair', 'ar' => 'تصليح الإطار', 'duration' => 25, 'price' => 3000],
        ];

        foreach ($services as $i => $s) {
            $svc = Service::updateOrCreate(
                ['slug' => Str::slug($s['en'])],
                ['duration_minutes' => $s['duration'], 'price' => $s['price'], 'is_active' => true, 'sort_order' => $i]
            );
            $svc->translateOrNew('en')->name = $s['en'];
            $svc->translateOrNew('ar')->name = $s['ar'];
            $svc->save();
        }
    }
}
