<?php

namespace Tests\Feature\Admin;

use App\Livewire\Admin\Branches\BranchManager;
use App\Livewire\Admin\Customers\CustomerManager;
use App\Livewire\Admin\Orders\OrderManager;
use App\Models\Branch;
use App\Models\Customer;
use App\Models\Order;
use App\Models\Setting;
use App\Support\MailSettings;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Livewire\Livewire;
use Tests\TestCase;

class AdminRegressionsTest extends TestCase
{
    use RefreshDatabase, ActingAsAdmin;

    public function test_customer_view_modal_renders_with_activity_log(): void
    {
        $this->actingAsAdmin(['customers.view']);
        $c = Customer::factory()->create(['name' => 'Viewed Customer']);
        Order::factory()->create(['customer_id' => $c->id]);

        Livewire::test(CustomerManager::class)
            ->call('view', $c->id)
            ->assertHasNoErrors()
            ->assertSee('Viewed Customer');
    }

    public function test_order_modal_shows_line_prices_and_branch_for_pickup_orders(): void
    {
        $this->actingAsAdmin(['orders.view']);
        $branch = Branch::factory()->create();
        $branch->translateOrNew('en')->fill(['name' => 'Pickup Branch', 'address' => '12 Corniche St']);
        $branch->save();
        $order = Order::factory()->create(['type' => 'basra', 'branch_id' => $branch->id]);
        $order->items()->create(['product_id' => \App\Models\Product::factory()->create()->id, 'product_name' => 'Winter Tire', 'product_sku' => 'WT-1', 'quantity' => 2, 'unit_price' => 45000, 'total' => 90000]);

        Livewire::test(OrderManager::class)
            ->call('view', $order->id)
            ->assertSee('Pickup Branch')
            ->assertSee('12 Corniche St')
            ->assertSee('WT-1')
            ->assertSee('90,000')
            ->assertSee('45,000');
    }

    public function test_branch_working_hours_are_saved_and_drive_the_booking_slots(): void
    {
        $this->actingAsAdmin(['branches.view', 'branches.create', 'branches.update']);

        $component = Livewire::test(BranchManager::class)->call('openCreate');
        $this->assertCount(7, $component->get('form.schedule'));

        $component
            ->set('form.code', 'NEW-1')
            ->set('form.translations.ar.name', 'فرع')
            ->set('form.translations.en.name', 'Branch')
            ->set('form.schedule.1.closes_at', '20:00')
            ->call('save')
            ->assertHasNoErrors();

        $branch = Branch::where('code', 'NEW-1')->firstOrFail();
        $this->assertSame(7, $branch->schedules()->count());
        $this->assertTrue((bool) $branch->schedules()->where('day_of_week', 5)->value('is_closed'));

        $monday = now()->next('Monday');
        $slots = app(\App\Services\BookingService::class)->availableSlots($branch, $monday);
        $this->assertNotEmpty($slots);
        $this->assertSame('09:00', $slots[0]['time']);
        $this->assertSame('19:30', end($slots)['time']);
    }

    public function test_branch_working_hours_reject_inverted_times(): void
    {
        $this->actingAsAdmin(['branches.view', 'branches.create']);

        Livewire::test(BranchManager::class)->call('openCreate')
            ->set('form.code', 'BAD')
            ->set('form.translations.ar.name', 'فرع')
            ->set('form.translations.en.name', 'Branch')
            ->set('form.schedule.2.opens_at', '18:00')
            ->set('form.schedule.2.closes_at', '09:00')
            ->call('save')
            ->assertHasErrors(['form.schedule.2.hours']);

        $this->assertDatabaseMissing('branches', ['code' => 'BAD']);
    }

    public function test_mail_configuration_is_read_from_database_settings(): void
    {
        foreach (['smtp_host' => 'smtp.example.test', 'smtp_port' => '2525', 'mail_from_address' => 'shop@example.test', 'mail_from_name' => 'Tire Shop'] as $k => $v) {
            Setting::updateOrCreate(['group' => 'mail', 'key' => $k], ['cast' => 'string', 'is_translatable' => false, 'value' => $v]);
        }
        Setting::updateOrCreate(['group' => 'mail', 'key' => 'mail_mailer'], ['cast' => 'string', 'is_translatable' => false, 'value' => 'smtp']);
        MailSettings::flush();

        MailSettings::apply();

        $this->assertSame('smtp', config('mail.default'));
        $this->assertSame('smtp.example.test', config('mail.mailers.smtp.host'));
        $this->assertSame(2525, config('mail.mailers.smtp.port'));
        $this->assertSame('shop@example.test', config('mail.from.address'));
        $this->assertSame('Tire Shop', config('mail.from.name'));
    }
}
