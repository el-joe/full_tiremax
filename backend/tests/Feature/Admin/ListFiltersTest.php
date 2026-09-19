<?php

namespace Tests\Feature\Admin;

use App\Livewire\Admin\Admins\AdminManager;
use App\Livewire\Admin\AuditLogs\AuditLogManager;
use App\Livewire\Admin\Bookings\BookingManager;
use App\Livewire\Admin\Branches\BranchManager;
use App\Livewire\Admin\Brands\BrandManager;
use App\Livewire\Admin\Categories\CategoryManager;
use App\Livewire\Admin\Customers\CustomerManager;
use App\Livewire\Admin\DaftraLogs\DaftraLogManager;
use App\Livewire\Admin\Fitments\FitmentManager;
use App\Livewire\Admin\FlashSales\FlashSaleManager;
use App\Livewire\Admin\Governorates\GovernorateManager;
use App\Livewire\Admin\Offers\OfferManager;
use App\Livewire\Admin\Orders\OrderManager;
use App\Livewire\Admin\Products\ProductManager;
use App\Livewire\Admin\Reviews\ReviewManager;
use App\Livewire\Admin\Roles\RoleManager;
use App\Livewire\Admin\Services\ServiceManager;
use App\Livewire\Admin\Vehicles\VehicleMakeManager;
use App\Livewire\Admin\Vehicles\VehicleManager;
use App\Livewire\Admin\Vehicles\VehicleModelManager;
use App\Livewire\Admin\WhatsappLogs\WhatsappLogManager;
use App\Models\Booking;
use App\Models\Branch;
use App\Models\Brand;
use App\Models\Category;
use App\Models\Customer;
use App\Models\DaftraSyncLog;
use App\Models\Fitment;
use App\Models\FlashSale;
use App\Models\Governorate;
use App\Models\Offer;
use App\Models\Order;
use App\Models\Product;
use App\Models\Review;
use App\Models\Service;
use App\Models\Vehicle;
use App\Models\VehicleMake;
use App\Models\VehicleModel;
use App\Models\WhatsappLog;
use App\Models\WhatsappTemplate;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Livewire\Livewire;
use Tests\TestCase;

class ListFiltersTest extends TestCase
{
    use RefreshDatabase, ActingAsAdmin;

    private function ids($component, string $var = 'items'): array
    {
        return $component->viewData($var)->pluck('id')->sort()->values()->all();
    }

    public static function lists(): array
    {
        return [
            [AdminManager::class, 'admins.view'], [AuditLogManager::class, 'audit_logs.view'],
            [BookingManager::class, 'bookings.view'], [BranchManager::class, 'branches.view'],
            [BrandManager::class, 'brands.view'], [CategoryManager::class, 'categories.view'],
            [CustomerManager::class, 'customers.view'], [DaftraLogManager::class, 'daftra_logs.view'],
            [FitmentManager::class, 'fitments.view'], [FlashSaleManager::class, 'flash_sales.view'],
            [GovernorateManager::class, 'governorates.view'], [OfferManager::class, 'offers.view'],
            [OrderManager::class, 'orders.view'], [ProductManager::class, 'products.view'],
            [ReviewManager::class, 'reviews.view'], [RoleManager::class, 'roles.view'],
            [ServiceManager::class, 'services.view'], [VehicleMakeManager::class, 'vehicles.view'],
            [VehicleManager::class, 'vehicles.view'], [VehicleModelManager::class, 'vehicles.view'],
            [WhatsappLogManager::class, 'whatsapp.view'],
        ];
    }

    #[\PHPUnit\Framework\Attributes\DataProvider('lists')]
    public function test_generic_behaviour(string $class, string $perm): void
    {
        $this->actingAsAdmin([$perm]);

        // invalid sort column / direction / perPage never break the query
        Livewire::test($class)
            ->set('sortBy', 'id; drop table users')->set('sortDir', 'sideways')->set('perPage', 7)
            ->assertOk();

        // sort() ignores non-whitelisted columns
        $c = Livewire::test($class)->call('sort', 'evil_column');
        $this->assertNotSame('evil_column', $c->get('sortBy'));

        // reset clears search and marks filters as inactive again
        $c = Livewire::test($class)->set('search', 'zzz');
        $this->assertTrue($c->instance()->hasActiveFilters());
        $c->call('resetFilters')->assertSet('search', '');
        $this->assertFalse($c->instance()->hasActiveFilters());
    }

