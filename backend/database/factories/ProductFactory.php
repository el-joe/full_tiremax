<?php

namespace Database\Factories;

use App\Models\Brand;
use App\Models\Product;
use Illuminate\Database\Eloquent\Factories\Factory;

/** @extends Factory<Product> */
class ProductFactory extends Factory
{
    protected $model = Product::class;

    public function definition(): array
    {
        return [
            'type' => 'tire',
            'sku' => 'SKU-'.fake()->unique()->numerify('######'),
            'brand_id' => fn () => Brand::create([
                'slug' => 'brand-'.fake()->unique()->numerify('#####'),
                'is_active' => true,
                'ar' => ['name' => 'ماركة'],
                'en' => ['name' => 'Brand'],
            ])->id,
            'price' => 100000,
            'stock' => 20,
            'low_stock_threshold' => 5,
            'is_active' => true,
            'is_featured' => false,
            'ar' => ['name' => 'إطار '.fake()->word()],
            'en' => ['name' => 'Tire '.fake()->word()],
        ];
    }

    public function battery(): static
    {
        return $this->state(fn () => ['type' => 'battery']);
    }

    public function outOfStock(): static
    {
        return $this->state(fn () => ['stock' => 0]);
    }

    public function onSale(): static
    {
        return $this->state(fn (array $a) => ['sale_price' => $a['price'] * 0.8]);
    }
}
