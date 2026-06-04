<?php

namespace Database\Seeders;

use App\Models\Customer;
use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\Hash;

class CustomerSeeder extends Seeder
{
    public function run(): void
    {
        $customers = [
            [
                'name' => 'أحمد حسن',
                'email' => 'ahmed.hassan@email.com',
                'phone' => '+9647701234561',
                'address' => 'بغداد - شارع المتنبي',
                'locale' => 'ar',
            ],
            [
                'name' => 'Mohammed Ali',
                'email' => 'mohammed.ali@email.com',
                'phone' => '+9647701234562',
                'address' => 'Basra - Corniche St.',
                'locale' => 'en',
            ],
            [
                'name' => 'فاطمة إبراهيم',
                'email' => 'fatima.ibrahim@email.com',
                'phone' => '+9647701234563',
                'address' => 'النجف - حي الحنانة',
                'locale' => 'ar',
            ],
            [
                'name' => 'علي كريم',
                'email' => 'ali.kareem@email.com',
                'phone' => '+9647701234564',
                'address' => 'البصرة - شارع أبي الخصيب',
                'locale' => 'ar',
            ],
            [
                'name' => 'Sara Ahmed',
                'email' => 'sara.ahmed@email.com',
                'phone' => '+9647701234565',
                'address' => 'Baghdad - Mansour District',
                'locale' => 'en',
            ],
            [
                'name' => 'حسين جاسم',
                'email' => 'hussein.jasim@email.com',
                'phone' => '+9647701234566',
                'address' => 'كربلاء - شارع الإمام',
                'locale' => 'ar',
            ],
            [
                'name' => 'Zainab Khalid',
                'email' => 'zainab.khalid@email.com',
                'phone' => '+9647701234567',
                'address' => 'Basra - Al-Ashar District',
                'locale' => 'en',
            ],
        ];

        foreach ($customers as $data) {
            Customer::updateOrCreate(
                ['phone' => $data['phone']],
                [
                    'name' => $data['name'],
                    'email' => $data['email'],
                    'password' => Hash::make('password'),
                    'address' => $data['address'],
                    'locale' => $data['locale'],
                    'is_active' => true,
                    'phone_verified_at' => now(),
                ]
            );
        }
    }
}
