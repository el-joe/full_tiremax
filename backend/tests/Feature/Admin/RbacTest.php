<?php

namespace Tests\Feature\Admin;

use App\Livewire\Admin\Brands\BrandManager;
use App\Livewire\Admin\Customers\CustomerManager;
use App\Livewire\Admin\Orders\OrderManager;
use App\Livewire\Admin\Reviews\ReviewManager;
use App\Models\Admin;
use App\Models\Brand;
use App\Models\Customer;
use App\Models\Order;
use App\Models\Product;
use App\Support\AdminPermissions;
use Database\Seeders\RolePermissionSeeder;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Route;
use Livewire\Livewire;
use Spatie\Permission\Models\Permission;
use Spatie\Permission\PermissionRegistrar;
use Tests\TestCase;

class RbacTest extends TestCase
{
    use RefreshDatabase, ActingAsAdmin;

    /** route name => permission */
    public static function routes(): array
    {
        return [
            'admin.dashboard' => 'dashboard.view',
            'admin.dashboard.index' => 'dashboard.view',
            'admin.brands.index' => 'brands.view',
            'admin.categories.index' => 'categories.view',
            'admin.branches.index' => 'branches.view',
            'admin.governorates.index' => 'governorates.view',
            'admin.services.index' => 'services.view',
            'admin.vehicle-makes.index' => 'vehicles.view',
            'admin.vehicle-models.index' => 'vehicles.view',
            'admin.vehicles.index' => 'vehicles.view',
            'admin.products.index' => 'products.view',
            'admin.products.create' => 'products.create',
            'admin.fitments.index' => 'fitments.view',
            'admin.orders.index' => 'orders.view',
            'admin.bookings.index' => 'bookings.view',
            'admin.customers.index' => 'customers.view',
            'admin.offers.index' => 'offers.view',
            'admin.flash-sales.index' => 'flash_sales.view',
            'admin.reviews.index' => 'reviews.view',
            'admin.daftra-logs.index' => 'daftra_logs.view',
            'admin.payment-gateways.index' => 'payment_gateways.view',
            'admin.settings.index' => 'settings.view',
            'admin.whatsapp-templates.index' => 'whatsapp.view',
            'admin.admins.index' => 'admins.view',
            'admin.roles.index' => 'roles.view',
            'admin.audit-logs.index' => 'audit_logs.view',
        ];
    }

    public function test_routes_forbidden_without_permission_and_ok_with(): void
    {
        foreach (self::routes() as $name => $perm) {
            $this->actingAsAdmin([]);
            $this->get(route($name))->assertForbidden();
        }
        foreach (self::routes() as $name => $perm) {
            $this->actingAsAdmin([$perm]);
            $this->get(route($name))->assertOk();
        }
    }

    public function test_product_edit_requires_update(): void
    {
        $product = Product::factory()->create();
        $this->actingAsAdmin(['products.view', 'products.create']);
        $this->get(route('admin.products.edit', $product->id))->assertForbidden();
        $this->actingAsAdmin(['products.update']);
        $this->get(route('admin.products.edit', $product->id))->assertOk();
    }

    public function test_super_admin_passes_everything(): void
    {
        $this->seed(RolePermissionSeeder::class);
        $admin = Admin::factory()->create();
        $admin->assignRole('super-admin');
        $this->actingAs($admin, 'admin');
        foreach (self::routes() as $name => $perm) {
            $this->get(route($name))->assertOk();
        }
        $this->assertTrue($admin->can('anything.at_all'));
    }

    public function test_seeded_roles_are_subsets_of_catalogue(): void
    {
        $this->seed(RolePermissionSeeder::class);
        $this->assertSame(count(AdminPermissions::all()), Permission::where('guard_name', 'admin')->count());
        $admin = Admin::factory()->create();
        $admin->assignRole('support');
        $this->assertTrue($admin->can('orders.change_status'));
        $this->assertFalse($admin->can('products.create'));
    }

