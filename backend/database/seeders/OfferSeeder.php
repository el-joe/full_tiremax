<?php

namespace Database\Seeders;

use App\Models\Offer;
use Illuminate\Database\Seeder;

class OfferSeeder extends Seeder
{
    public function run(): void
    {
        $offers = [
            [
                'code' => 'WELCOME10',
                'discount_type' => 'percent',
                'discount_value' => 10,
                'min_subtotal' => 50000,
                'usage_limit' => null,
                'starts_at' => now()->subMonths(1),
                'ends_at' => now()->addMonths(6),
                'is_active' => true,
                'en' => ['title' => 'Welcome 10% Off', 'description' => 'Get 10% off your first order. No minimum order value required on orders above 50,000 IQD.'],
                'ar' => ['title' => 'خصم ترحيبي 10٪', 'description' => 'احصل على خصم 10٪ على طلبك الأول. للطلبات فوق 50,000 دينار.'],
            ],
            [
                'code' => 'SUMMER2026',
                'discount_type' => 'fixed',
                'discount_value' => 15000,
                'min_subtotal' => 100000,
                'usage_limit' => 500,
                'starts_at' => now()->subDays(5),
                'ends_at' => now()->addMonths(3),
                'is_active' => true,
                'en' => ['title' => 'Summer 2026 Deal', 'description' => 'Save 15,000 IQD on orders over 100,000 IQD. Valid until end of summer.'],
                'ar' => ['title' => 'عرض صيف 2026', 'description' => 'وفّر 15,000 دينار على الطلبات فوق 100,000 دينار. صالح حتى نهاية الصيف.'],
            ],
            [
                'code' => 'BASRA25K',
                'discount_type' => 'fixed',
                'discount_value' => 25000,
                'min_subtotal' => 150000,
                'usage_limit' => 200,
                'starts_at' => now()->subDays(10),
                'ends_at' => now()->addMonths(2),
                'is_active' => true,
                'en' => ['title' => 'Basra Exclusive 25K', 'description' => 'Exclusive 25,000 IQD discount for Basra customers on orders above 150,000 IQD.'],
                'ar' => ['title' => 'عرض حصري البصرة 25K', 'description' => 'خصم حصري 25,000 دينار لعملاء البصرة على الطلبات فوق 150,000 دينار.'],
            ],
            [
                'code' => 'TIRE4FOR3',
                'discount_type' => 'percent',
                'discount_value' => 25,
                'min_subtotal' => 200000,
                'usage_limit' => 100,
                'starts_at' => now(),
                'ends_at' => now()->addDays(30),
                'is_active' => true,
                'en' => ['title' => 'Buy 4 Tyres — 25% Off', 'description' => 'Buy 4 tyres and get 25% off the total. Limited time offer.'],
                'ar' => ['title' => 'اشترِ 4 إطارات — خصم 25٪', 'description' => 'اشترِ 4 إطارات واحصل على خصم 25٪. عرض لفترة محدودة.'],
            ],
            [
                'code' => 'EXPIRED20',
                'discount_type' => 'percent',
                'discount_value' => 20,
                'min_subtotal' => 0,
                'usage_limit' => 50,
                'starts_at' => now()->subMonths(3),
                'ends_at' => now()->subDays(1),
                'is_active' => false,
                'en' => ['title' => 'Expired Campaign', 'description' => 'This campaign has ended.'],
                'ar' => ['title' => 'حملة منتهية', 'description' => 'انتهت هذه الحملة.'],
            ],
        ];

        foreach ($offers as $data) {
            $offer = Offer::updateOrCreate(
                ['code' => $data['code']],
                [
                    'discount_type' => $data['discount_type'],
                    'discount_value' => $data['discount_value'],
                    'min_subtotal' => $data['min_subtotal'],
                    'usage_limit' => $data['usage_limit'],
                    'used_count' => 0,
                    'starts_at' => $data['starts_at'],
                    'ends_at' => $data['ends_at'],
                    'is_active' => $data['is_active'],
                ]
            );

            $offer->translateOrNew('en')->fill($data['en']);
            $offer->translateOrNew('ar')->fill($data['ar']);
            $offer->save();
        }
    }
}
