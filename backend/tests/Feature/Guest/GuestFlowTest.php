<?php

namespace Tests\Feature\Guest;

use App\Models\Booking;
use App\Models\Branch;
use App\Models\BranchSchedule;
use App\Models\Cart;
use App\Models\Customer;
use App\Models\Offer;
use App\Models\Order;
use App\Models\PaymentGateway;
use App\Models\Product;
use App\Models\Review;
use App\Models\Service;
use App\Models\Governorate;
use App\Support\Phone;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Tests\TestCase;

class GuestFlowTest extends TestCase
{
    use RefreshDatabase;

    private string $tok = 'aaaaaaaa-bbbb-cccc-dddd-000000000001';
    private string $tok2 = 'aaaaaaaa-bbbb-cccc-dddd-000000000002';

    protected function setUp(): void
    {
        parent::setUp();
        PaymentGateway::create(['name' => 'cod', 'display_name' => 'COD', 'driver' => 'cod', 'is_active' => true, 'settings' => [], 'credentials' => []]);
    }

    private function h(?string $t = null): array
    {
        return ['X-Guest-Token' => $t ?? $this->tok, 'Accept' => 'application/json'];
    }

    private function checkoutPayload(array $extra = []): array
    {
        $branch = Branch::factory()->create();
        return $extra + [
            'type' => 'basra', 'branch_id' => $branch->id, 'payment_method' => 'cod',
            'customer_name' => 'Ali Guest', 'customer_phone' => '07701234567',
        ];
    }

    private function bookingPayload(array $extra = []): array
    {
        $branch = Branch::factory()->create();
        $svc = Service::factory()->create();
        $at = now()->addDays(2)->setTime(10, 0);
        BranchSchedule::create(['branch_id' => $branch->id, 'day_of_week' => $at->dayOfWeek, 'opens_at' => '08:00', 'closes_at' => '20:00', 'capacity' => 5, 'is_closed' => false]);
        return $extra + [
            'branch_id' => $branch->id, 'service_id' => $svc->id, 'scheduled_at' => $at->toDateTimeString(),
            'customer_name' => 'Ali Guest', 'customer_phone' => '+964 770 123 4567',
        ];
    }

    public function test_phone_normalize(): void
    {
        $this->assertSame('9647701234567', Phone::normalize('0770 123 4567'));
        $this->assertSame('9647701234567', Phone::normalize('+964 770 123 4567'));
        $this->assertSame('9647701234567', Phone::normalize('00964 7701234567'));
        $this->assertNull(Phone::normalize(''));
        $this->assertFalse(Phone::isValidIraqi('12345'));
    }

    public function test_cart_requires_identity(): void
    {
        $this->getJson('/api/v1/cart')->assertStatus(401);
    }

    public function test_guest_cart_add_update_clear(): void
    {
        $p = Product::factory()->create(['stock' => 10]);
        $r = $this->postJson('/api/v1/cart/items', ['product_id' => $p->id, 'quantity' => 2], $this->h())->assertSuccessful();
        $itemId = $r->json('data.items.0.id');
        $this->assertSame(1, Cart::where('guest_token', $this->tok)->count());

        $this->putJson("/api/v1/cart/items/$itemId", ['quantity' => 4], $this->h())->assertSuccessful();
        $this->getJson('/api/v1/cart', $this->h())->assertJsonPath('data.items_count', 4);
        // other guest sees an empty cart
        $this->getJson('/api/v1/cart', $this->h($this->tok2))->assertJsonPath('data.items_count', 0);
        $this->deleteJson('/api/v1/cart', [], $this->h())->assertSuccessful();
        $this->getJson('/api/v1/cart', $this->h())->assertJsonPath('data.items_count', 0);
    }

    public function test_guest_cannot_touch_other_guests_cart_item(): void
    {
        $p = Product::factory()->create(['stock' => 10]);
        $r = $this->postJson('/api/v1/cart/items', ['product_id' => $p->id, 'quantity' => 1], $this->h())->assertSuccessful();
        $itemId = $r->json('data.items.0.id');
        $this->deleteJson("/api/v1/cart/items/$itemId", [], $this->h($this->tok2))->assertSuccessful();
        $this->getJson('/api/v1/cart', $this->h())->assertJsonPath('data.items_count', 1);
    }

