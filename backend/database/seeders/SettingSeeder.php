<?php

namespace Database\Seeders;

use App\Models\Setting;
use Illuminate\Database\Seeder;

class SettingSeeder extends Seeder
{
    public function run(): void
    {
        $settings = [

            // ── General ──────────────────────────────────────────────────
            [
                'group' => 'general',
                'key' => 'site_name',
                'cast' => 'string',
                'translatable' => true,
                'en' => 'Iraq Max Tire',
                'ar' => 'إيراق ماكس تاير'
            ],

            [
                'group' => 'general',
                'key' => 'site_tagline',
                'cast' => 'string',
                'translatable' => true,
                'en' => 'Best Tyres & Batteries in Iraq',
                'ar' => 'أفضل الإطارات والبطاريات في العراق'
            ],

            [
                'group' => 'general',
                'key' => 'site_email',
                'cast' => 'string',
                'translatable' => false,
                'value' => 'info@iraqmaxtire.iq'
            ],

            [
                'group' => 'general',
                'key' => 'site_phone',
                'cast' => 'string',
                'translatable' => false,
                'value' => '+9647700000001'
            ],

            [
                'group' => 'general',
                'key' => 'whatsapp_number',
                'cast' => 'string',
                'translatable' => false,
                'value' => '+9647700000001'
            ],

            [
                'group' => 'general',
                'key' => 'address',
                'cast' => 'string',
                'translatable' => true,
                'en' => 'Basra, Corniche Street, Iraq',
                'ar' => 'البصرة، شارع الكورنيش، العراق'
            ],

            [
                'group' => 'general',
                'key' => 'about',
                'cast' => 'string',
                'translatable' => true,
                'en' => 'Iraq Max Tire is Basra\'s leading tyre and battery specialist, serving customers across all of Iraq with premium brands and expert installation.',
                'ar' => 'إيراق ماكس تاير هو المتخصص الرائد في الإطارات والبطاريات في البصرة، يخدم العملاء في جميع أنحاء العراق بعلامات تجارية مميزة وتركيب احترافي.'
            ],

            [
                'group' => 'general',
                'key' => 'logo',
                'cast' => 'string',
                'translatable' => false,
                'value' => null
            ],

            [
                'group' => 'general',
                'key' => 'favicon',
                'cast' => 'string',
                'translatable' => false,
                'value' => null
            ],

            // ── Shipping ──────────────────────────────────────────────────
            [
                'group' => 'shipping',
                'key' => 'free_shipping_above',
                'cast' => 'int',
                'translatable' => false,
                'value' => '300000'
            ],

            [
                'group' => 'shipping',
                'key' => 'cod_available',
                'cast' => 'bool',
                'translatable' => false,
                'value' => '1'
            ],

            [
                'group' => 'shipping',
                'key' => 'installation_fee',
                'cast' => 'int',
                'translatable' => false,
                'value' => '0'
            ],

            [
                'group' => 'shipping',
                'key' => 'max_delivery_days',
                'cast' => 'int',
                'translatable' => false,
                'value' => '5'
            ],

            // ── Social ────────────────────────────────────────────────────
            [
                'group' => 'social',
                'key' => 'instagram',
                'cast' => 'string',
                'translatable' => false,
                'value' => 'https://instagram.com/iraqmaxtire'
            ],

            [
                'group' => 'social',
                'key' => 'facebook',
                'cast' => 'string',
                'translatable' => false,
                'value' => 'https://facebook.com/iraqmaxtire'
            ],

            [
                'group' => 'social',
                'key' => 'tiktok',
                'cast' => 'string',
                'translatable' => false,
                'value' => 'https://tiktok.com/@iraqmaxtire'
            ],

            [
                'group' => 'social',
                'key' => 'snapchat',
                'cast' => 'string',
                'translatable' => false,
                'value' => null
            ],

            [
                'group' => 'social',
                'key' => 'youtube',
                'cast' => 'string',
                'translatable' => false,
                'value' => null
            ],

            // ── SEO ───────────────────────────────────────────────────────
            [
                'group' => 'seo',
                'key' => 'meta_title',
                'cast' => 'string',
                'translatable' => true,
                'en' => 'Iraq Max Tire — Premium Tyres & Batteries | Basra Iraq',
                'ar' => 'إيراق ماكس تاير — إطارات وبطاريات ممتازة | البصرة العراق'
            ],

            [
                'group' => 'seo',
                'key' => 'meta_description',
                'cast' => 'string',
                'translatable' => true,
                'en' => 'Buy premium tyres and batteries online. Michelin, Bridgestone, Continental, Varta, Bosch. Fast delivery across Iraq. Expert installation in Basra.',
                'ar' => 'اشترِ إطارات وبطاريات ممتازة عبر الإنترنت. ميشلان، بريدجستون، كونتيننتال، فارتا، بوش. توصيل سريع في جميع أنحاء العراق. تركيب احترافي في البصرة.'
            ],

            [
                'group' => 'seo',
                'key' => 'og_image',
                'cast' => 'string',
                'translatable' => false,
                'value' => null
            ],

            // ── WhatsApp API ──────────────────────────────────────────────
            [
                'group' => 'whatsapp',
                'key' => 'api_url',
                'cast' => 'string',
                'translatable' => false,
                'value' => null
            ],

            [
                'group' => 'whatsapp',
                'key' => 'api_token',
                'cast' => 'string',
                'translatable' => false,
                'value' => null
            ],

            [
                'group' => 'whatsapp',
                'key' => 'from_number',
                'cast' => 'string',
                'translatable' => false,
                'value' => null
            ],

            [
                'group' => 'whatsapp',
                'key' => 'enabled',
                'cast' => 'bool',
                'translatable' => false,
                'value' => '0'
            ],

            // ── Daftra ERP ────────────────────────────────────────────────
            [
                'group' => 'daftra',
                'key' => 'api_url',
                'cast' => 'string',
                'translatable' => false,
                'value' => null
            ],

            [
                'group' => 'daftra',
                'key' => 'api_key',
                'cast' => 'string',
                'translatable' => false,
                'value' => null
            ],

            [
                'group' => 'daftra',
                'key' => 'account_hash',
                'cast' => 'string',
                'translatable' => false,
                'value' => null
            ],

            [
                'group' => 'daftra',
                'key' => 'enabled',
                'cast' => 'bool',
                'translatable' => false,
                'value' => '0'
            ],

            // ── Products ──────────────────────────────────────────────────
            [
                'group' => 'products',
                'key' => 'home_featured_limit',
                'cast' => 'int',
                'translatable' => false,
                'value' => '8'
            ],

            [
                'group' => 'products',
                'key' => 'per_page',
                'cast' => 'int',
                'translatable' => false,
                'value' => '20'
            ],

            [
                'group' => 'products',
                'key' => 'low_stock_alert',
                'cast' => 'bool',
                'translatable' => false,
                'value' => '1'
            ],

            // ── Maintenance ──────────────────────────────────────────────
            [
                'group' => 'maintenance',
                'key' => 'enabled',
                'cast' => 'bool',
                'translatable' => false,
                'value' => '0'
            ],

            [
                'group' => 'maintenance',
                'key' => 'message',
                'cast' => 'string',
                'translatable' => true,
                'en' => 'We are performing scheduled maintenance. We\'ll be back shortly.',
                'ar' => 'نقوم بصيانة مجدولة. سنعود قريباً.'
            ],
        ];

        foreach ($settings as $data) {
            $setting = Setting::updateOrCreate(
                ['key' => $data['key']],
                [
                    'group' => $data['group'],
                    'cast' => $data['cast'],
                    'is_translatable' => $data['translatable'],
                    'value' => $data['translatable'] ? null : ($data['value'] ?? null),
                ]
            );

            if ($data['translatable']) {
                $setting->translateOrNew('en')->value = $data['en'];
                $setting->translateOrNew('ar')->value = $data['ar'];
                $setting->save();
            }
        }
    }
}
