<?php

namespace Tests\Feature;

use App\Models\Branch;
use App\Models\Customer;
use App\Models\Offer;
use App\Models\Order;
use App\Models\PaymentGateway;
use App\Models\Product;
use App\Models\ProductBadge;
use App\Models\Review;
use App\Support\NotificationPresenter;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Tests\TestCase;

class StorefrontFlowsTest extends TestCase
{
    use RefreshDatabase;

    private function auth(Customer $c): array
    {
        return ['Authorization' => 'Bearer ' . auth('api')->login($c), 'Accept' => 'application/json'];
    }

    private function deliveredOrderWith(Customer $c, Product $p, string $status = Order::STATUS_DELIVERED): Order
    {
        $order = Order::factory()->create(['customer_id' => $c->id, 'status' => $status]);
        $order->items()->create(['product_id' => $p->id, 'product_name' => 'P', 'product_sku' => 'S', 'quantity' => 1, 'unit_price' => 10, 'total' => 10]);
        return $order;
    }

    public function test_adding_the_same_product_twice_increments_quantity_and_respects_stock(): void
    {
        $c = Customer::factory()->create();
        $p = Product::factory()->create(['stock' => 3]);

        $this->postJson('/api/v1/cart/items', ['product_id' => $p->id, 'quantity' => 1], $this->auth($c))->assertSuccessful();
        $this->postJson('/api/v1/cart/items', ['product_id' => $p->id, 'quantity' => 1], $this->auth($c))
            ->assertSuccessful()->assertJsonPath('data.items.0.quantity', 2);

        // 2 in cart + 2 more would exceed the stock of 3
        $this->postJson('/api/v1/cart/items', ['product_id' => $p->id, 'quantity' => 2], $this->auth($c))->assertStatus(400);
    }

    public function test_review_requires_a_delivered_order_of_the_customer_and_only_once(): void
    {
        $c = Customer::factory()->create();
        $p = Product::factory()->create();
        $pending = $this->deliveredOrderWith($c, $p, Order::STATUS_PENDING);
        $delivered = $this->deliveredOrderWith($c, $p);
        $foreign = $this->deliveredOrderWith(Customer::factory()->create(), $p);

        $url = "/api/v1/reviews/{$p->id}";
        $this->postJson($url, ['rating' => 5], $this->auth($c))->assertStatus(422); // order_id required
        $this->postJson($url, ['rating' => 5, 'order_id' => $pending->id], $this->auth($c))->assertStatus(400);
        $this->postJson($url, ['rating' => 5, 'order_id' => $foreign->id], $this->auth($c))->assertStatus(403);
        $this->postJson($url, ['rating' => 5, 'order_id' => $delivered->id], $this->auth($c))->assertCreated();
        $this->postJson($url, ['rating' => 4, 'order_id' => $delivered->id], $this->auth($c))->assertStatus(400);

        $this->assertSame($delivered->id, Review::first()->order_id);
        $this->getJson("/api/v1/orders/{$delivered->id}", $this->auth($c))
            ->assertJsonPath('data.items.0.reviewed', true);
    }

    public function test_orders_can_be_filtered_by_status_group(): void
    {
        $c = Customer::factory()->create();
        Order::factory()->create(['customer_id' => $c->id, 'status' => Order::STATUS_PENDING]);
        Order::factory()->create(['customer_id' => $c->id, 'status' => Order::STATUS_PROCESSING]);
        Order::factory()->create(['customer_id' => $c->id, 'status' => Order::STATUS_SHIPPED]);
        Order::factory()->create(['customer_id' => $c->id, 'status' => Order::STATUS_COMPLETED]);

        $count = fn (string $status) => count($this->getJson("/api/v1/orders?status=$status", $this->auth($c))->json('data'));
        $this->assertSame(2, $count('processing'));
        $this->assertSame(1, $count('on_the_way'));
        $this->assertSame(1, $count('delivered'));
        $this->assertSame(0, $count('cancelled'));
        $this->assertSame(4, count($this->getJson('/api/v1/orders', $this->auth($c))->json('data')));
    }

    public function test_checkout_with_coupon_increments_used_count_and_cancel_releases_it(): void
    {
        PaymentGateway::create(['name' => 'cod', 'display_name' => 'COD', 'driver' => 'cod', 'is_active' => true, 'settings' => [], 'credentials' => []]);
        $c = Customer::factory()->create();
        $p = Product::factory()->create(['stock' => 10, 'price' => 1000, 'sale_price' => null]);
        $offer = Offer::create(['code' => 'TEN', 'discount_type' => 'percent', 'discount_value' => 10, 'min_subtotal' => 0, 'usage_limit' => 1, 'is_active' => true]);
        $branch = Branch::factory()->create();

        $this->postJson('/api/v1/cart/items', ['product_id' => $p->id, 'quantity' => 2], $this->auth($c))->assertSuccessful();
        $this->postJson('/api/v1/cart/apply-offer', ['code' => 'TEN'], $this->auth($c))
            ->assertJsonPath('data.discount', 200)
            ->assertJsonPath('data.discount_percent', 10)
            ->assertJsonPath('data.offer.discount_type', 'percent');

        $res = $this->postJson('/api/v1/orders', [
            'type' => 'basra', 'branch_id' => $branch->id, 'payment_method' => 'cod', 'offer_code' => 'TEN',
            'customer_name' => 'A', 'customer_phone' => '07701234567',
        ], $this->auth($c))->assertCreated();

        $this->assertSame(1, $offer->fresh()->used_count);
        $this->assertSame(200.0, (float) $res->json('data.discount'));

        // the single-use coupon is now exhausted
        $this->postJson('/api/v1/cart/items', ['product_id' => $p->id, 'quantity' => 1], $this->auth($c));
        $this->postJson('/api/v1/cart/apply-offer', ['code' => 'TEN'], $this->auth($c))->assertStatus(400);

        $this->postJson('/api/v1/orders/' . $res->json('data.id') . '/cancel', [], $this->auth($c))->assertSuccessful();
        $this->assertSame(0, $offer->fresh()->used_count);
    }