    public function test_guest_checkout_cod_creates_guest_order_and_decrements_stock(): void
    {
        $p = Product::factory()->create(['stock' => 10, 'price' => 1000]);
        $this->postJson('/api/v1/cart/items', ['product_id' => $p->id, 'quantity' => 3], $this->h());
        $r = $this->postJson('/api/v1/orders', $this->checkoutPayload(), $this->h())->assertCreated()
            ->assertJsonPath('data.is_guest', true);
        $o = Order::first();
        $this->assertNull($o->customer_id);
        $this->assertTrue($o->is_guest);
        $this->assertSame($this->tok, $o->guest_token);
        $this->assertSame('9647701234567', $o->phone_normalized);
        $this->assertSame(7, $p->fresh()->stock);
        $this->assertArrayNotHasKey('guest_token', $r->json('data'));
        $this->getJson('/api/v1/cart', $this->h())->assertJsonPath('data.items_count', 0);
    }

    public function test_checkout_ignores_client_discount_and_fee_and_uses_offer_code(): void
    {
        $p = Product::factory()->create(['stock' => 10, 'price' => 1000]);
        Offer::create(['code' => 'TEN', 'discount_type' => 'percent', 'discount_value' => 10, 'min_subtotal' => 0, 'is_active' => true]);
        $this->postJson('/api/v1/cart/items', ['product_id' => $p->id, 'quantity' => 2], $this->h());
        $this->postJson('/api/v1/orders', $this->checkoutPayload(['discount' => 99999, 'installation_fee' => 5000]), $this->h())->assertCreated();
        $o = Order::first();
        $this->assertEquals(0, $o->discount);
        $this->assertEquals(0, $o->installation_fee);
        $this->assertEquals(2000, $o->total);

        $this->postJson('/api/v1/cart/items', ['product_id' => $p->id, 'quantity' => 2], $this->h());
        $this->postJson('/api/v1/orders', $this->checkoutPayload(['offer_code' => 'TEN']), $this->h())->assertCreated();
        $o2 = Order::latest('id')->first();
        $this->assertEquals(200, $o2->discount);
        $this->assertEquals(1800, $o2->total);
    }

    public function test_guest_checkout_validation(): void
    {
        $this->postJson('/api/v1/orders', ['type' => 'basra'], $this->h())->assertStatus(422)
            ->assertJsonValidationErrors(['customer_name', 'customer_phone']);
        $this->postJson('/api/v1/orders', $this->checkoutPayload(['customer_phone' => '12345']), $this->h())->assertStatus(422)
            ->assertJsonValidationErrors(['customer_phone']);
        $this->postJson('/api/v1/orders', $this->checkoutPayload(['customer_email' => 'nope']), $this->h())->assertStatus(422)
            ->assertJsonValidationErrors(['customer_email']);
        // empty cart
        $this->postJson('/api/v1/orders', $this->checkoutPayload(), $this->h())->assertStatus(400);
        // no identity at all
        $this->postJson('/api/v1/orders', $this->checkoutPayload(), ['Accept' => 'application/json'])->assertStatus(401);
    }

    public function test_guest_order_access_rules(): void
    {
        $o = Order::factory()->guest($this->tok)->create(['customer_phone' => '07701234567']);
        $ref = $o->reference;

        $this->getJson("/api/v1/orders/$ref", $this->h())->assertOk()->assertJsonPath('data.reference', $ref);
        $this->getJson("/api/v1/orders/{$o->id}", $this->h())->assertOk();
        // other guest -> 404, numeric id alone -> 404
        $this->getJson("/api/v1/orders/$ref", $this->h($this->tok2))->assertNotFound();
        $this->getJson("/api/v1/orders/{$o->id}", ['Accept' => 'application/json'])->assertNotFound();
        $this->getJson("/api/v1/orders/{$o->id}?phone=07701234567", ['Accept' => 'application/json'])->assertNotFound();
        // reference + phone works without token; wrong phone doesn't
        $this->getJson("/api/v1/orders/$ref?phone=%2B9647701234567", ['Accept' => 'application/json'])->assertOk();
        $this->getJson("/api/v1/orders/$ref?phone=07709999999", ['Accept' => 'application/json'])->assertNotFound();
        // payment + cancel
        $this->getJson("/api/v1/orders/{$o->id}/payment", $this->h($this->tok2))->assertForbidden();
        $this->postJson("/api/v1/orders/{$o->id}/cancel", [], $this->h($this->tok2))->assertForbidden();
        $this->postJson("/api/v1/orders/{$o->id}/cancel", [], $this->h())->assertOk()->assertJsonPath('data.status', 'cancelled');
    }

