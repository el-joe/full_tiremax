<?php

namespace Database\Factories;

use App\Models\Service;
use Illuminate\Database\Eloquent\Factories\Factory;

/** @extends Factory<Service> */
class ServiceFactory extends Factory
{
    protected $model = Service::class;

    public function definition(): array
    {
        return [
            'slug' => 'service-'.fake()->unique()->numerify('#####'),
            'duration_minutes' => 30,
            'price' => 10000,
            'is_active' => true,
            'sort_order' => 0,
            'ar' => ['name' => 'خدمة '.fake()->word()],
            'en' => ['name' => 'Service '.fake()->word()],
        ];
    }
}