    public function test_livewire_mutations_forbidden_without_permission(): void
    {
        $brand = Brand::create(['slug' => 'b-'.uniqid(), 'is_active' => true, 'ar' => ['name' => 'ب'], 'en' => ['name' => 'B']]);
        $customer = Customer::factory()->create();
        $order = Order::factory()->create();

        $this->actingAsAdmin(['brands.view', 'customers.view', 'orders.view', 'reviews.view']);

        Livewire::test(BrandManager::class)->call('delete', $brand->id)->assertForbidden();
        Livewire::test(BrandManager::class)->call('openCreate')->assertForbidden();
        Livewire::test(BrandManager::class)->call('save')->assertForbidden();
        Livewire::test(CustomerManager::class)->call('toggleBanned', $customer->id)->assertForbidden();
        Livewire::test(CustomerManager::class)->call('toggleActive', $customer->id)->assertForbidden();
        Livewire::test(CustomerManager::class)->call('delete', $customer->id)->assertForbidden();
        Livewire::test(OrderManager::class)->call('changeStatus', $order->id, 'confirmed')->assertForbidden();
        Livewire::test(OrderManager::class)->call('delete', $order->id)->assertForbidden();
        Livewire::test(ReviewManager::class)->call('approve', 1)->assertForbidden();

        $this->assertDatabaseHas('brands', ['id' => $brand->id]);
        $this->assertDatabaseHas('customers', ['id' => $customer->id]);
    }

    public function test_livewire_mutation_allowed_with_permission(): void
    {
        $brand = Brand::create(['slug' => 'b-'.uniqid(), 'is_active' => true, 'ar' => ['name' => 'ب'], 'en' => ['name' => 'B']]);
        $this->actingAsAdmin(['brands.view', 'brands.delete']);
        Livewire::test(BrandManager::class)->call('delete', $brand->id)->assertOk();
        $this->assertSoftDeleted('brands', ['id' => $brand->id]);
    }

    public function test_inactive_admin_cannot_login(): void
    {
        Admin::factory()->create(['email' => 'off@x.test', 'password' => 'secret123', 'is_active' => false]);
        Livewire::test(\App\Livewire\Admin\Auth\Login::class)
            ->set('email', 'off@x.test')->set('password', 'secret123')
            ->call('submit')
            ->assertHasErrors('email');
        $this->assertGuest('admin');
    }

    public function test_admin_deactivated_mid_session_is_logged_out(): void
    {
        $admin = $this->actingAsAdmin(['dashboard.view']);
        $admin->update(['is_active' => false]);
        $this->get(route('admin.dashboard'))->assertRedirect(route('admin.login'));
        $this->assertGuest('admin');
    }

    public function test_every_admin_route_has_a_can_middleware(): void
    {
        $exempt = ['admin.login', 'admin.logout', 'admin.locale.switch'];
        foreach (Route::getRoutes() as $route) {
            $name = $route->getName();
            if (!$name || !str_starts_with($name, 'admin.') || in_array($name, $exempt, true)) {
                continue;
            }
            $has = collect($route->gatherMiddleware())->contains(
                fn ($m) => is_string($m) && (str_starts_with($m, 'can:') || str_starts_with($m, 'permission:'))
            );
            $this->assertTrue($has, "Route [$name] has no can:/permission: middleware");
        }
    }

    public function test_migration_converts_manage_permissions(): void
    {
        $old = Permission::create(['name' => 'manage_orders', 'guard_name' => 'admin']);
        $role = \Spatie\Permission\Models\Role::create(['name' => 'legacy', 'guard_name' => 'admin']);
        $role->givePermissionTo($old);

        $migration = require database_path('migrations/2026_09_19_100000_migrate_manage_permissions_to_granular.php');
        $migration->up();
        app(PermissionRegistrar::class)->forgetCachedPermissions();

        $this->assertDatabaseMissing('permissions', ['name' => 'manage_orders']);
        $role = $role->fresh();
        foreach (AdminPermissions::forModule('orders') as $p) {
            $this->assertTrue($role->hasPermissionTo($p, 'admin'), $p);
        }
        $this->assertFalse($role->hasPermissionTo('products.view', 'admin'));
    }
}