    public function test_registered_customer_cannot_read_others_orders_and_phone_lookup_is_guest_only(): void
    {
        $a = Customer::factory()->create();
        $b = Customer::factory()->create();
        $o = Order::factory()->create(['customer_id' => $a->id, 'customer_phone' => '07701234567']);
        $tokenB = auth('api')->login($b);
        $this->getJson("/api/v1/orders/{$o->id}", ['Authorization' => "Bearer $tokenB"])->assertNotFound();
        $this->getJson("/api/v1/orders/{$o->reference}?phone=07701234567", [])->assertNotFound();
        $tokenA = auth('api')->login($a);
        $this->getJson("/api/v1/orders/{$o->id}", ['Authorization' => "Bearer $tokenA"])->assertOk();
        $this->getJson('/api/v1/orders', ['Authorization' => "Bearer $tokenA"])->assertOk();
    }

    public function test_order_and_booking_lists_require_auth(): void
    {
        $this->getJson('/api/v1/orders', $this->h())->assertStatus(401);
        $this->getJson('/api/v1/bookings', $this->h())->assertStatus(401);
    }

    public function test_guest_booking_and_access(): void
    {
        $r = $this->postJson('/api/v1/bookings', $this->bookingPayload(), $this->h())->assertCreated()
            ->assertJsonPath('data.is_guest', true);
        $b = Booking::first();
        $this->assertNull($b->customer_id);
        $this->assertSame('9647701234567', $b->phone_normalized);
        $this->getJson("/api/v1/bookings/{$b->reference}", $this->h())->assertOk();
        $this->getJson("/api/v1/bookings/{$b->reference}", $this->h($this->tok2))->assertNotFound();
        $this->getJson("/api/v1/bookings/{$b->reference}?phone=07701234567")->assertOk();
        $this->postJson("/api/v1/bookings/{$b->id}/cancel", [], $this->h($this->tok2))->assertForbidden();
        $this->postJson("/api/v1/bookings/{$b->id}/cancel", [], $this->h())->assertOk();
    }

    public function test_guest_booking_validation(): void
    {
        $this->postJson('/api/v1/bookings', $this->bookingPayload(['customer_name' => null, 'customer_phone' => 'abc']), $this->h())
            ->assertStatus(422)->assertJsonValidationErrors(['customer_name', 'customer_phone']);
        $this->postJson('/api/v1/bookings', $this->bookingPayload(), ['Accept' => 'application/json'])->assertStatus(401);
        $this->getJson('/api/v1/bookings/branch/1/slots?date=2030-01-01')->assertStatus(404); // public route reachable
    }

    public function test_booking_cannot_attach_to_someone_elses_order(): void
    {
        $o = Order::factory()->guest($this->tok2)->create();
        $this->postJson('/api/v1/bookings', $this->bookingPayload(['order_id' => $o->id]), $this->h())->assertForbidden();
    }

