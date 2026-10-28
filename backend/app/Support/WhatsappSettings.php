<?php

namespace App\Support;

use App\Models\Setting;
use Illuminate\Support\Facades\DB;

class WhatsappSettings
{
    private const DEFAULTS = ['wa_daily_limit' => 0, 'wa_hourly_limit' => 0, 'wa_min_gap' => 4, 'wa_max_gap' => 10];

    public static function get(string $key): mixed
    {
        try {
            $v = Setting::where('group', 'whatsapp')->where('key', $key)->value('value');
        } catch (\Throwable) {
            $v = null;
        }
        $default = self::DEFAULTS[$key] ?? null;

        return $v === null || $v === '' ? $default : (is_int($default) ? (int) $v : $v);
    }

    public static function set(string $key, mixed $value): void
    {
        // raw table write: Setting::value is a translated attribute, and the readers use the raw column
        $cast = is_int(self::DEFAULTS[$key] ?? null) ? 'int' : 'string';
        DB::table('settings')->updateOrInsert(['key' => $key], ['group' => 'whatsapp', 'cast' => $cast, 'is_translatable' => false, 'value' => (string) $value, 'updated_at' => now()]);
        \App\Services\PublicSettings::flush();
    }
}
