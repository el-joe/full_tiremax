<?php

namespace Database\Seeders;

use App\Support\AdminPermissions;
use Illuminate\Database\Seeder;
use Spatie\Permission\Models\Permission;
use Spatie\Permission\Models\Role;
use Spatie\Permission\PermissionRegistrar;

class RolePermissionSeeder extends Seeder
{
    public function run(): void
    {
        app(PermissionRegistrar::class)->forgetCachedPermissions();

        foreach (AdminPermissions::all() as $p) {
            Permission::firstOrCreate(['name' => $p, 'guard_name' => 'admin']);
        }

        $role = fn (string $name) => Role::firstOrCreate(['name' => $name, 'guard_name' => 'admin']);
        $mod = fn (string ...$m) => collect($m)->flatMap(fn ($x) => AdminPermissions::forModule($x))->all();

        $role('super-admin')->syncPermissions(Permission::where('guard_name', 'admin')->get());

        $role('branch-manager')->syncPermissions(array_merge(
            ['dashboard.view', 'orders.view', 'orders.update', 'orders.change_status', 'bookings.view', 'bookings.update', 'bookings.change_status', 'customers.view'],
        ));

        $role('content-manager')->syncPermissions(array_merge(
            ['dashboard.view'],
            $mod('products', 'brands', 'categories', 'fitments', 'vehicles', 'offers', 'flash_sales'),
            ['reviews.view', 'reviews.moderate'],
        ));

        $role('support')->syncPermissions([
            'dashboard.view',
            'orders.view', 'orders.update', 'orders.change_status',
            'bookings.view', 'bookings.update', 'bookings.change_status',
            'customers.view', 'customers.update',
            'reviews.view', 'reviews.moderate',
        ]);

        app(PermissionRegistrar::class)->forgetCachedPermissions();
    }
}
