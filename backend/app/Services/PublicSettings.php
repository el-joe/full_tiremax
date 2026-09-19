<?php

namespace App\Services;

use App\Models\Setting;
use App\Support\Phone;
use Illuminate\Support\Facades\Cache;

class PublicSettings
{
    private const LOCALES = ['ar', 'en'];
    private const PLAIN = ['site_email', 'site_phone', 'whatsapp_number'];
    private const TRANSLATED = ['site_name', 'site_tagline', 'address', 'whatsapp_default_message'];
    private const SOCIAL = ['instagram', 'facebook', 'tiktok', 'snapchat', 'youtube'];

    public static function get(string $locale): array
    {
        $locale = in_array($locale, self::LOCALES, true) ? $locale : 'en';

        return Cache::remember("public_settings.$locale", 60, fn () => self::build($locale));
    }

    public static function flush(): void
    {
        foreach (self::LOCALES as $l) {
            Cache::forget("public_settings.$l");
        }
    }

    private static function build(string $locale): array
    {
        $rows = Setting::with('translations')
            ->whereIn('key', array_merge(self::PLAIN, self::TRANSLATED, self::SOCIAL, ['whatsapp_button_enabled']))
            ->whereIn('group', ['general', 'social'])
            ->get()->keyBy('key');

        $val = fn (string $k) => $rows->get($k)?->getTypedValue($locale);

        $out = [];
        foreach (array_merge(self::TRANSLATED, self::PLAIN) as $k) {
            $out[$k] = $val($k);
        }
        $out['social'] = [];
        foreach (self::SOCIAL as $k) {
            $out['social'][$k] = $val($k) ?: null;
        }

        $digits = Phone::normalize($out['whatsapp_number']);
        $msg = (string) ($out['whatsapp_default_message'] ?? '');
        $out['whatsapp_url'] = $digits ? 'https://wa.me/' . $digits . ($msg !== '' ? '?text=' . rawurlencode($msg) : '') : null;
        $out['whatsapp_url_fallback'] = $digits ? 'https://api.whatsapp.com/send?phone=' . $digits . ($msg !== '' ? '&text=' . rawurlencode($msg) : '') : null;
        $out['whatsapp_button_enabled'] = (bool) ($val('whatsapp_button_enabled') ?? true);

        return $out;
    }
}
