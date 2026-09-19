<?php

namespace Database\Factories;

use App\Models\Customer;
use App\Models\Order;
use Illuminate\Database\Eloquent\Factories\Factory;

/** @extends Factory<Order> */
class OrderFactory extends Factory
{
    protected $model = Order::class;

    public function definition(): array
    {
        return [
            'reference' => 'ORD-'.strtoupper(fake()->unique()->bothify('??####??')),
            'customer_id' => Customer::factory(),
            'type' => 'basra',
            'status' => 'pending',
            'payment_method' => 'cod',
            'payment_status' => 'pending',
            'subtotal' => 100000,
            'discount' => 0,
            'shipping_fee' => 0,
            'installation_fee' => 0,
            'total' => 100000,
            'customer_name' => fake()->name(),
            'customer_phone' => '07'.fake()->numerify('#########'),
            'customer_email' => fake()->safeEmail(),
            'placed_at' => now(),
        ];
    }

    public function guest(?string $token = null): static
    {
        return $this->state(fn () => [
            'customer_id' => null,
            'is_guest' => true,
            'guest_token' => $token ?? \Illuminate\Support\Str::random(32),
        ]);
    }
}
