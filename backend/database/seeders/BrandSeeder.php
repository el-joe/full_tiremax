<?php

namespace Database\Seeders;

use App\Models\Brand;
use Illuminate\Database\Seeder;
use Illuminate\Support\Str;

class BrandSeeder extends Seeder
{
    public function run(): void
    {
        $brands = [
            ['en' => 'Michelin', 'ar' => 'ميشلان', 'country' => 'France'],
            ['en' => 'Bridgestone', 'ar' => 'بريدجستون', 'country' => 'Japan'],
            ['en' => 'Continental', 'ar' => 'كونتيننتال', 'country' => 'Germany'],
            ['en' => 'Pirelli', 'ar' => 'بيريلي', 'country' => 'Italy'],
            ['en' => 'Goodyear', 'ar' => 'جودير', 'country' => 'USA'],
            ['en' => 'Dunlop', 'ar' => 'دانلوب', 'country' => 'UK'],
            ['en' => 'Yokohama', 'ar' => 'يوكوهاما', 'country' => 'Japan'],
            ['en' => 'Hankook', 'ar' => 'هانكوك', 'country' => 'South Korea'],
            ['en' => 'Kumho', 'ar' => 'كومهو', 'country' => 'South Korea'],
            ['en' => 'Toyo', 'ar' => 'تويو', 'country' => 'Japan'],
            ['en' => 'Falken', 'ar' => 'فالكين', 'country' => 'Japan'],
            ['en' => 'Maxxis', 'ar' => 'ماكسيس', 'country' => 'Taiwan'],
            ['en' => 'Varta', 'ar' => 'فارتا', 'country' => 'Germany'],
            ['en' => 'Bosch', 'ar' => 'بوش', 'country' => 'Germany'],
        ];

        foreach ($brands as $i => $b) {
            $brand = Brand::updateOrCreate(
                ['slug' => Str::slug($b['en'])],
                ['country' => $b['country'], 'is_active' => true, 'sort_order' => $i]
            );
            $brand->translateOrNew('en')->name = $b['en'];
            $brand->translateOrNew('ar')->name = $b['ar'];
            $brand->save();
        }
    }
}
