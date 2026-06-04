<?php

namespace Database\Seeders;

use App\Models\Admin;
use Illuminate\Database\Seeder;

class AdminSeeder extends Seeder
{
    public function run(): void
    {
        $admin = Admin::updateOrCreate(
            ['email' => 'admin@iraqmaxtire.iq'],
            [
                'name' => 'Iraq Max Tire Admin',
                'phone' => '+9647700000000',
                'password' => 'password',
                'is_active' => true,
            ]
        );

        if (!$admin->hasRole('super-admin')) {
            $admin->assignRole('super-admin');
        }
    }
}