    public function test_page_resets_on_filter_change_and_perpage(): void
    {
        $this->actingAsAdmin(['customers.view']);
        Customer::factory()->count(12)->create(['is_banned' => false]);
        Customer::factory()->create(['is_banned' => true]);

        Livewire::test(CustomerManager::class)->set('perPage', 10)
            ->call('gotoPage', 2)->assertSet('paginators.page', 2)
            ->set('statusFilter', 'banned')->assertSet('paginators.page', 1)
            ->call('gotoPage', 2)->set('search', 'x')->assertSet('paginators.page', 1)
            ->call('gotoPage', 2)->set('perPage', 50)->assertSet('paginators.page', 1);
    }

    public function test_customers_filters_and_grouped_search(): void
    {
        $this->actingAsAdmin(['customers.view']);
        $a = Customer::factory()->create(['name' => 'Alpha', 'phone' => '0711', 'is_banned' => true, 'locale' => 'ar', 'created_at' => '2026-01-10']);
        $b = Customer::factory()->create(['name' => 'Beta', 'phone' => '0722', 'is_active' => false, 'locale' => 'en', 'created_at' => '2026-03-10']);
        $c = Customer::factory()->create(['name' => 'Gamma', 'phone' => '0733', 'locale' => 'ar', 'created_at' => '2026-05-10']);
        Order::factory()->create(['customer_id' => $c->id]);

        $t = fn () => Livewire::test(CustomerManager::class);
        $this->assertSame([$a->id], $this->ids($t()->set('statusFilter', 'banned')));
        $this->assertSame([$b->id], $this->ids($t()->set('statusFilter', 'inactive')));
        $this->assertSame([$c->id], $this->ids($t()->set('hasOrders', 'yes')));
        $this->assertSame([$a->id, $b->id], $this->ids($t()->set('hasOrders', 'no')));
        $this->assertSame([$a->id, $c->id], $this->ids($t()->set('localeFilter', 'ar')));
        $this->assertSame([$b->id], $this->ids($t()->set('registeredFrom', '2026-02-01')->set('registeredTo', '2026-04-01')));
        // grouped OR: search combined with another filter must not leak
        $this->assertSame([$a->id], $this->ids($t()->set('search', '07')->set('statusFilter', 'banned')));
        $this->assertSame([$a->id, $c->id], $this->ids($t()->set('search', '07')->set('localeFilter', 'ar')));
        $sorted = $t()->set('sortBy', 'orders_count')->set('sortDir', 'desc')->viewData('items')->first();
        $this->assertSame($c->id, $sorted->id);
    }

