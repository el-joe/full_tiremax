<?php

namespace Tests\Feature\Api;

use App\Models\Branch;
use App\Models\Customer;
use App\Models\Offer;
use App\Models\Order;
use App\Models\PaymentGateway;
use App\Models\Product;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Tests\TestCase;

class CartOrderApiTest extends TestCase
{
    use RefreshDatabase, ApiTestHelpers;

    private function cod(): void
    {
        PaymentGateway::create(['name' => 'cod', 'display_name' => 'COD', 'driver' => 'cod', 'is_active' => true, 'settings' => [], 'credentials' => []]);
    }

    public function test_guest_cart_lifecycle_with_guest_token(): void
    {
        $g = $this->guest();
        $p = Product::factory()->create(['stock' => 10]);

        $this->getJson('/api/v1/cart')->assertStatus(401); // neither JWT nor X-Guest-Token
        $this->getJson('/api/v1/cart', $g)->assertOk()->assertJsonStructure(['data' => ['id', 'items', 'subtotal', 'items_count']]);

        $res = $this->postJson('/api/v1/cart/items', ['product_id' => $p->id, 'quantity' => 2], $g)->assertSuccessful()
            ->assertJsonStructure(['data' => ['items' => [['id', 'product_id', 'product', 'quantity', 'unit_price', 'total']], 'subtotal', 'items_count']])
            ->assertJsonPath('data.items_count', 2);
        $itemId = $res->json('data.items.0.id');

        // another guest cannot see it
        $this->getJson('/api/v1/cart', $this->guest('other-guest-token-0123456789'))->assertOk()->assertJsonPath('data.items_count', 0);

        $this->putJson("/api/v1/cart/items/$itemId", ['quantity' => 5], $g)->assertOk()->assertJsonPath('data.items_count', 5);
        $this->putJson("/api/v1/cart/items/$itemId", ['quantity' => -1], $g)->assertStatus(422);
        $this->putJson("/api/v1/cart/items/$itemId", ['quantity' => 100], $g)->assertStatus(422);
        $this->deleteJson("/api/v1/cart/items/$itemId", [], $g)->assertOk()->assertJsonPath('data.items_count', 0);
        $this->putJson('/api/v1/cart/items/99999', ['quantity' => 1], $g)->assertNotFound();

        $this->postJson('/api/v1/cart/items', ['product_id' => $p->id, 'quantity' => 1], $g)->assertSuccessful();
        $this->deleteJson('/api/v1/cart', [], $g)->assertOk();
        $this->getJson('/api/v1/cart', $g)->assertJsonPath('data.items_count', 0);
    }

    public function test_cart_validation_errors(): void
    {
        $g = $this->guest();
        $this->postJson('/api/v1/cart/items', [], $g)->assertStatus(422)->assertJsonStructure(['errors' => ['product_id', 'quantity']]);
        $this->postJson('/api/v1/cart/items', ['product_id' => 99999, 'quantity' => 1], $g)->assertStatus(422);
        $this->postJson('/api/v1/cart/apply-offer', ['code' => 'NOPE'], $g)->assertNotFound();
    }

    public function test_customer_cart_and_apply_offer(): void
    {
        $c = Customer::factory()->create();
        $p = Product::factory()->create(['stock' => 10, 'price' => 1000, 'sale_price' => null]);
        Offer::create(['code' => 'TEN', 'discount_type' => 'percent', 'discount_value' => 10, 'min_subtotal' => 0, 'is_active' => true]);

        $h = $this->bearer($c);
        $this->postJson('/api/v1/cart/items', ['product_id' => $p->id, 'quantity' => 1], $h)->assertSuccessful();
        $this->postJson('/api/v1/cart/apply-offer', ['code' => 'TEN'], $h)->assertOk()
            ->assertJsonStructure(['data' => ['discount', 'discount_percent', 'offer' => ['discount_type']]]);
    }

    public function test_guest_checkout_show_and_cancel_by_reference(): void
    {
        $this->cod();
        $g = $this->guest();
        $p = Product::factory()->create(['stock' => 10]);
        $branch = Branch::factory()->create();
        $this->postJson('/api/v1/cart/items', ['product_id' => $p->id, 'quantity' => 1], $g)->assertSuccessful();

        $payload = ['type' => 'basra', 'branch_id' => $branch->id, 'payment_method' => 'cod', 'customer_name' => 'Guest', 'customer_phone' => '07701234567'];
        $res = $this->postJson('/api/v1/orders', $payload, $g)->assertCreated()
            ->assertJsonStructure(['data' => ['id', 'reference', 'type', 'status', 'payment_method', 'payment_status', 'subtotal', 'discount', 'shipping_fee', 'total', 'items' => [['product_name', 'quantity', 'unit_price', 'total']]]]);
        $ref = $res->json('data.reference');
        $id = $res->json('data.id');

        $this->getJson("/api/v1/orders/$ref", $g)->assertOk()->assertJsonPath('data.reference', $ref);
        $this->getJson("/api/v1/orders/$ref", $this->guest('other-guest-token-0123456789'))->assertNotFound();
        $this->getJson('/api/v1/orders/ORD-DOESNOTEXIST', $g)->assertNotFound();
        $this->getJson('/api/v1/orders/payment', $g)->assertStatus(404);

        $this->postJson("/api/v1/orders/$id/cancel", [], $this->guest('other-guest-token-0123456789'))->assertStatus(403);
        $this->postJson("/api/v1/orders/$id/cancel", [], $g)->assertOk()->assertJsonPath('data.status', Order::STATUS_CANCELLED);
    }

    public function test_checkout_validation_and_empty_cart(): void
    {
        $g = $this->guest();
        $this->postJson('/api/v1/orders', [], $g)->assertStatus(422)->assertJsonStructure(['errors' => ['type', 'customer_name', 'customer_phone']]);
        $this->postJson('/api/v1/orders', ['type' => 'delivery', 'customer_name' => 'A', 'customer_phone' => '07701234567'], $g)
            ->assertStatus(422)->assertJsonStructure(['errors' => ['governorate_id', 'shipping_address']]);
        $this->postJson('/api/v1/orders', ['type' => 'basra', 'branch_id' => Branch::factory()->create()->id, 'customer_name' => 'A', 'customer_phone' => '07701234567'], $g)
            ->assertStatus(400); // empty cart
    }

    public function test_customer_order_list_show_and_ownership(): void
    {
        $c = Customer::factory()->create();
        $other = Customer::factory()->create();
        $mine = Order::factory()->create(['customer_id' => $c->id]);
        $theirs = Order::factory()->create(['customer_id' => $other->id]);

        $h = $this->bearer($c);
        $this->getJson('/api/v1/orders', $h)->assertOk()->assertJsonCount(1, 'data')
            ->assertJsonStructure(['data' => [['id', 'reference', 'status', 'total']], 'meta' => ['pagination' => ['total', 'per_page', 'current_page', 'last_page']]]);
        $this->getJson("/api/v1/orders/{$mine->id}", $h)->assertOk()->assertJsonPath('data.id', $mine->id);
        $this->getJson("/api/v1/orders/{$theirs->id}", $h)->assertNotFound();
        $this->postJson("/api/v1/orders/{$theirs->id}/cancel", [], $h)->assertStatus(403);
        $this->postJson("/api/v1/orders/99999/cancel", [], $h)->assertNotFound();

        $this->forgetAuth();
        $this->getJson('/api/v1/orders')->assertStatus(401);
    }
}
