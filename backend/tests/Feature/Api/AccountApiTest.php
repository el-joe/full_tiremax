<?php

namespace Tests\Feature\Api;

use App\Models\Address;
use App\Models\Booking;
use App\Models\Branch;
use App\Models\BranchSchedule;
use App\Models\City;
use App\Models\Customer;
use App\Models\Governorate;
use App\Models\PaymentGateway;
use App\Models\Product;
use App\Models\Service;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Tests\TestCase;

class AccountApiTest extends TestCase
{
    use RefreshDatabase, ApiTestHelpers;

    private function geo(): array
    {
        $g = Governorate::create(['code' => 'BSR', 'is_basra' => true, 'is_active' => true, 'ar' => ['name' => 'البصرة'], 'en' => ['name' => 'Basra']]);
        $city = City::create(['governorate_id' => $g->id, 'name_ar' => 'الزبير', 'name_en' => 'Zubair', 'is_active' => true]);
        return [$g, $city];
    }

    public function test_addresses_crud_and_default(): void
    {
        [$g, $city] = $this->geo();
        $c = Customer::factory()->create();
        $h = $this->bearer($c);
        $body = ['full_name' => 'Ali', 'phone' => '07701234567', 'governorate_id' => $g->id, 'city_id' => $city->id, 'address' => 'Street 1'];

        $this->postJson('/api/v1/addresses', [], $h)->assertStatus(422);
        $id1 = $this->postJson('/api/v1/addresses', $body, $h)->assertCreated()
            ->assertJsonStructure(['data' => ['id', 'full_name', 'phone', 'governorate', 'city', 'address', 'is_default']])->json('data.id');
        $id2 = $this->postJson('/api/v1/addresses', $body + ['is_default' => true], $h)->assertCreated()->json('data.id');

        $this->getJson('/api/v1/addresses', $h)->assertOk()->assertJsonCount(2, 'data');
        $this->getJson("/api/v1/addresses/$id1", $h)->assertOk()->assertJsonPath('data.id', $id1);
        $this->putJson("/api/v1/addresses/$id1", ['address' => 'Street 2'], $h)->assertOk()->assertJsonPath('data.address', 'Street 2');
        $this->postJson("/api/v1/addresses/$id1/set-default", [], $h)->assertOk()->assertJsonPath('data.is_default', true);
        $this->assertFalse((bool) Address::find($id2)->is_default);
        $this->deleteJson("/api/v1/addresses/$id2", [], $h)->assertOk();
        $this->getJson("/api/v1/addresses/$id2", $h)->assertNotFound();

        // foreign address is not accessible
        $foreign = Address::create($body + ['customer_id' => Customer::factory()->create()->id]);
        $this->getJson("/api/v1/addresses/{$foreign->id}", $h)->assertForbidden();
        $this->putJson("/api/v1/addresses/{$foreign->id}", ['address' => 'x'], $h)->assertForbidden();
        $this->deleteJson("/api/v1/addresses/{$foreign->id}", [], $h)->assertForbidden();

        $this->forgetAuth();
        $this->getJson('/api/v1/addresses')->assertStatus(401);
    }

    public function test_favorites_toggle_and_list(): void
    {
        $c = Customer::factory()->create();
        $p = Product::factory()->create();
        $h = $this->bearer($c);

        $this->postJson("/api/v1/favorites/{$p->id}/toggle", [], $h)->assertCreated()->assertJsonPath('data.favorited', true);
        $this->getJson('/api/v1/favorites', $h)->assertOk()->assertJsonPath('data.0.id', $p->id);
        $this->postJson("/api/v1/favorites/{$p->id}/toggle", [], $h)->assertOk()->assertJsonPath('data.favorited', false);
        $this->getJson('/api/v1/favorites', $h)->assertJsonCount(0, 'data');
        $this->postJson('/api/v1/favorites/99999/toggle', [], $h)->assertNotFound();

        $this->forgetAuth();
        $this->getJson('/api/v1/favorites')->assertStatus(401);
        $this->postJson("/api/v1/favorites/{$p->id}/toggle")->assertStatus(401);
    }

    public function test_notifications_list_count_read_and_read_all(): void
    {
        $c = Customer::factory()->create();
        foreach ([1, 2] as $i) {
            $c->notifications()->create([
                'id' => (string) \Illuminate\Support\Str::uuid(),
                'type' => 'App\\Notifications\\OrderStatusChangedNotification',
                'data' => ['type' => 'order_status_changed', 'title' => 'T', 'body' => 'B', 'reference' => "ORD-$i", 'status' => 'shipped'],
            ]);
        }
        $h = $this->bearer($c);

        $first = $this->getJson('/api/v1/notifications', $h)->assertOk()
            ->assertJsonStructure(['data' => [['id', 'type', 'title', 'body', 'read_at', 'created_at']], 'meta' => ['current_page', 'last_page', 'per_page', 'total', 'unread_count']])
            ->assertJsonPath('meta.unread_count', 2)->json('data.0.id');
        $this->getJson('/api/v1/notifications/unread-count', $h)->assertOk()->assertJsonPath('unread_count', 2);
        $this->postJson("/api/v1/notifications/$first/read", [], $h)->assertOk();
        $this->getJson('/api/v1/notifications/unread-count', $h)->assertJsonPath('unread_count', 1);
        $this->postJson('/api/v1/notifications/read-all', [], $h)->assertOk();
        $this->getJson('/api/v1/notifications/unread-count', $h)->assertJsonPath('unread_count', 0);

        $this->forgetAuth();
        $this->getJson('/api/v1/notifications')->assertStatus(401);
        $this->getJson('/api/v1/notifications/unread-count')->assertStatus(401);
    }