    public function test_orders_filters(): void
    {
        $this->actingAsAdmin(['orders.view']);
        $branch = Branch::factory()->create();
        $gov = Governorate::create(['code' => 'BSR', 'is_basra' => true, 'ar' => ['name' => 'البصرة'], 'en' => ['name' => 'Basra']]);
        $o1 = Order::factory()->create(['status' => 'confirmed', 'type' => 'delivery', 'payment_method' => 'paymob', 'payment_status' => 'paid', 'branch_id' => $branch->id, 'governorate_id' => $gov->id, 'total' => 500, 'created_at' => '2026-02-01', 'customer_email' => 'find@me.com']);
        $o2 = Order::factory()->create(['total' => 100, 'created_at' => '2026-04-01']);
        $o3 = Order::factory()->create(['total' => 900]);

        $t = fn () => Livewire::test(OrderManager::class);
        $this->assertSame([$o1->id], $this->ids($t()->set('statusFilter', 'confirmed')));
        $this->assertSame([$o1->id], $this->ids($t()->set('typeFilter', 'delivery')));
        $this->assertSame([$o1->id], $this->ids($t()->set('paymentMethod', 'paymob')));
        $this->assertSame([$o1->id], $this->ids($t()->set('paymentStatus', 'paid')));
        $this->assertSame([$o1->id], $this->ids($t()->set('branchFilter', $branch->id)));
        $this->assertSame([$o1->id], $this->ids($t()->set('governorateFilter', $gov->id)));
        $g = Order::factory()->guest()->create(['customer_name' => 'Guesty McGuest', 'total' => 1]);
        $this->assertSame([$g->id], $this->ids($t()->set('customerKind', 'guest')));
        $this->assertSame([$o1->id, $o2->id, $o3->id], $this->ids($t()->set('customerKind', 'registered')));
        $this->assertSame([$g->id], $this->ids($t()->set('search', 'Guesty')));
        $this->assertSame([$o1->id], $this->ids($t()->set('from', '2026-01-01')->set('to', '2026-03-01')));
        $this->assertSame([$o1->id, $o3->id], $this->ids($t()->set('totalMin', '500')));
        $this->assertSame([$o1->id], $this->ids($t()->set('totalMin', '200')->set('totalMax', '600')));
        $this->assertSame([$o1->id], $this->ids($t()->set('search', 'find@me.com')));
    }

    public function test_bookings_filters_and_sorting(): void
    {
        $this->actingAsAdmin(['bookings.view']);
        $cust = Customer::factory()->create(['name' => 'Zed Person', 'phone' => '0799']);
        $svc = Service::factory()->create();
        $b1 = Booking::factory()->create(['customer_id' => $cust->id, 'service_id' => $svc->id, 'status' => Booking::STATUS_CONFIRMED, 'scheduled_at' => now()->setTime(10, 0)]);
        $b2 = Booking::factory()->create(['scheduled_at' => now()->addDay()->setTime(10, 0)]);
        $b3 = Booking::factory()->create(['scheduled_at' => now()->addDays(40)]);

        $t = fn () => Livewire::test(BookingManager::class);
        $this->assertSame([$b1->id], $this->ids($t()->set('statusFilter', 'confirmed')));
        $this->assertSame([$b1->id], $this->ids($t()->set('serviceFilter', $svc->id)));
        $this->assertSame([$b1->id], $this->ids($t()->set('branchFilter', $b1->branch_id)));
        $this->assertSame([$b1->id], $this->ids($t()->set('search', 'Zed')));
        $this->assertSame([$b1->id], $this->ids($t()->set('search', '0799')));
        $this->assertSame([$b1->id], $this->ids($t()->set('quick', 'today')));
        $this->assertSame([$b2->id], $this->ids($t()->set('quick', 'tomorrow')));
        $this->assertSame([$b3->id], $this->ids($t()->set('from', now()->addDays(30)->toDateString())));
        $bg = Booking::factory()->guest()->create(['customer_name' => 'Walkin Guest', 'customer_phone' => '07701234567', 'customer_email' => 'walk@in.com', 'scheduled_at' => now()->addDays(3)]);
        $this->assertSame([$b1->id, $b2->id, $b3->id], $this->ids($t()->set('customerKind', 'registered')));
        $this->assertSame([$bg->id], $this->ids($t()->set('customerKind', 'guest')));
        $this->assertSame([$bg->id], $this->ids($t()->set('search', 'Walkin')));
        $this->assertSame([$bg->id], $this->ids($t()->set('search', '07701234567')));
        $this->assertSame([$bg->id], $this->ids($t()->set('search', 'walk@in.com')));
        $this->assertSame([$b1->id], $this->ids($t()->set('search', 'Zed')));
        $b3 = $b3; // guest booking sits between b2 and b3 in time
        // default order: scheduled_at desc; sortBy honoured
        $this->assertSame([$b3->id, $bg->id, $b2->id, $b1->id], $t()->viewData('items')->pluck('id')->all());
        $this->assertSame([$b1->id, $b2->id, $bg->id, $b3->id], $t()->set('sortBy', 'scheduled_at')->set('sortDir', 'asc')->viewData('items')->pluck('id')->all());
    }

