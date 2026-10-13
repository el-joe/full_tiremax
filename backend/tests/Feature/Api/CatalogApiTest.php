<?php

namespace Tests\Feature\Api;

use App\Models\Branch;
use App\Models\BranchSchedule;
use App\Models\Brand;
use App\Models\City;
use App\Models\Fitment;
use App\Models\FlashSale;
use App\Models\Governorate;
use App\Models\Product;
use App\Models\Service;
use App\Models\Vehicle;
use App\Models\VehicleMake;
use App\Models\VehicleModel;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Tests\TestCase;

class CatalogApiTest extends TestCase
{
    use RefreshDatabase, ApiTestHelpers;

    private function vehicle(): array
    {
        $make = VehicleMake::create(['slug' => 'toyota', 'is_active' => true, 'ar' => ['name' => 'تويوتا'], 'en' => ['name' => 'Toyota']]);
        $model = VehicleModel::create(['vehicle_make_id' => $make->id, 'slug' => 'camry', 'is_active' => true, 'ar' => ['name' => 'كامري'], 'en' => ['name' => 'Camry']]);
        $vehicle = Vehicle::create(['vehicle_model_id' => $model->id, 'year_from' => 2018, 'year_to' => 2022, 'is_active' => true]);
        return [$make, $model, $vehicle];
    }

    public function test_home_has_expected_sections(): void
    {
        Product::factory()->create();
        $this->getJson('/api/v1/home')->assertOk()
            ->assertJsonStructure(['success', 'data' => ['featured', 'best_sellers', 'new_arrivals', 'offers', 'brands', 'governorates']]);
    }

    public function test_brands_branches_governorates_cities_services(): void
    {
        Brand::create(['slug' => 'b1', 'is_active' => true]);
        Branch::factory()->create();
        $g = Governorate::create(['code' => 'BSR', 'is_basra' => true, 'is_active' => true, 'ar' => ['name' => 'البصرة'], 'en' => ['name' => 'Basra']]);
        City::create(['governorate_id' => $g->id, 'name_ar' => 'الزبير', 'name_en' => 'Zubair', 'is_active' => true]);
        Service::factory()->create();

        $this->getJson('/api/v1/brands')->assertOk()->assertJsonStructure(['data' => [['id']]]);
        $this->getJson('/api/v1/branches')->assertOk()->assertJsonStructure(['data' => [['id', 'name']]]);
        $this->getJson('/api/v1/governorates')->assertOk()->assertJsonStructure(['data' => [['id', 'name']]]);
        $this->getJson("/api/v1/governorates/{$g->id}/cities")->assertOk()->assertJsonCount(1, 'data')->assertJsonStructure(['data' => [['id', 'name_ar', 'name_en']]]);
        $this->getJson('/api/v1/governorates/99999/cities')->assertOk()->assertJsonCount(0, 'data');
        $this->getJson('/api/v1/services')->assertOk()->assertJsonStructure(['data' => [['id', 'name', 'duration_minutes', 'price']]]);
    }

    public function test_flash_sales_and_their_products(): void
    {
        $sale = FlashSale::create(['title' => 'Sale', 'discount_percent' => 10, 'starts_at' => now()->subHour(), 'ends_at' => now()->addDay(), 'is_active' => true]);
        $this->getJson('/api/v1/flash-sales')->assertOk()->assertJsonStructure(['success', 'data']);
        $this->getJson("/api/v1/flash-sales/{$sale->id}/products")->assertOk()->assertJsonStructure(['success', 'data']);
        $this->getJson('/api/v1/flash-sales/99999/products')->assertNotFound();
    }

    public function test_vehicle_selector_chain_and_vehicle_show(): void
    {
        [$make, $model, $vehicle] = $this->vehicle();

        $this->getJson('/api/v1/vehicles/makes')->assertOk()->assertJsonPath('data.0.id', $make->id);
        $this->getJson("/api/v1/vehicles/makes/{$make->id}/models")->assertOk()->assertJsonPath('data.0.id', $model->id);
        $this->getJson("/api/v1/vehicles/models/{$model->id}/years")->assertOk()->assertJsonStructure(['success', 'data']);
        $this->getJson('/api/v1/vehicles')->assertOk()->assertJsonStructure(['success', 'data']);
        $this->getJson("/api/v1/vehicles/{$vehicle->id}")->assertOk()->assertJsonPath('data.id', $vehicle->id);
        $this->getJson('/api/v1/vehicles/99999')->assertNotFound();
        $this->getJson('/api/v1/vehicles/makes/99999/models')->assertNotFound();
    }

    public function test_products_list_show_related_and_404(): void
    {
        $brand = Brand::create(['slug' => 'bx', 'is_active' => true]);
        $p = Product::factory()->create(['brand_id' => $brand->id]);
        Product::factory()->create(['brand_id' => $brand->id]);

        $this->getJson('/api/v1/products')->assertOk()
            ->assertJsonStructure(['data' => [['id', 'sku', 'name', 'price', 'effective_price', 'in_stock', 'has_discount']], 'meta' => ['pagination']]);
        $this->getJson("/api/v1/products/{$p->id}")->assertOk()->assertJsonPath('data.id', $p->id);
        $this->getJson("/api/v1/products/{$p->id}/related")->assertOk()->assertJsonStructure(['success', 'data']);
        $this->getJson('/api/v1/products/99999')->assertNotFound();
        $this->getJson('/api/v1/products/99999/related')->assertNotFound();
    }

    public function test_fitments_sizes_by_vehicle_by_size(): void
    {
        [, , $vehicle] = $this->vehicle();
        $p = Product::factory()->create(['type' => 'tire']);
        $p->tireSpec()->create(['width' => 205, 'aspect_ratio' => 55, 'rim_diameter' => 16]);
        Fitment::create(['vehicle_id' => $vehicle->id, 'product_id' => $p->id]);

        $this->getJson('/api/v1/fitments/sizes')->assertOk()->assertJsonStructure(['success', 'data']);
        $this->getJson("/api/v1/fitments/by-vehicle/{$vehicle->id}")->assertOk()->assertJsonStructure(['success', 'data']);
        $this->getJson('/api/v1/fitments/by-vehicle/99999')->assertNotFound();
        $this->getJson('/api/v1/fitments/by-size?width=205&aspect_ratio=55&rim_diameter=16')->assertOk()->assertJsonPath('data.0.id', $p->id);
        $this->getJson('/api/v1/fitments/by-size')->assertStatus(422);
    }

    public function test_reviews_index_is_public_and_post_requires_auth(): void
    {
        $p = Product::factory()->create();
        $this->getJson("/api/v1/reviews/{$p->id}")->assertOk()->assertJsonStructure(['success', 'data']);
        $this->postJson("/api/v1/reviews/{$p->id}", ['rating' => 5])->assertStatus(401);
    }

    public function test_booking_slots(): void
    {
        $branch = Branch::factory()->create();
        $date = now()->addDays(3);
        BranchSchedule::create(['branch_id' => $branch->id, 'day_of_week' => $date->dayOfWeek, 'opens_at' => '09:00', 'closes_at' => '12:00', 'is_closed' => false]);

        $this->getJson("/api/v1/bookings/branch/{$branch->id}/slots?date=" . $date->toDateString())->assertOk()->assertJsonStructure(['success', 'data']);
        $this->getJson("/api/v1/bookings/branch/{$branch->id}/slots")->assertStatus(422);
        $this->getJson('/api/v1/bookings/branch/99999/slots?date=' . $date->toDateString())->assertNotFound();
    }
}
