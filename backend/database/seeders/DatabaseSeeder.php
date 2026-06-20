<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;

class DatabaseSeeder extends Seeder
{
    public function run(): void
    {
        $this->call([
                // ── Foundation ────────────────────────────────────────────────
            RolePermissionSeeder::class,
            AdminSeeder::class,
            GovernorateSeeder::class,
            CitySeeder::class,
            BrandSeeder::class,
            CategorySeeder::class,
            BranchAndServiceSeeder::class,

                // ── Catalogue ─────────────────────────────────────────────────
            VehicleSeeder::class,
            ProductSeeder::class,
            FitmentSeeder::class,

                // ── Commerce ──────────────────────────────────────────────────
            CustomerSeeder::class,
            OfferSeeder::class,
            OrderSeeder::class,
            BookingSeeder::class,

                // ── Config ────────────────────────────────────────────────────
            WhatsappTemplateSeeder::class,
            SettingSeeder::class,
        ]);
    }
}