    public function test_products_filters(): void
    {
        $this->actingAsAdmin(['products.view']);
        $cat = Category::create(['slug' => 'c1', 'product_type' => 'tire', 'is_active' => true, 'ar' => ['name' => 'ف'], 'en' => ['name' => 'Cat']]);
        $p1 = Product::factory()->create(['sku' => 'AAA-1', 'category_id' => $cat->id, 'is_featured' => true, 'price' => 50, 'sale_price' => 40, 'stock' => 3]);
        $p2 = Product::factory()->battery()->outOfStock()->create(['sku' => 'BBB-2', 'is_active' => false, 'price' => 500]);
        $p3 = Product::factory()->create(['sku' => 'CCC-3', 'price' => 200, 'en' => ['name' => 'Unique Michelin']]);

        $t = fn () => Livewire::test(ProductManager::class);
        $this->assertSame([$p2->id], $this->ids($t()->set('type', 'battery')));
        $this->assertSame([$p1->id], $this->ids($t()->set('brandFilter', $p1->brand_id)));
        $this->assertSame([$p1->id], $this->ids($t()->set('categoryFilter', $cat->id)));
        $this->assertSame([$p2->id], $this->ids($t()->set('activeFilter', '0')));
        $this->assertSame([$p1->id], $this->ids($t()->set('featuredFilter', '1')));
        $this->assertSame([$p1->id], $this->ids($t()->set('stockFilter', 'low')));
        $this->assertSame([$p2->id], $this->ids($t()->set('stockFilter', 'out')));
        $this->assertSame([$p3->id], $this->ids($t()->set('stockFilter', 'in')));
        $this->assertSame([$p1->id], $this->ids($t()->set('onSale', '1')));
        $this->assertSame([$p3->id], $this->ids($t()->set('priceMin', '100')->set('priceMax', '300')));
        $this->assertSame([$p3->id], $this->ids($t()->set('search', 'Michelin')));
        $this->assertSame([$p2->id], $this->ids($t()->set('search', 'BBB')));
        $this->assertSame([], $this->ids($t()->set('search', 'Michelin')->set('type', 'battery')));
    }

    private function vehicle(string $make = 'Toyota', string $model = 'Corolla', int $year = 2015): array
    {
        $mk = VehicleMake::create(['slug' => strtolower($make).uniqid(), 'is_active' => true, 'ar' => ['name' => $make], 'en' => ['name' => $make]]);
        $md = VehicleModel::create(['vehicle_make_id' => $mk->id, 'slug' => strtolower($model).uniqid(), 'is_active' => true, 'ar' => ['name' => $model], 'en' => ['name' => $model]]);
        $v = Vehicle::create(['vehicle_model_id' => $md->id, 'year_from' => $year, 'year_to' => $year + 5, 'is_active' => true]);

        return [$mk, $md, $v];
    }

