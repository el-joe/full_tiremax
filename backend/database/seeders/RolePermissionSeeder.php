<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use Spatie\Permission\Models\Permission;
use Spatie\Permission\Models\Role;

class RolePermissionSeeder extends Seeder
{
    public function run(): void
    {
        app()[\Spatie\Permission\PermissionRegistrar::class]->forgetCachedPermissions();

        $permissions = [
            'manage_dashboard',
            'manage_brands',
            'manage_categories',
            'manage_governorates',
            'manage_branches',
            'manage_services',
            'manage_vehicles',
            'manage_products',
            'manage_fitments',
            'manage_orders',
            'manage_bookings',
            'manage_customers',
            'manage_offers',
            'manage_settings',
            'manage_admins',
        ];

        foreach ($permissions as $p) {
            Permission::firstOrCreate(['name' => $p, 'guard_name' => 'admin']);
        }

        $superAdmin = Role::firstOrCreate(['name' => 'super-admin', 'guard_name' => 'admin']);
        $superAdmin->syncPermissions(Permission::where('guard_name', 'admin')->get());

        Role::firstOrCreate(['name' => 'branch-manager', 'guard_name' => 'admin'])
            ->syncPermissions(['manage_dashboard', 'manage_orders', 'manage_bookings', 'manage_customers']);

        Role::firstOrCreate(['name' => 'content-manager', 'guard_name' => 'admin'])
            ->syncPermissions(['manage_dashboard', 'manage_brands', 'manage_categories', 'manage_products', 'manage_fitments', 'manage_vehicles', 'manage_offers']);

        Role::firstOrCreate(['name' => 'support', 'guard_name' => 'admin'])
            ->syncPermissions(['manage_dashboard', 'manage_orders', 'manage_bookings', 'manage_customers']);
    }
}