    public function test_bookings_customer_flow(): void
    {
        $c = Customer::factory()->create();
        $branch = Branch::factory()->create();
        $service = Service::factory()->create();
        $h = $this->bearer($c);
        $at = now()->addDays(3)->setTime(10, 0);
        BranchSchedule::create(['branch_id' => $branch->id, 'day_of_week' => $at->dayOfWeek, 'opens_at' => '08:00', 'closes_at' => '20:00', 'is_closed' => false]);

        $this->postJson('/api/v1/bookings', [], $h)->assertStatus(422)->assertJsonStructure(['errors' => ['branch_id', 'service_id', 'scheduled_at']]);
        $res = $this->postJson('/api/v1/bookings', ['branch_id' => $branch->id, 'service_id' => $service->id, 'scheduled_at' => $at->toIso8601String()], $h)->assertCreated()
            ->assertJsonStructure(['data' => ['id', 'reference', 'scheduled_at', 'duration_minutes', 'status', 'branch', 'service']]);
        $id = $res->json('data.id');
        $ref = $res->json('data.reference');

        $this->getJson('/api/v1/bookings', $h)->assertOk()->assertJsonCount(1, 'data')->assertJsonStructure(['meta' => ['pagination']]);
        $this->getJson("/api/v1/bookings/$ref", $h)->assertOk()->assertJsonPath('data.id', $id);
        $this->getJson('/api/v1/bookings/BK-NOPE', $h)->assertNotFound();
        $this->postJson("/api/v1/bookings/$id/cancel", [], $h)->assertOk()->assertJsonPath('data.status', Booking::STATUS_CANCELLED);

        $this->forgetAuth();
        $this->getJson('/api/v1/bookings')->assertStatus(401);
    }

    public function test_bookings_guest_flow(): void
    {
        $branch = Branch::factory()->create();
        $service = Service::factory()->create();
        $g = $this->guest();
        $at = now()->addDays(3)->setTime(10, 0);
        BranchSchedule::create(['branch_id' => $branch->id, 'day_of_week' => $at->dayOfWeek, 'opens_at' => '08:00', 'closes_at' => '20:00', 'is_closed' => false]);
        $body = ['branch_id' => $branch->id, 'service_id' => $service->id, 'scheduled_at' => $at->toIso8601String()];

        $this->postJson('/api/v1/bookings', $body, $g)->assertStatus(422)->assertJsonStructure(['errors' => ['customer_name', 'customer_phone']]);
        $this->postJson('/api/v1/bookings', $body + ['customer_name' => 'G', 'customer_phone' => '123'], $g)->assertStatus(422);
        $res = $this->postJson('/api/v1/bookings', $body + ['customer_name' => 'G', 'customer_phone' => '07701234567'], $g)->assertCreated();
        $ref = $res->json('data.reference');
        $id = $res->json('data.id');

        $this->getJson("/api/v1/bookings/$ref", $g)->assertOk();
        $this->getJson("/api/v1/bookings/$ref", $this->guest('other-guest-token-0123456789'))->assertNotFound();
        $this->postJson("/api/v1/bookings/$id/cancel", [], $this->guest('other-guest-token-0123456789'))->assertStatus(403);
        $this->postJson("/api/v1/bookings/$id/cancel", [], $g)->assertOk();
    }

    public function test_contact_messages(): void
    {
        $this->postJson('/api/v1/contact-messages', [])->assertStatus(422)->assertJsonStructure(['errors' => ['name', 'phone', 'subject', 'message']]);
        $this->postJson('/api/v1/contact-messages', ['name' => 'A', 'phone' => '07701234567', 'subject' => 'Hi', 'message' => 'Hello'])
            ->assertCreated()->assertJsonPath('success', true);
        $this->assertDatabaseHas('contact_messages', ['subject' => 'Hi']);
    }

    public function test_public_settings_and_payment_gateways(): void
    {
        $this->getJson('/api/v1/settings/public')->assertOk();
        PaymentGateway::create(['name' => 'cod', 'display_name' => 'COD', 'driver' => 'cod', 'is_active' => true, 'settings' => [], 'credentials' => []]);
        $this->getJson('/api/v1/payment-gateways')->assertOk()->assertJsonStructure(['data' => [['id', 'name', 'display_name', 'driver', 'is_active']]])->assertJsonPath('data.0.is_active', true);
    }
}