    public function test_vehicles_models_makes_and_fitments(): void
    {
        $this->actingAsAdmin(['vehicles.view', 'fitments.view']);
        [$mk1, $md1, $v1] = $this->vehicle('Toyota', 'Corolla', 2015);
        [$mk2, $md2, $v2] = $this->vehicle('Kia', 'Rio', 2000);
        $mk2->update(['is_active' => false]);
        $md2->update(['is_active' => false]);
        $v2->update(['is_active' => false]);

        $t = fn () => Livewire::test(VehicleManager::class);
        $this->assertSame([$v1->id], $this->ids($t()->set('makeId', $mk1->id)));
        $this->assertSame([$v2->id], $this->ids($t()->set('modelId', $md2->id)));
        $this->assertSame([$v1->id], $this->ids($t()->set('search', 'Coro')));
        $this->assertSame([$v2->id], $this->ids($t()->set('search', 'Kia')));
        $this->assertSame([$v1->id], $this->ids($t()->set('yearFilter', '2018')));
        $this->assertSame([$v2->id], $this->ids($t()->set('activeFilter', '0')));
        $t()->set('makeId', $mk1->id)->set('modelId', $md1->id)->set('makeId', $mk2->id)->assertSet('modelId', null);

        $t = fn () => Livewire::test(VehicleModelManager::class);
        $this->assertSame([$md1->id], $this->ids($t()->set('makeId', $mk1->id)));
        $this->assertSame([$md2->id], $this->ids($t()->set('activeFilter', '0')));
        $this->assertSame([$md2->id], $this->ids($t()->set('search', 'Rio')));

        $t = fn () => Livewire::test(VehicleMakeManager::class);
        $this->assertSame([$mk2->id], $this->ids($t()->set('activeFilter', '0')));
        $this->assertSame([$mk1->id], $this->ids($t()->set('search', 'Toy')));

        $p1 = Product::factory()->create(['sku' => 'FIT-1', 'en' => ['name' => 'Fit Tire']]);
        $p2 = Product::factory()->create(['sku' => 'FIT-2']);
        $f1 = Fitment::create(['vehicle_id' => $v1->id, 'product_id' => $p1->id]);
        $f2 = Fitment::create(['vehicle_id' => $v2->id, 'product_id' => $p2->id]);
        $t = fn () => Livewire::test(FitmentManager::class);
        $this->assertSame([$f1->id], $this->ids($t()->set('productFilter', $p1->id)));
        $this->assertSame([$f2->id], $this->ids($t()->set('search', 'FIT-2')));
        $this->assertSame([$f1->id], $this->ids($t()->set('search', 'Fit Tire')));
        $this->assertSame([$f1->id], $this->ids($t()->set('makeId', $mk1->id)));
        $t()->set('makeId', $mk1->id)->set('modelId', $md1->id)->set('vehicleId', $v1->id)->set('makeId', $mk2->id)
            ->assertSet('modelId', null)->assertSet('vehicleId', null);
        $t()->set('modelId', $md1->id)->set('vehicleId', $v1->id)->set('modelId', $md2->id)->assertSet('vehicleId', null);
    }

    public function test_reviews_filters(): void
    {
        $this->actingAsAdmin(['reviews.view']);
        $p = Product::factory()->create(['en' => ['name' => 'Reviewed Thing']]);
        $c = Customer::factory()->create();
        $mk = fn ($extra) => Review::create($extra + ['customer_id' => $c->id, 'product_id' => $p->id, 'type' => 'customer', 'rating' => 5, 'comment' => 'fine']);
        $r1 = $mk(['is_approved' => null, 'rating' => 4]);
        $r2 = $mk(['is_approved' => true, 'rating' => 3]);
        $r3 = $mk(['is_approved' => false, 'type' => 'expert']);

        $t = fn () => Livewire::test(ReviewManager::class);
        $this->assertSame([$r1->id], $this->ids($t(), 'reviews')); // default = pending
        $this->assertSame([$r1->id], $this->ids($t()->set('status', 'pending'), 'reviews'));
        $this->assertSame([$r3->id], $this->ids($t()->set('status', 'rejected'), 'reviews'));
        $this->assertSame([$r1->id, $r2->id, $r3->id], $this->ids($t()->set('status', 'all'), 'reviews'));
        $this->assertSame([$r2->id], $this->ids($t()->set('status', 'approved'), 'reviews'));
        $this->assertSame([$r2->id], $this->ids($t()->set('status', 'all')->set('rating', '3'), 'reviews'));
        $this->assertSame([$r3->id], $this->ids($t()->set('status', 'all')->set('typeFilter', 'expert'), 'reviews'));
        $this->assertSame([$r1->id, $r2->id, $r3->id], $this->ids($t()->set('status', 'all')->set('search', 'Reviewed'), 'reviews'));
        $this->assertSame([$r1->id, $r2->id, $r3->id], $this->ids($t()->set('status', 'all')->set('productFilter', $p->id), 'reviews'));
    }