    public function test_special_offer_badge_filter_includes_sale_price_products(): void
    {
        $badged = Product::factory()->create(['sale_price' => null]);
        ProductBadge::create(['product_id' => $badged->id, 'badge' => Product::BADGE_SPECIAL_OFFER]);
        $onSale = Product::factory()->create(['price' => 1000, 'sale_price' => 800]);
        $plain = Product::factory()->create(['sale_price' => null]);
        $best = Product::factory()->create(['sale_price' => null]);
        ProductBadge::create(['product_id' => $best->id, 'badge' => Product::BADGE_BEST_SELLER]);

        $ids = fn (string $badge) => collect($this->getJson("/api/v1/products?badge=$badge")->json('data'))->pluck('id')->sort()->values()->all();

        $this->assertSame(collect([$badged->id, $onSale->id])->sort()->values()->all(), $ids('special_offer'));
        $this->assertSame([$best->id], $ids('best_seller'));
        $this->assertNotContains($plain->id, $ids('special_offer'));
    }

    public function test_catalog_search_params_filter_by_size_brand_type_search_and_price(): void
    {
        $brandA = \App\Models\Brand::create(['slug' => 'brand-a', 'is_active' => true]);
        $a = Product::factory()->create(['brand_id' => $brandA->id, 'price' => 100000, 'type' => 'tire']);
        $a->tireSpec()->create(['width' => 205, 'aspect_ratio' => 55, 'rim_diameter' => 16]);
        $b = Product::factory()->create(['price' => 900000, 'type' => 'tire']);
        $b->tireSpec()->create(['width' => 225, 'aspect_ratio' => 45, 'rim_diameter' => 17]);

        $ids = fn (string $qs) => collect($this->getJson("/api/v1/products?$qs")->json('data'))->pluck('id')->sort()->values()->all();

        $this->assertSame([$a->id], $ids('width=205&aspect_ratio=55&rim_diameter=16'));
        $this->assertSame([$b->id], $ids('width=225'));
        $this->assertSame([$a->id], $ids("brand_id={$brandA->id}"));
        $this->assertSame([$b->id], $ids('min_price=500000&max_price=999999'));
        $this->assertEqualsCanonicalizing([$a->id, $b->id], $ids('type=tire'));
        $this->assertSame([], $ids('width=999'));
    }

    public function test_notifications_are_rendered_in_the_requested_locale(): void
    {
        $c = Customer::factory()->create();
        $c->notifications()->create([
            'id' => (string) \Illuminate\Support\Str::uuid(),
            'type' => 'App\\Notifications\\OrderStatusChangedNotification',
            'data' => ['type' => 'order_status_changed', 'title' => 'Order Updated', 'body' => 'x', 'reference' => 'ORD-1', 'status' => 'shipped'],
        ]);

        $en = $this->getJson('/api/v1/notifications', $this->auth($c) + ['X-Locale' => 'en'])->json('data.0');
        $ar = $this->getJson('/api/v1/notifications', $this->auth($c) + ['X-Locale' => 'ar'])->json('data.0');

        $this->assertSame('Order updated', $en['title']);
        $this->assertStringContainsString('ORD-1', $en['body']);
        $this->assertStringContainsString('On the way', $en['body']);
        $this->assertSame('تحديث الطلب', $ar['title']);
        $this->assertStringContainsString('في الطريق', $ar['body']);
    }

    public function test_unknown_notification_types_fall_back_to_stored_text(): void
    {
        $out = NotificationPresenter::present(['type' => 'legacy_thing', 'title' => 'T', 'body' => 'B'], 'ar');
        $this->assertSame(['title' => 'T', 'body' => 'B'], $out);
    }

    public function test_validation_errors_are_translated_per_request_locale(): void
    {
        $payload = ['phone' => '0770', 'password' => '1'];
        $en = $this->postJson('/api/v1/auth/register', $payload, ['X-Locale' => 'en'])->assertStatus(422)->json();
        $ar = $this->postJson('/api/v1/auth/register', $payload, ['X-Locale' => 'ar'])->assertStatus(422)->json();

        $this->assertSame('The name field is required.', $en['errors']['name'][0]);
        $this->assertSame('حقل الاسم مطلوب.', $ar['errors']['name'][0]);
        $this->assertSame('The given data was invalid.', $en['message']);
        $this->assertNotSame($en['message'], $ar['message']);
    }
}
