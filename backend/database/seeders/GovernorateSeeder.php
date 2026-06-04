<?php

namespace Database\Seeders;

use App\Models\Governorate;
use Illuminate\Database\Seeder;

class GovernorateSeeder extends Seeder
{
    public function run(): void
    {
        $rows = [
            ['code' => 'BAS', 'is_basra' => true, 'fee' => 0, 'ar' => 'البصرة', 'en' => 'Basra'],
            ['code' => 'BGD', 'is_basra' => false, 'fee' => 25000, 'ar' => 'بغداد', 'en' => 'Baghdad'],
            ['code' => 'NJF', 'is_basra' => false, 'fee' => 20000, 'ar' => 'النجف', 'en' => 'Najaf'],
            ['code' => 'KAR', 'is_basra' => false, 'fee' => 20000, 'ar' => 'كربلاء', 'en' => 'Karbala'],
            ['code' => 'DHQ', 'is_basra' => false, 'fee' => 15000, 'ar' => 'ذي قار', 'en' => 'Dhi Qar'],
            ['code' => 'MUT', 'is_basra' => false, 'fee' => 15000, 'ar' => 'المثنى', 'en' => 'Muthanna'],
            ['code' => 'MYS', 'is_basra' => false, 'fee' => 15000, 'ar' => 'ميسان', 'en' => 'Maysan'],
            ['code' => 'WAS', 'is_basra' => false, 'fee' => 18000, 'ar' => 'واسط', 'en' => 'Wasit'],
            ['code' => 'BAB', 'is_basra' => false, 'fee' => 20000, 'ar' => 'بابل', 'en' => 'Babil'],
            ['code' => 'QAD', 'is_basra' => false, 'fee' => 20000, 'ar' => 'القادسية', 'en' => 'Qadisiyah'],
            ['code' => 'DIY', 'is_basra' => false, 'fee' => 25000, 'ar' => 'ديالى', 'en' => 'Diyala'],
            ['code' => 'ANB', 'is_basra' => false, 'fee' => 25000, 'ar' => 'الأنبار', 'en' => 'Anbar'],
            ['code' => 'SAL', 'is_basra' => false, 'fee' => 25000, 'ar' => 'صلاح الدين', 'en' => 'Salah ad-Din'],
            ['code' => 'NIN', 'is_basra' => false, 'fee' => 30000, 'ar' => 'نينوى', 'en' => 'Nineveh'],
            ['code' => 'KIR', 'is_basra' => false, 'fee' => 28000, 'ar' => 'كركوك', 'en' => 'Kirkuk'],
            ['code' => 'ERB', 'is_basra' => false, 'fee' => 30000, 'ar' => 'أربيل', 'en' => 'Erbil'],
            ['code' => 'SUL', 'is_basra' => false, 'fee' => 30000, 'ar' => 'السليمانية', 'en' => 'Sulaymaniyah'],
            ['code' => 'DUH', 'is_basra' => false, 'fee' => 32000, 'ar' => 'دهوك', 'en' => 'Duhok'],
        ];

        foreach ($rows as $i => $r) {
            $g = Governorate::updateOrCreate(
                ['code' => $r['code']],
                [
                    'is_basra' => $r['is_basra'],
                    'shipping_fee' => $r['fee'],
                    'is_active' => true,
                    'sort_order' => $i,
                ]
            );
            $g->translateOrNew('ar')->name = $r['ar'];
            $g->translateOrNew('en')->name = $r['en'];
            $g->save();
        }
    }
}
