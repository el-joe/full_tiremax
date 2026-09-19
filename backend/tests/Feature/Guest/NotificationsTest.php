<?php

namespace Tests\Feature\Guest;

use App\Mail\BookingCreatedMail;
use App\Mail\BookingStatusChangedMail;
use App\Mail\OrderPlacedMail;
use App\Mail\OrderStatusChangedMail;
use App\Models\Booking;
use App\Models\Branch;
use App\Models\BranchSchedule;
use App\Models\Customer;
use App\Models\Order;
use App\Models\PaymentGateway;
use App\Models\Product;
use App\Models\Service;
use App\Models\Setting;
use App\Models\WhatsappLog;
use App\Services\BookingService;
use App\Services\OrderService;
use Database\Seeders\WhatsappTemplateSeeder;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Illuminate\Support\Facades\Http;
use Illuminate\Support\Facades\Mail;
use Illuminate\Support\Facades\Queue;
use Tests\TestCase;

class NotificationsTest extends TestCase
{
    use RefreshDatabase;

    private string $tok = 'aaaaaaaa-bbbb-cccc-dddd-000000000001';

    protected function setUp(): void
    {
        parent::setUp();
        PaymentGateway::create(['name' => 'cod', 'display_name' => 'COD', 'driver' => 'cod', 'is_active' => true, 'settings' => [], 'credentials' => []]);
        $this->seed(WhatsappTemplateSeeder::class);
        config(['services.whatsapp.api_url' => 'https://wa.test/send', 'services.whatsapp.api_token' => 't']);
        Mail::fake();
    }

    private bool $waFaked = false;

    private function fakeWa(int $status = 200): void
    {
        $this->waFaked = true;
        Http::fake(['wa.test/*' => Http::response(['id' => 'm1'], $status)]);
    }

    private function h(): array
    {
        return ['X-Guest-Token' => $this->tok, 'Accept' => 'application/json'];
    }

    private function cart(): void
    {
        $p = Product::factory()->create(['stock' => 10]);
        $this->postJson('/api/v1/cart/items', ['product_id' => $p->id, 'quantity' => 1], $this->h())->assertSuccessful();
    }

    private function orderPayload(array $x = []): array
    {
        return $x + ['type' => 'basra', 'branch_id' => Branch::factory()->create()->id, 'payment_method' => 'cod',
            'customer_name' => 'Ali', 'customer_phone' => '07701234567', 'customer_email' => 'ali@example.com', 'locale' => 'en'];
    }

    private function placeGuestOrder(array $x = []): \Illuminate\Testing\TestResponse
    {
        if (!$this->waFaked) { $this->fakeWa(); }
        $this->cart();
        return $this->postJson('/api/v1/orders', $this->orderPayload($x), $this->h());
    }

    public function test_guest_order_sends_mail_and_whatsapp_with_locale(): void
    {
        $this->placeGuestOrder()->assertSuccessful();
        $order = Order::first();
        $this->assertSame('ali@example.com', $order->customer_email);

        Mail::assertQueued(OrderPlacedMail::class, 1);
        Mail::assertQueued(OrderPlacedMail::class, fn ($m) => $m->hasTo('ali@example.com'));
        Http::assertSentCount(1);
        $log = WhatsappLog::first();
        $this->assertSame('order_placed', $log->template_key);
        $this->assertSame('9647701234567', $log->phone);
        $this->assertSame($order->customer_locale, $log->locale);
        $this->assertStringContainsString($order->reference, $log->body);
    }

    public function test_arabic_locale_uses_arabic_template(): void
    {
        $this->placeGuestOrder(['locale' => 'ar'])->assertSuccessful();
        $this->assertSame('ar', Order::first()->customer_locale);
        $this->assertStringContainsString('استلمنا', WhatsappLog::first()->body);
    }

    public function test_registered_customer_gets_db_mail_and_whatsapp(): void
    {
        $c = Customer::factory()->create(['email' => 'reg@example.com', 'phone' => '07709998888']);
        $p = Product::factory()->create(['stock' => 10]);
        $token = auth('api')->login($c);
        $h = ['Authorization' => "Bearer $token", 'Accept' => 'application/json'];
        $this->postJson('/api/v1/cart/items', ['product_id' => $p->id, 'quantity' => 1], $h)->assertSuccessful();
        $this->postJson('/api/v1/orders', ['type' => 'basra', 'branch_id' => Branch::factory()->create()->id, 'payment_method' => 'cod'], $h)->assertSuccessful();

        Mail::assertQueued(OrderPlacedMail::class, fn ($m) => $m->hasTo('reg@example.com'));
        $this->assertSame(1, WhatsappLog::count());
        $this->assertSame(1, $c->notifications()->count());
    }

    public function test_status_change_notifies_guest(): void
    {
        $this->placeGuestOrder()->assertSuccessful();
        $order = Order::first();
        app(OrderService::class)->changeStatus($order, Order::STATUS_CONFIRMED);

        Mail::assertQueued(OrderStatusChangedMail::class, fn ($m) => $m->hasTo('ali@example.com'));
        $this->assertTrue(WhatsappLog::where('template_key', 'order_confirmed')->exists());
    }