    public function test_register_links_guest_data_by_phone_token_and_merges_cart(): void
    {
        $p = Product::factory()->create(['stock' => 5]);
        $o = Order::factory()->guest($this->tok)->create(['customer_phone' => '07701234567']);
        $byPhone = Order::factory()->guest($this->tok2)->create(['customer_phone' => '+964 770 123 4567']);
        $other = Order::factory()->guest('zzzzzzzzzzzzzzzzzzzz')->create(['customer_phone' => '07809999999']);
        $bk = Booking::factory()->guest($this->tok2)->create(['customer_phone' => '07701234567']);
        $this->postJson('/api/v1/cart/items', ['product_id' => $p->id, 'quantity' => 3], $this->h());

        $r = $this->postJson('/api/v1/auth/register', [
            'name' => 'Ali', 'phone' => '07701234567', 'password' => 'secret1', 'password_confirmation' => 'secret1',
        ], $this->h())->assertCreated()
            ->assertJsonPath('meta.linked_orders', 2)->assertJsonPath('meta.linked_bookings', 1);

        $c = Customer::where('phone', '07701234567')->first();
        $this->assertSame($c->id, $o->fresh()->customer_id);
        $this->assertFalse($o->fresh()->is_guest);
        $this->assertSame($c->id, $byPhone->fresh()->customer_id);
        $this->assertSame($c->id, $bk->fresh()->customer_id);
        $this->assertNull($other->fresh()->customer_id);
        $cart = Cart::where('customer_id', $c->id)->first();
        $this->assertSame(3, (int) $cart->items()->sum('quantity'));
        $this->assertSame(0, Cart::where('guest_token', $this->tok)->count());
    }

    public function test_registration_ok_when_phone_only_exists_on_guest_order(): void
    {
        Order::factory()->guest()->create(['customer_phone' => '07701234567']);
        $this->postJson('/api/v1/auth/register', [
            'name' => 'Ali', 'phone' => '07701234567', 'password' => 'secret1', 'password_confirmation' => 'secret1',
        ], ['Accept' => 'application/json'])->assertCreated()->assertJsonPath('meta.linked_orders', 1);
    }

    public function test_login_links_and_caps_cart_by_stock(): void
    {
        $c = Customer::factory()->create(['phone' => '07705550000']);
        $p = Product::factory()->create(['stock' => 2]);
        Cart::create(['customer_id' => $c->id])->items()->create(['product_id' => $p->id, 'quantity' => 2, 'unit_price' => 1]);
        $gc = Cart::create(['guest_token' => $this->tok]);
        $gc->items()->create(['product_id' => $p->id, 'quantity' => 2, 'unit_price' => 1]);
        $o = Order::factory()->guest($this->tok)->create(['customer_phone' => '07111111111']);

        $this->postJson('/api/v1/auth/login', ['login' => '07705550000', 'password' => 'password'], $this->h())
            ->assertOk()->assertJsonPath('meta.linked_orders', 1);
        $this->assertSame($c->id, $o->fresh()->customer_id);
        $this->assertSame(2, (int) Cart::where('customer_id', $c->id)->first()->items()->sum('quantity'));
    }

    public function test_customers_cannot_steal_each_others_orders(): void
    {
        $a = Customer::factory()->create(['phone' => '07701111111']);
        $o = Order::factory()->create(['customer_id' => $a->id, 'customer_phone' => '07702222222']);
        // b registers with the phone used on a's (already linked) order and a's would-be token
        $this->postJson('/api/v1/auth/register', [
            'name' => 'B', 'phone' => '07702222222', 'password' => 'secret1', 'password_confirmation' => 'secret1',
        ], $this->h())->assertCreated()->assertJsonPath('meta.linked_orders', 0);
        $this->assertSame($a->id, $o->fresh()->customer_id);
    }

    public function test_guest_order_throttled(): void
    {
        for ($i = 0; $i < 10; $i++) {
            $this->postJson('/api/v1/orders', ['type' => 'basra'], $this->h())->assertStatus(422);
        }
        $this->postJson('/api/v1/orders', ['type' => 'basra'], $this->h())->assertStatus(429);
    }

    public function test_reviews_are_pending_and_hidden_publicly_until_approved(): void
    {
        $c = Customer::factory()->create();
        $p = Product::factory()->create();
        $token = auth('api')->login($c);
        $this->postJson("/api/v1/reviews/{$p->id}", ['rating' => 5, 'comment' => 'nice'], ['Authorization' => "Bearer $token"])->assertCreated();
        $rev = Review::first();
        $this->assertNull($rev->is_approved);
        $this->getJson("/api/v1/reviews/{$p->id}")->assertJsonPath('meta.rating_count', 0);
        $rev->update(['is_approved' => true]);
        $this->getJson("/api/v1/reviews/{$p->id}")->assertJsonPath('meta.rating_count', 1);
        $rev->update(['is_approved' => false]);
        $this->getJson("/api/v1/reviews/{$p->id}")->assertJsonPath('meta.rating_count', 0);
    }
}
