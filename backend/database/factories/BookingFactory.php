<?php

namespace Database\Factories;

use App\Models\Booking;
use App\Models\Branch;
use App\Models\Customer;
use App\Models\Service;
use Illuminate\Database\Eloquent\Factories\Factory;

/** @extends Factory<Booking> */
class BookingFactory extends Factory
{
    protected $model = Booking::class;

    public function definition(): array
    {
        return [
            'reference' => 'BK-'.strtoupper(fake()->unique()->bothify('??####??')),
            'customer_id' => Customer::factory(),
            'branch_id' => Branch::factory(),
            'service_id' => Service::factory(),
            'scheduled_at' => now()->addDays(2)->setTime(10, 0),
            'duration_minutes' => 30,
            'status' => Booking::STATUS_PENDING,
        ];
    }

    public function guest(?string $token = null): static
    {
        return $this->state(fn () => [
            'customer_id' => null,
            'is_guest' => true,
            'customer_name' => fake()->name(),
            'customer_phone' => '07'.fake()->numerify('#########'),
            'guest_token' => $token ?? \Illuminate\Support\Str::random(32),
        ]);
    }
}
