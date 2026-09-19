<?php

namespace Database\Factories;

use App\Models\Branch;
use Illuminate\Database\Eloquent\Factories\Factory;

/** @extends Factory<Branch> */
class BranchFactory extends Factory
{
    protected $model = Branch::class;

    public function definition(): array
    {
        return [
            'code' => 'BR-'.fake()->unique()->numerify('####'),
            'phone' => '07'.fake()->numerify('#########'),
            'email' => fake()->safeEmail(),
            'is_main' => false,
            'is_active' => true,
            'default_capacity' => 2,
            'auto_confirm_bookings' => false,
            'ar' => ['name' => 'فرع '.fake()->word(), 'address' => 'البصرة'],
            'en' => ['name' => 'Branch '.fake()->word(), 'address' => 'Basra'],
        ];
    }
}