    public function test_simple_active_and_status_filters(): void
    {
        $this->actingAsAdmin(['brands.view', 'categories.view', 'services.view', 'governorates.view', 'branches.view', 'offers.view', 'flash_sales.view']);

        $b1 = Brand::create(['slug' => 'a', 'is_active' => true, 'ar' => ['name' => 'أ'], 'en' => ['name' => 'Alpha']]);
        $b2 = Brand::create(['slug' => 'b', 'is_active' => false, 'ar' => ['name' => 'ب'], 'en' => ['name' => 'Beta']]);
        $t = fn () => Livewire::test(BrandManager::class);
        $this->assertSame([$b2->id], $this->ids($t()->set('activeFilter', '0'), 'brands'));
        $this->assertSame([$b1->id], $this->ids($t()->set('search', 'Alph'), 'brands'));
        $this->assertSame([], $this->ids($t()->set('search', 'Alph')->set('activeFilter', '0'), 'brands'));

        $c1 = Category::create(['slug' => 'c1', 'product_type' => 'tire', 'is_active' => true, 'ar' => ['name' => 'أ'], 'en' => ['name' => 'Cat A']]);
        $c2 = Category::create(['slug' => 'c2', 'product_type' => 'battery', 'is_active' => false, 'ar' => ['name' => 'ب'], 'en' => ['name' => 'Cat B']]);
        $t = fn () => Livewire::test(CategoryManager::class);
        $this->assertSame([$c2->id], $this->ids($t()->set('activeFilter', '0')));
        $this->assertSame([$c2->id], $this->ids($t()->set('typeFilter', 'battery')));

        $s1 = Service::factory()->create(['is_active' => true]);
        $s2 = Service::factory()->create(['is_active' => false]);
        $this->assertSame([$s2->id], $this->ids(Livewire::test(ServiceManager::class)->set('activeFilter', '0')));

        $g1 = Governorate::create(['code' => 'BSR', 'is_basra' => true, 'is_active' => true, 'ar' => ['name' => 'البصرة'], 'en' => ['name' => 'Basra']]);
        $g2 = Governorate::create(['code' => 'BGD', 'is_basra' => false, 'is_active' => false, 'ar' => ['name' => 'بغداد'], 'en' => ['name' => 'Baghdad']]);
        $t = fn () => Livewire::test(GovernorateManager::class);
        $this->assertSame([$g1->id], $this->ids($t()->set('basraFilter', '1')));
        $this->assertSame([$g2->id], $this->ids($t()->set('activeFilter', '0')));
        $this->assertSame([$g2->id], $this->ids($t()->set('search', 'Baghdad')));

        $br1 = Branch::factory()->create(['is_active' => true, 'code' => 'AAA', 'phone' => '0770']);
        $br2 = Branch::factory()->create(['is_active' => false, 'code' => 'BBB', 'phone' => '0780']);
        $t = fn () => Livewire::test(BranchManager::class);
        $this->assertSame([$br2->id], $this->ids($t()->set('activeFilter', '0')));
        $this->assertSame([$br1->id], $this->ids($t()->set('search', '0770')));
        $this->assertSame([$br1->id], $this->ids($t()->set('search', $br1->translate('en')->name ?? 'AAA')));

        $mkOffer = fn ($code, $extra) => Offer::create($extra + ['code' => $code, 'discount_type' => 'percent', 'discount_value' => 10, 'is_active' => true, 'ar' => ['title' => 'x'], 'en' => ['title' => 'x']]);
        $live = $mkOffer('LIVE', ['starts_at' => now()->subDay(), 'ends_at' => now()->addDay()]);
        $up = $mkOffer('UP', ['starts_at' => now()->addDay(), 'ends_at' => now()->addDays(5), 'discount_type' => 'fixed']);
        $exp = $mkOffer('EXP', ['starts_at' => now()->subDays(5), 'ends_at' => now()->subDay(), 'is_active' => false]);
        $t = fn () => Livewire::test(OfferManager::class);
        $this->assertSame([$live->id], $this->ids($t()->set('statusFilter', 'live')));
        $this->assertSame([$up->id], $this->ids($t()->set('statusFilter', 'upcoming')));
        $this->assertSame([$exp->id], $this->ids($t()->set('statusFilter', 'expired')));
        $this->assertSame([$up->id], $this->ids($t()->set('typeFilter', 'fixed')));
        $this->assertSame([$exp->id], $this->ids($t()->set('activeFilter', '0')));

        $fs = fn ($extra) => FlashSale::create($extra + ['title' => 'S', 'discount_percent' => 10, 'is_active' => true]);
        $l = $fs(['starts_at' => now()->subDay(), 'ends_at' => now()->addDay()]);
        $u = $fs(['starts_at' => now()->addDay(), 'ends_at' => now()->addDays(2), 'is_active' => false]);
        $e = $fs(['starts_at' => now()->subDays(3), 'ends_at' => now()->subDay()]);
        $t = fn () => Livewire::test(FlashSaleManager::class);
        $this->assertSame([$l->id], $this->ids($t()->set('statusFilter', 'live')));
        $this->assertSame([$u->id], $this->ids($t()->set('statusFilter', 'upcoming')));
        $this->assertSame([$e->id], $this->ids($t()->set('statusFilter', 'ended')));
        $this->assertSame([$u->id], $this->ids($t()->set('activeFilter', '0')));
    }

