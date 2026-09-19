<?php

namespace Tests\Feature\Admin;

use App\Models\Booking;
use App\Models\Order;
use App\Models\Product;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Tests\TestCase;

class ActingAsAdminTest extends TestCase
{
    use RefreshDatabase, ActingAsAdmin;

    public function test_helper_creates_admin_with_permissions(): void
    {
        $admin = $this->actingAsAdmin(['orders.view']);

        $this->assertAuthenticatedAs($admin, 'admin');
        $this->assertTrue($admin->can('orders.view'));
        $this->assertFalse($admin->can('orders.delete'));
    }

    public function test_factories_produce_valid_records(): void
    {
        $this->assertNotNull(Product::factory()->create()->id);
        $this->assertNotNull(Order::factory()->create()->id);
        $this->assertNotNull(Booking::factory()->create()->id);
    }
}
