<?php

namespace Database\Seeders;

use App\Models\City;
use App\Models\Governorate;
use Illuminate\Database\Seeder;

class CitySeeder extends Seeder
{
    public function run(): void
    {
        $cities = [
            'BAS' => [
                ['البصرة', 'Basra'],
                ['أبو الخصيب', 'Abu Al-Khasib'],
                ['الفاو', 'Al-Faw'],
                ['القرنة', 'Al-Qurna'],
                ['شط العرب', 'Shatt Al-Arab'],
                ['الزبير', 'Al-Zubair'],
                ['المدينة', 'Al-Medina'],
                ['أم قصر', 'Umm Qasr'],
                ['الهارثة', 'Al-Hartha'],
                ['الدير', 'Al-Dayr'],
                ['قضاء الدير', 'Qadha Al-Dayr'],
            ],
            'BGD' => [
                ['الكرخ', 'Karkh'],
                ['الرصافة', 'Rusafa'],
                ['الأعظمية', 'Al-Adhamiyah'],
                ['الكاظمية', 'Al-Kadhimiyah'],
                ['المنصور', 'Al-Mansour'],
                ['الكرادة', 'Al-Karada'],
                ['الدورة', 'Al-Dawra'],
                ['الشعب', 'Al-Shaab'],
                ['الزعفرانية', 'Al-Zafaraniyah'],
                ['سيدية', 'Saydiyah'],
                ['المحمودية', 'Al-Mahmudiyah'],
                ['الطارمية', 'Al-Tarmiyah'],
                ['المدائن', 'Al-Madain'],
                ['أبو غريب', 'Abu Ghraib'],
                ['الصدر', 'Sadr City'],
            ],
            'NJF' => [
                ['النجف', 'Najaf'],
                ['الكوفة', 'Al-Kufa'],
                ['المناذرة', 'Al-Manathira'],
                ['أبو صخير', 'Abu Sukhair'],
            ],
            'KAR' => [
                ['كربلاء', 'Karbala'],
                ['الهندية', 'Al-Hindiyah'],
                ['عين التمر', 'Ain Al-Tamur'],
            ],
            'DHQ' => [
                ['الناصرية', 'Al-Nasiriyah'],
                ['سوق الشيوخ', 'Suq Al-Shuyukh'],
                ['الرفاعي', 'Al-Rifai'],
                ['الشطرة', 'Al-Shatra'],
                ['الجبايش', 'Al-Jubaish'],
                ['قلعة سكر', 'Qalat Sukkar'],
            ],
            'MUT' => [
                ['السماوة', 'Al-Samawah'],
                ['الرميثة', 'Al-Rumaitha'],
                ['الخضر', 'Al-Khidhir'],
            ],
            'MYS' => [
                ['العمارة', 'Al-Amarah'],
                ['علي الغربي', 'Ali Al-Gharbi'],
                ['قلعة صالح', 'Qalat Salih'],
                ['المجر الكبير', 'Al-Maimouna'],
            ],
            'WAS' => [
                ['الكوت', 'Al-Kut'],
                ['الحي', 'Al-Hayy'],
                ['النعمانية', 'Al-Numaniyah'],
                ['بدرة', 'Badra'],
            ],
            'BAB' => [
                ['الحلة', 'Al-Hillah'],
                ['المحاويل', 'Al-Mahawil'],
                ['الإسكندرية', 'Al-Iskandariyah'],
                ['المسيب', 'Al-Musayyib'],
            ],
            'QAD' => [
                ['الديوانية', 'Al-Diwaniyah'],
                ['عفك', 'Afak'],
                ['الشامية', 'Al-Shamiyah'],
                ['الغماس', 'Al-Ghammas'],
            ],
            'DIY' => [
                ['بعقوبة', 'Baquba'],
                ['المقدادية', 'Al-Muqdadiyah'],
                ['خانقين', 'Khanaqin'],
                ['بلدروز', 'Baladruz'],
                ['قره تبة', 'Qara Tapa'],
            ],
            'ANB' => [
                ['الرمادي', 'Ramadi'],
                ['الفلوجة', 'Fallujah'],
                ['هيت', 'Hit'],
                ['حديثة', 'Haditha'],
                ['القائم', 'Al-Qaim'],
                ['عنة', 'Ana'],
                ['راوة', 'Rawa'],
            ],
            'SAL' => [
                ['تكريت', 'Tikrit'],
                ['سامراء', 'Samarra'],
                ['بيجي', 'Baiji'],
                ['الدور', 'Al-Dawr'],
                ['الشرقاط', 'Al-Shirqat'],
                ['توز خرماتو', 'Tooz Khurmatu'],
            ],
            'NIN' => [
                ['الموصل', 'Mosul'],
                ['تلعفر', 'Tal Afar'],
                ['سنجار', 'Sinjar'],
                ['الحضر', 'Al-Hadr'],
                ['مخمور', 'Makhmur'],
                ['بعشيقة', 'Bashiqa'],
            ],
            'KIR' => [
                ['كركوك', 'Kirkuk'],
                ['الحويجة', 'Al-Hawija'],
                ['داقوق', 'Daquq'],
                ['دبس', 'Dibis'],
            ],
            'ERB' => [
                ['أربيل', 'Erbil'],
                ['شقلاوة', 'Shaqlawa'],
                ['رانية', 'Rania'],
                ['سوران', 'Soran'],
                ['كويسنجق', 'Koisanjaq'],
                ['مخمور', 'Makhmur'],
            ],
            'SUL' => [
                ['السليمانية', 'Sulaymaniyah'],
                ['حلبجة', 'Halabja'],
                ['شهرزور', 'Shahrazur'],
                ['دوكان', 'Dokan'],
                ['كفري', 'Kifri'],
                ['جمجمال', 'Chamchamal'],
            ],
            'DUH' => [
                ['دهوك', 'Duhok'],
                ['زاخو', 'Zakho'],
                ['عقرة', 'Aqrah'],
                ['أمدية', 'Amadiyah'],
                ['سيميل', 'Simele'],
            ],
        ];

        foreach ($cities as $code => $list) {
            $gov = Governorate::where('code', $code)->first();
            if (!$gov) continue;

            foreach ($list as $i => [$ar, $en]) {
                City::updateOrCreate(
                    ['governorate_id' => $gov->id, 'name_en' => $en],
                    ['name_ar' => $ar, 'is_active' => true, 'sort_order' => $i]
                );
            }
        }
    }
}