    public function test_daftra_and_whatsapp_logs(): void
    {
        $this->actingAsAdmin(['daftra_logs.view', 'whatsapp.view']);
        $d1 = DaftraSyncLog::create(['syncable_type' => Product::class, 'syncable_id' => 77, 'action' => 'create_invoice', 'status' => 'failed']);
        $d2 = DaftraSyncLog::create(['syncable_type' => Order::class, 'syncable_id' => 5, 'action' => 'update_status', 'status' => 'success']);
        DaftraSyncLog::whereKey($d2->id)->update(['created_at' => '2026-01-01']);
        $t = fn () => Livewire::test(DaftraLogManager::class);
        $this->assertSame([$d1->id], $this->ids($t()->set('statusFilter', 'failed')));
        $this->assertSame([$d2->id], $this->ids($t()->set('entityTypeFilter', Order::class)));
        $this->assertSame([$d2->id], $this->ids($t()->set('actionFilter', 'update_status')));
        $this->assertSame([$d2->id], $this->ids($t()->set('from', '2025-12-31')->set('to', '2026-01-02')));
        $this->assertSame([$d1->id], $this->ids($t()->set('search', '77')));

        $tpl = WhatsappTemplate::create(['key' => 'order_confirmed', 'is_active' => true]);
        $cust = Customer::factory()->create(['name' => 'Wanda']);
        $w1 = WhatsappLog::create(['customer_id' => $cust->id, 'whatsapp_template_id' => $tpl->id, 'phone' => '07001', 'status' => 'sent', 'body' => 'hi']);
        $w2 = WhatsappLog::create(['phone' => '07002', 'status' => 'failed', 'body' => 'yo']);
        WhatsappLog::whereKey($w2->id)->update(['created_at' => '2026-01-01']);
        $t = fn () => Livewire::test(WhatsappLogManager::class);
        $this->assertSame([$w2->id], $this->ids($t()->set('statusFilter', 'failed')));
        $this->assertSame([$w1->id], $this->ids($t()->set('templateFilter', $tpl->id)));
        $this->assertSame([$w2->id], $this->ids($t()->set('search', '07002')));
        $this->assertSame([$w1->id], $this->ids($t()->set('search', 'Wanda')));
        $this->assertSame([$w2->id], $this->ids($t()->set('from', '2025-12-31')->set('to', '2026-01-02')));
    }

    public function test_whatsapp_logs_route_gated(): void
    {
        $this->actingAsAdmin([]);
        $this->get(route('admin.whatsapp-logs.index'))->assertForbidden();
        $this->actingAsAdmin(['whatsapp.view']);
        $this->get(route('admin.whatsapp-logs.index'))->assertOk();
    }
}
