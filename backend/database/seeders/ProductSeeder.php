<?php

namespace Database\Seeders;

use App\Models\Brand;
use App\Models\Category;
use App\Models\BatterySpec;
use App\Models\Product;
use App\Models\ProductBadge;
use App\Models\TireSpec;
use Illuminate\Database\Seeder;

class ProductSeeder extends Seeder
{
    public function run(): void
    {
        // ── Brand & category lookups ──────────────────────────────────────
        $brands = Brand::all()->keyBy('slug');
        $cats = Category::all()->keyBy('slug');

        // ── Tires ─────────────────────────────────────────────────────────
        $tires = [
            // ---- 195/65R15 compact sedan ----
            [
                'sku' => 'BRG-TUR-T005-195-65-15',
                'brand' => 'bridgestone',
                'category' => 'summer-tires',
                'price' => 62000,
                'sale_price' => null,
                'cost' => 38000,
                'stock' => 60,
                'mfr_year' => 2025,
                'mfr_warranty' => 0,
                'agency_warranty' => 12,
                'expert_rating' => 4.5,
                'featured' => true,
                'badges' => ['best_seller'],
                'en' => ['name' => 'Bridgestone Turanza T005', 'short_description' => 'Premium summer tyre for sedans', 'pattern_name' => 'Turanza T005'],
                'ar' => ['name' => 'بريدجستون تورانزا T005', 'short_description' => 'إطار صيفي ممتاز للسيارات السيدان', 'pattern_name' => 'تورانزا T005'],
                'spec' => ['width' => 195, 'aspect_ratio' => 65, 'rim_diameter' => 15, 'load_index' => '91H', 'speed_rating' => 'H', 'usage_type' => 'comfort', 'runflat' => false],
            ],
            [
                'sku' => 'GDY-EGP2-195-65-15',
                'brand' => 'goodyear',
                'category' => 'summer-tires',
                'price' => 56000,
                'sale_price' => 49000,
                'cost' => 33000,
                'stock' => 48,
                'mfr_year' => 2025,
                'mfr_warranty' => 0,
                'agency_warranty' => 12,
                'expert_rating' => 4.3,
                'featured' => false,
                'badges' => ['special_offer'],
                'en' => ['name' => 'Goodyear EfficientGrip Performance 2', 'short_description' => 'Fuel-efficient summer tyre', 'pattern_name' => 'EfficientGrip 2'],
                'ar' => ['name' => 'جودير إيفيشينت غريب 2', 'short_description' => 'إطار صيفي موفر للوقود', 'pattern_name' => 'إيفيشينت غريب 2'],
                'spec' => ['width' => 195, 'aspect_ratio' => 65, 'rim_diameter' => 15, 'load_index' => '91V', 'speed_rating' => 'V', 'usage_type' => 'comfort', 'runflat' => false],
            ],
            [
                'sku' => 'HNK-KE2-195-65-15',
                'brand' => 'hankook',
                'category' => 'summer-tires',
                'price' => 40000,
                'sale_price' => null,
                'cost' => 23000,
                'stock' => 80,
                'mfr_year' => 2024,
                'mfr_warranty' => 0,
                'agency_warranty' => 12,
                'expert_rating' => 4.1,
                'featured' => false,
                'badges' => [],
                'en' => ['name' => 'Hankook Kinergy Eco2 K435', 'short_description' => 'Eco-friendly budget tyre', 'pattern_name' => 'Kinergy Eco2'],
                'ar' => ['name' => 'هانكوك كينيرجي إيكو 2', 'short_description' => 'إطار اقتصادي صديق للبيئة', 'pattern_name' => 'كينيرجي إيكو 2'],
                'spec' => ['width' => 195, 'aspect_ratio' => 65, 'rim_diameter' => 15, 'load_index' => '91T', 'speed_rating' => 'T', 'usage_type' => 'comfort', 'runflat' => false],
            ],
            // ---- 205/55R16 mid-size sedan ----
            [
                'sku' => 'MCH-PRI4-205-55-16',
                'brand' => 'michelin',
                'category' => 'summer-tires',
                'price' => 88000,
                'sale_price' => null,
                'cost' => 54000,
                'stock' => 40,
                'mfr_year' => 2025,
                'mfr_warranty' => 0,
                'agency_warranty' => 24,
                'expert_rating' => 4.8,
                'featured' => true,
                'badges' => ['best_seller', 'best_choice'],
                'en' => ['name' => 'Michelin Primacy 4', 'short_description' => 'Premium all-season comfort tyre', 'pattern_name' => 'Primacy 4'],
                'ar' => ['name' => 'ميشلان برايمسي 4', 'short_description' => 'إطار مريح ممتاز لجميع المواسم', 'pattern_name' => 'برايمسي 4'],
                'spec' => ['width' => 205, 'aspect_ratio' => 55, 'rim_diameter' => 16, 'load_index' => '91V', 'speed_rating' => 'V', 'usage_type' => 'comfort', 'runflat' => false],
            ],
            [
                'sku' => 'CNT-PC6-205-55-16',
                'brand' => 'continental',
                'category' => 'summer-tires',
                'price' => 85000,
                'sale_price' => null,
                'cost' => 52000,
                'stock' => 36,
                'mfr_year' => 2025,
                'mfr_warranty' => 0,
                'agency_warranty' => 24,
                'expert_rating' => 4.7,
                'featured' => true,
                'badges' => ['best_choice'],
                'en' => ['name' => 'Continental PremiumContact 6', 'short_description' => 'Outstanding wet-road grip', 'pattern_name' => 'PremiumContact 6'],
                'ar' => ['name' => 'كونتيننتال بريميوم كونتاكت 6', 'short_description' => 'قدرة استثنائية على الطرق المبتلة', 'pattern_name' => 'بريميوم كونتاكت 6'],
                'spec' => ['width' => 205, 'aspect_ratio' => 55, 'rim_diameter' => 16, 'load_index' => '91W', 'speed_rating' => 'W', 'usage_type' => 'comfort', 'runflat' => false],
            ],
            [
                'sku' => 'PIR-CP7-205-55-16',
                'brand' => 'pirelli',
                'category' => 'summer-tires',
                'price' => 78000,
                'sale_price' => null,
                'cost' => 47000,
                'stock' => 30,
                'mfr_year' => 2024,
                'mfr_warranty' => 0,
                'agency_warranty' => 12,
                'expert_rating' => 4.6,
                'featured' => false,
                'badges' => [],
                'en' => ['name' => 'Pirelli Cinturato P7', 'short_description' => 'Sporty comfort tyre', 'pattern_name' => 'Cinturato P7'],
                'ar' => ['name' => 'بيريلي سينتوراتو P7', 'short_description' => 'إطار مريح رياضي', 'pattern_name' => 'سينتوراتو P7'],
                'spec' => ['width' => 205, 'aspect_ratio' => 55, 'rim_diameter' => 16, 'load_index' => '91W', 'speed_rating' => 'W', 'usage_type' => 'comfort', 'runflat' => false],
            ],
            // ---- 225/45R17 sport sedan ----
            [
                'sku' => 'MCH-PS4-225-45-17',
                'brand' => 'michelin',
                'category' => 'summer-tires',
                'price' => 115000,
                'sale_price' => null,
                'cost' => 72000,
                'stock' => 24,
                'mfr_year' => 2025,
                'mfr_warranty' => 0,
                'agency_warranty' => 24,
                'expert_rating' => 4.9,
                'featured' => true,
                'badges' => ['best_seller', 'best_choice'],
                'en' => ['name' => 'Michelin Pilot Sport 4', 'short_description' => 'High-performance sport tyre', 'pattern_name' => 'Pilot Sport 4'],
                'ar' => ['name' => 'ميشلان بايلوت سبورت 4', 'short_description' => 'إطار رياضي عالي الأداء', 'pattern_name' => 'بايلوت سبورت 4'],
                'spec' => ['width' => 225, 'aspect_ratio' => 45, 'rim_diameter' => 17, 'load_index' => '91Y', 'speed_rating' => 'Y', 'usage_type' => 'sport', 'runflat' => false],
            ],
            [
                'sku' => 'KUM-PS71-225-45-17',
                'brand' => 'kumho',
                'category' => 'summer-tires',
                'price' => 55000,
                'sale_price' => 48000,
                'cost' => 31000,
                'stock' => 32,
                'mfr_year' => 2024,
                'mfr_warranty' => 0,
                'agency_warranty' => 12,
                'expert_rating' => 4.2,
                'featured' => false,
                'badges' => ['special_offer'],
                'en' => ['name' => 'Kumho Ecsta PS71', 'short_description' => 'Value sport tyre', 'pattern_name' => 'Ecsta PS71'],
                'ar' => ['name' => 'كومهو إيكستا PS71', 'short_description' => 'إطار رياضي بسعر مناسب', 'pattern_name' => 'إيكستا PS71'],
                'spec' => ['width' => 225, 'aspect_ratio' => 45, 'rim_diameter' => 17, 'load_index' => '91W', 'speed_rating' => 'W', 'usage_type' => 'sport', 'runflat' => false],
            ],
            // ---- 265/65R17 SUV ----
            [
                'sku' => 'CNT-CCLX2-265-65-17',
                'brand' => 'continental',
                'category' => 'off-road-tires',
                'price' => 105000,
                'sale_price' => null,
                'cost' => 64000,
                'stock' => 20,
                'mfr_year' => 2025,
                'mfr_warranty' => 0,
                'agency_warranty' => 24,
                'expert_rating' => 4.6,
                'featured' => true,
                'badges' => ['best_choice'],
                'en' => ['name' => 'Continental CrossContact LX2', 'short_description' => 'SUV all-terrain tyre', 'pattern_name' => 'CrossContact LX2'],
                'ar' => ['name' => 'كونتيننتال كروس كونتاكت LX2', 'short_description' => 'إطار SUV لجميع التضاريس', 'pattern_name' => 'كروس كونتاكت LX2'],
                'spec' => ['width' => 265, 'aspect_ratio' => 65, 'rim_diameter' => 17, 'load_index' => '116H', 'speed_rating' => 'H', 'usage_type' => 'off-road', 'runflat' => false],
            ],
            [
                'sku' => 'TOY-OPAT3-265-65-17',
                'brand' => 'toyo',
                'category' => 'off-road-tires',
                'price' => 92000,
                'sale_price' => null,
                'cost' => 56000,
                'stock' => 18,
                'mfr_year' => 2024,
                'mfr_warranty' => 0,
                'agency_warranty' => 12,
                'expert_rating' => 4.5,
                'featured' => false,
                'badges' => [],
                'en' => ['name' => 'Toyo Open Country A/T III', 'short_description' => 'All-terrain SUV tyre', 'pattern_name' => 'Open Country AT3'],
                'ar' => ['name' => 'تويو أوبن كانتري AT III', 'short_description' => 'إطار SUV متعدد التضاريس', 'pattern_name' => 'أوبن كانتري AT3'],
                'spec' => ['width' => 265, 'aspect_ratio' => 65, 'rim_diameter' => 17, 'load_index' => '116T', 'speed_rating' => 'T', 'usage_type' => 'off-road', 'runflat' => false],
            ],
            // ---- 175/65R14 economy ----
            [
                'sku' => 'YOK-BEES32-175-65-14',
                'brand' => 'yokohama',
                'category' => 'summer-tires',
                'price' => 36000,
                'sale_price' => null,
                'cost' => 21000,
                'stock' => 100,
                'mfr_year' => 2024,
                'mfr_warranty' => 0,
                'agency_warranty' => 12,
                'expert_rating' => 4.0,
                'featured' => false,
                'badges' => [],
                'en' => ['name' => 'Yokohama BluEarth-ES ES32', 'short_description' => 'Eco-comfort budget tyre', 'pattern_name' => 'BluEarth ES32'],
                'ar' => ['name' => 'يوكوهاما بلو إيرث ES32', 'short_description' => 'إطار اقتصادي مريح', 'pattern_name' => 'بلو إيرث ES32'],
                'spec' => ['width' => 175, 'aspect_ratio' => 65, 'rim_diameter' => 14, 'load_index' => '82T', 'speed_rating' => 'T', 'usage_type' => 'comfort', 'runflat' => false],
            ],
            // ---- 285/60R18 large SUV ----
            [
                'sku' => 'MCH-LAT-285-60-18',
                'brand' => 'michelin',
                'category' => 'all-season-tires',
                'price' => 138000,
                'sale_price' => null,
                'cost' => 85000,
                'stock' => 16,
                'mfr_year' => 2025,
                'mfr_warranty' => 0,
                'agency_warranty' => 24,
                'expert_rating' => 4.7,
                'featured' => true,
                'badges' => ['best_choice'],
                'en' => ['name' => 'Michelin Latitude Tour HP', 'short_description' => 'Premium all-season SUV tyre', 'pattern_name' => 'Latitude Tour HP'],
                'ar' => ['name' => 'ميشلان لاتيتيود تور HP', 'short_description' => 'إطار SUV ممتاز لجميع المواسم', 'pattern_name' => 'لاتيتيود تور HP'],
                'spec' => ['width' => 285, 'aspect_ratio' => 60, 'rim_diameter' => 18, 'load_index' => '116V', 'speed_rating' => 'V', 'usage_type' => 'all-season', 'runflat' => false],
            ],
            // ---- 245/45R19 runflat ----
            [
                'sku' => 'CNT-SSR-245-45-19',
                'brand' => 'continental',
                'category' => 'summer-tires',
                'price' => 145000,
                'sale_price' => null,
                'cost' => 90000,
                'stock' => 12,
                'mfr_year' => 2025,
                'mfr_warranty' => 0,
                'agency_warranty' => 24,
                'expert_rating' => 4.6,
                'featured' => false,
                'badges' => ['new'],
                'en' => ['name' => 'Continental SportContact 7', 'short_description' => 'Ultra-high performance runflat tyre', 'pattern_name' => 'SportContact 7'],
                'ar' => ['name' => 'كونتيننتال سبورت كونتاكت 7', 'short_description' => 'إطار رانفلات عالي الأداء', 'pattern_name' => 'سبورت كونتاكت 7'],
                'spec' => ['width' => 245, 'aspect_ratio' => 45, 'rim_diameter' => 19, 'load_index' => '98Y', 'speed_rating' => 'Y', 'usage_type' => 'sport', 'runflat' => true],
            ],
        ];

        // ── Batteries ─────────────────────────────────────────────────────
        $batteries = [
            [
                'sku' => 'VAR-BD-D24-60',
                'brand' => 'varta',
                'category' => 'car-batteries',
                'price' => 65000,
                'sale_price' => null,
                'cost' => 40000,
                'stock' => 30,
                'mfr_year' => 2025,
                'mfr_warranty' => 12,
                'agency_warranty' => 24,
                'expert_rating' => 4.4,
                'featured' => false,
                'badges' => [],
                'en' => ['name' => 'Varta Blue Dynamic D24', 'short_description' => '60Ah standard battery for sedans'],
                'ar' => ['name' => 'فارتا بلو ديناميك D24', 'short_description' => 'بطارية 60 آمبير للسيارات السيدان'],
                'spec' => ['voltage' => 12, 'ampere_hour' => 60, 'cca' => 540, 'battery_type' => 'lead-acid', 'terminal_position' => 'R', 'size_code' => 'DIN60'],
            ],
            [
                'sku' => 'VAR-AGM-F21-80',
                'brand' => 'varta',
                'category' => 'car-batteries',
                'price' => 98000,
                'sale_price' => null,
                'cost' => 62000,
                'stock' => 20,
                'mfr_year' => 2025,
                'mfr_warranty' => 24,
                'agency_warranty' => 36,
                'expert_rating' => 4.8,
                'featured' => true,
                'badges' => ['best_seller', 'best_choice'],
                'en' => ['name' => 'Varta Silver Dynamic AGM F21', 'short_description' => '80Ah AGM battery for start-stop vehicles'],
                'ar' => ['name' => 'فارتا سيلفر ديناميك AGM F21', 'short_description' => 'بطارية AGM 80 آمبير لسيارات ستارت-ستوب'],
                'spec' => ['voltage' => 12, 'ampere_hour' => 80, 'cca' => 800, 'battery_type' => 'AGM', 'terminal_position' => 'R', 'size_code' => 'H8AGM'],
            ],
            [
                'sku' => 'BSH-S4-024-60',
                'brand' => 'bosch',
                'category' => 'car-batteries',
                'price' => 62000,
                'sale_price' => 55000,
                'cost' => 38000,
                'stock' => 35,
                'mfr_year' => 2025,
                'mfr_warranty' => 12,
                'agency_warranty' => 24,
                'expert_rating' => 4.3,
                'featured' => false,
                'badges' => ['special_offer'],
                'en' => ['name' => 'Bosch S4 Silver S4024', 'short_description' => '60Ah reliable battery'],
                'ar' => ['name' => 'بوش S4 سيلفر 024', 'short_description' => 'بطارية 60 آمبير موثوقة'],
                'spec' => ['voltage' => 12, 'ampere_hour' => 60, 'cca' => 540, 'battery_type' => 'lead-acid', 'terminal_position' => 'R', 'size_code' => 'DIN60'],
            ],
            [
                'sku' => 'BSH-S5A-08-70',
                'brand' => 'bosch',
                'category' => 'car-batteries',
                'price' => 92000,
                'sale_price' => null,
                'cost' => 58000,
                'stock' => 18,
                'mfr_year' => 2025,
                'mfr_warranty' => 24,
                'agency_warranty' => 36,
                'expert_rating' => 4.7,
                'featured' => true,
                'badges' => ['best_choice'],
                'en' => ['name' => 'Bosch S5 AGM S5A08', 'short_description' => '70Ah AGM battery — start-stop ready'],
                'ar' => ['name' => 'بوش S5 AGM S5A08', 'short_description' => 'بطارية AGM 70 آمبير - تدعم ستارت-ستوب'],
                'spec' => ['voltage' => 12, 'ampere_hour' => 70, 'cca' => 760, 'battery_type' => 'AGM', 'terminal_position' => 'R', 'size_code' => 'H6AGM'],
            ],
            [
                'sku' => 'VAR-BD-E11-74',
                'brand' => 'varta',
                'category' => 'car-batteries',
                'price' => 75000,
                'sale_price' => null,
                'cost' => 46000,
                'stock' => 25,
                'mfr_year' => 2024,
                'mfr_warranty' => 12,
                'agency_warranty' => 24,
                'expert_rating' => 4.5,
                'featured' => false,
                'badges' => [],
                'en' => ['name' => 'Varta Blue Dynamic E11', 'short_description' => '74Ah heavy-duty battery'],
                'ar' => ['name' => 'فارتا بلو ديناميك E11', 'short_description' => 'بطارية 74 آمبير للاستخدام الشاق'],
                'spec' => ['voltage' => 12, 'ampere_hour' => 74, 'cca' => 680, 'battery_type' => 'lead-acid', 'terminal_position' => 'R', 'size_code' => 'DIN74'],
            ],
            [
                'sku' => 'BSH-T7-110-TRK',
                'brand' => 'bosch',
                'category' => 'truck-batteries',
                'price' => 145000,
                'sale_price' => null,
                'cost' => 90000,
                'stock' => 10,
                'mfr_year' => 2025,
                'mfr_warranty' => 12,
                'agency_warranty' => 24,
                'expert_rating' => 4.5,
                'featured' => false,
                'badges' => [],
                'en' => ['name' => 'Bosch T7 Heavy Duty 110Ah', 'short_description' => '110Ah truck & commercial vehicle battery'],
                'ar' => ['name' => 'بوش T7 هيفي ديوتي 110 آمبير', 'short_description' => 'بطارية 110 آمبير للشاحنات والمركبات التجارية'],
                'spec' => ['voltage' => 12, 'ampere_hour' => 110, 'cca' => 900, 'battery_type' => 'lead-acid', 'terminal_position' => 'L', 'size_code' => 'DIN110'],
            ],
        ];

        // ── Seed tires ────────────────────────────────────────────────────
        foreach ($tires as $i => $t) {
            $brand = $brands->get($t['brand']);
            $category = $cats->get($t['category']);

            $product = Product::updateOrCreate(
                ['sku' => $t['sku']],
                [
                    'type' => 'tire',
                    'brand_id' => $brand?->id,
                    'category_id' => $category?->id,
                    'price' => $t['price'],
                    'sale_price' => $t['sale_price'],
                    'cost' => $t['cost'],
                    'stock' => $t['stock'],
                    'low_stock_threshold' => 5,
                    'manufacture_year' => $t['mfr_year'],
                    'manufacturer_warranty_months' => $t['mfr_warranty'],
                    'agency_warranty_months' => $t['agency_warranty'],
                    'expert_rating' => $t['expert_rating'],
                    'virtual_sales_count' => rand(20, 200),
                    'virtual_views_count' => rand(100, 1000),
                    'sort_order' => $i,
                    'is_active' => true,
                    'is_featured' => $t['featured'],
                ]
            );

            $product->translateOrNew('en')->fill($t['en']);
            $product->translateOrNew('ar')->fill($t['ar']);
            $product->save();

            TireSpec::updateOrCreate(
                ['product_id' => $product->id],
                $t['spec']
            );

            ProductBadge::where('product_id', $product->id)->delete();
            foreach ($t['badges'] as $badge) {
                ProductBadge::firstOrCreate(['product_id' => $product->id, 'badge' => $badge]);
            }
        }

        // ── Seed batteries ────────────────────────────────────────────────
        foreach ($batteries as $i => $b) {
            $brand = $brands->get($b['brand']);
            $category = $cats->get($b['category']);

            $product = Product::updateOrCreate(
                ['sku' => $b['sku']],
                [
                    'type' => 'battery',
                    'brand_id' => $brand?->id,
                    'category_id' => $category?->id,
                    'price' => $b['price'],
                    'sale_price' => $b['sale_price'],
                    'cost' => $b['cost'],
                    'stock' => $b['stock'],
                    'low_stock_threshold' => 3,
                    'manufacture_year' => $b['mfr_year'],
                    'manufacturer_warranty_months' => $b['mfr_warranty'],
                    'agency_warranty_months' => $b['agency_warranty'],
                    'expert_rating' => $b['expert_rating'],
                    'virtual_sales_count' => rand(10, 100),
                    'virtual_views_count' => rand(50, 500),
                    'sort_order' => $i,
                    'is_active' => true,
                    'is_featured' => $b['featured'],
                ]
            );

            $product->translateOrNew('en')->fill($b['en']);
            $product->translateOrNew('ar')->fill($b['ar']);
            $product->save();

            BatterySpec::updateOrCreate(
                ['product_id' => $product->id],
                $b['spec']
            );

            ProductBadge::where('product_id', $product->id)->delete();
            foreach ($b['badges'] as $badge) {
                ProductBadge::firstOrCreate(['product_id' => $product->id, 'badge' => $badge]);
            }
        }
    }
}
