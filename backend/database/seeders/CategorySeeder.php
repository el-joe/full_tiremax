<?php

namespace Database\Seeders;

use App\Models\Category;
use Illuminate\Database\Seeder;
use Illuminate\Support\Str;

class CategorySeeder extends Seeder
{
    public function run(): void
    {
        $rows = [
            ['type' => 'tire', 'en' => 'Summer Tires', 'ar' => 'إطارات صيفية'],
            ['type' => 'tire', 'en' => 'Winter Tires', 'ar' => 'إطارات شتوية'],
            ['type' => 'tire', 'en' => 'All-Season Tires', 'ar' => 'إطارات لكل الفصول'],
            ['type' => 'tire', 'en' => 'Off-Road Tires', 'ar' => 'إطارات الطرق الوعرة'],
            ['type' => 'battery', 'en' => 'Car Batteries', 'ar' => 'بطاريات سيارات'],
            ['type' => 'battery', 'en' => 'Truck Batteries', 'ar' => 'بطاريات شاحنات'],
        ];

        foreach ($rows as $i => $r) {
            $c = Category::updateOrCreate(
                ['slug' => Str::slug($r['en'])],
                ['product_type' => $r['type'], 'is_active' => true, 'sort_order' => $i]
            );
            $c->translateOrNew('en')->name = $r['en'];
            $c->translateOrNew('ar')->name = $r['ar'];
            $c->save();
        }
    }
}