    public function test_whatsapp_failure_does_not_break_checkout(): void
    {
        $this->fakeWa(500);
        $this->placeGuestOrder()->assertSuccessful();
        $this->assertSame(1, Order::count());
        $this->assertSame('failed', WhatsappLog::first()->status);
    }

    public function test_mail_failure_does_not_break_checkout(): void
    {
        Mail::shouldReceive('to')->andThrow(new \RuntimeException('smtp down'));
        $this->placeGuestOrder()->assertSuccessful();
        $this->assertSame(1, Order::count());
        $this->assertDatabaseHas('notification_logs', ['channel' => 'email', 'status' => 'failed']);
    }

    public function test_disabled_settings_skip_channels(): void
    {
        foreach (['email_enabled', 'whatsapp_enabled'] as $k) {
            Setting::where('key', $k)->update(['value' => '0']);
        }
        $this->placeGuestOrder()->assertSuccessful();
        Mail::assertNothingQueued();
        $this->assertSame(0, WhatsappLog::count());
    }

    public function test_only_whatsapp_disabled_keeps_email(): void
    {
        Setting::where('key', 'whatsapp_enabled')->update(['value' => '0']);
        $this->placeGuestOrder()->assertSuccessful();
        Mail::assertQueued(OrderPlacedMail::class, 1);
        $this->assertSame(0, WhatsappLog::count());
    }

    public function test_whatsapp_dedupes_within_a_minute(): void
    {
        $this->placeGuestOrder()->assertSuccessful();
        $order = Order::first();
        $svc = app(\App\Services\WhatsappService::class);
        $this->assertNull($svc->send($order->customer_phone, 'order_placed', [], 'ar', $order));
        $this->assertSame(1, WhatsappLog::count());
        $this->assertNotNull($svc->send($order->customer_phone, 'order_placed', [], 'ar', $order, true));
    }

    public function test_listener_is_queued_and_api_succeeds(): void
    {
        Queue::fake();
        $this->placeGuestOrder()->assertSuccessful();
        Queue::assertPushed(\Illuminate\Events\CallQueuedListener::class, fn ($j) => $j->class === \App\Listeners\SendOrderNotifications::class);
    }

    private function bookingPayload(array $x = []): array
    {
        $branch = Branch::factory()->create();
        $svc = Service::factory()->create();
        $at = now()->addDays(2)->setTime(10, 0);
        BranchSchedule::create(['branch_id' => $branch->id, 'day_of_week' => $at->dayOfWeek, 'opens_at' => '08:00', 'closes_at' => '20:00', 'capacity' => 5, 'is_closed' => false]);
        return $x + ['branch_id' => $branch->id, 'service_id' => $svc->id, 'scheduled_at' => $at->toDateTimeString(),
            'customer_name' => 'Ali', 'customer_phone' => '07701234567', 'customer_email' => 'ali@example.com', 'locale' => 'ar'];
    }

    public function test_guest_booking_flow_and_status_change(): void
    {
        $this->postJson('/api/v1/bookings', $this->bookingPayload(), $this->h())->assertSuccessful();
        $b = Booking::first();
        Mail::assertQueued(BookingCreatedMail::class, fn ($m) => $m->hasTo('ali@example.com'));
        $this->assertTrue(WhatsappLog::where('booking_id', $b->id)->where('template_key', 'booking_created')->where('locale', 'ar')->exists());

        app(BookingService::class)->changeStatus($b, Booking::STATUS_CANCELLED);
        Mail::assertQueued(BookingStatusChangedMail::class, 1);
        $this->assertTrue(WhatsappLog::where('booking_id', $b->id)->where('template_key', 'booking_cancelled')->exists());
    }

    public function test_reminder_command_includes_guests(): void
    {
        $this->postJson('/api/v1/bookings', $this->bookingPayload(), $this->h())->assertSuccessful();
        Booking::query()->update(['scheduled_at' => now()->addDay()->setTime(10, 0), 'status' => 'confirmed']);
        $this->artisan('bookings:send-reminders')->assertSuccessful();
        $this->assertTrue(WhatsappLog::where('template_key', 'booking_reminder')->exists());
        \Illuminate\Support\Facades\Mail::assertQueued(\App\Mail\BookingReminderMail::class, 1);
        $this->artisan('bookings:send-reminders')->assertSuccessful();
        \Illuminate\Support\Facades\Mail::assertQueued(\App\Mail\BookingReminderMail::class, 1);
    }

    public function test_mail_renders_rtl_and_signup_link_for_guest(): void
    {
        $this->placeGuestOrder(['locale' => 'ar'])->assertSuccessful();
        $html = (new OrderPlacedMail(Order::first()))->render();
        $this->assertStringContainsString('dir="rtl"', $html);
        $this->assertStringContainsString('authDialog=on', $html);
    }
}
