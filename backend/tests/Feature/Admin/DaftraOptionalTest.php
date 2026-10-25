<?php

namespace Tests\Feature\Admin;

use App\Events\OrderPlaced;
use App\Integrations\Daftra;
use App\Listeners\ConfirmOrderBookings;
use App\Listeners\PushOrderToDaftra;
use App\Models\Booking;
use App\Models\Order;
use App\Models\Setting;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Illuminate\Support\Facades\Http;
use Tests\TestCase;

class DaftraOptionalTest extends TestCase
{
    use RefreshDatabase;

    private function daftra(bool $enabled, bool $configured = true): void
    {
        foreach (['enabled' => $enabled ? '1' : '0', 'api_url' => $configured ? 'https://x.daftra.com/api2' : null, 'api_key' => $configured ? 'k' : null] as $key => $value) {
            Setting::updateOrCreate(['group' => 'daftra', 'key' => $key], ['cast' => $key === 'enabled' ? 'bool' : 'string', 'is_translatable' => false, 'value' => $value]);
        }
    }

    public function test_disabled_or_unconfigured_is_not_active(): void
    {
        $this->daftra(false);
        $this->assertFalse(Daftra::isActive());
        $this->daftra(true, false);
        $this->assertFalse(Daftra::isActive());
        $this->daftra(true);
        $this->assertTrue(Daftra::isActive());
    }

    public function test_push_listener_does_nothing_when_disabled(): void
    {
        $this->daftra(false);
        Http::fake();
        $order = Order::factory()->create();

        (new PushOrderToDaftra)->handle(new OrderPlaced($order));

        Http::assertNothingSent();
        $this->assertDatabaseCount('daftra_sync_logs', 0);
    }

    public function test_pending_order_bookings_confirm_without_daftra_only(): void
    {
        $order = Order::factory()->create();
        $b = Booking::factory()->create(['order_id' => $order->id, 'status' => Booking::STATUS_PENDING]);

        $this->daftra(true);
        (new ConfirmOrderBookings)->handle(new OrderPlaced($order));
        $this->assertSame(Booking::STATUS_PENDING, $b->fresh()->status);

        $this->daftra(false);
        (new ConfirmOrderBookings)->handle(new OrderPlaced($order));
        $this->assertSame(Booking::STATUS_CONFIRMED, $b->fresh()->status);
    }
}
