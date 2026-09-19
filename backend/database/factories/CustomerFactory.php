<?php

namespace Database\Factories;

use App\Models\Customer;
use Illuminate\Database\Eloquent\Factories\Factory;
use Illuminate\Support\Facades\Hash;

/** @extends Factory<Customer> */
class CustomerFactory extends Factory
{
    protected $model = Customer::class;
    protected static ?string $password;

    public function definition(): array
    {
        return [
            'name' => fake()->name(),
            'email' => fake()->unique()->safeEmail(),
            'phone' => '07'.fake()->unique()->numerify('#########'),
            'password' => static::$password ??= Hash::make('password'),
            'locale' => 'ar',
            'is_active' => true,
            'is_banned' => false,
        ];
    }

    public function banned(): static
    {
        return $this->state(fn () => ['is_banned' => true]);
    }

    public function inactive(): static
    {
        return $this->state(fn () => ['is_active' => false]);
    }
}
