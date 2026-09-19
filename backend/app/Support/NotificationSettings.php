<?php

namespace App\Support;

use App\Models\Setting;

class NotificationSettings
{
    public static function emailEnabled(): bool
    {
        return self::flag('email_enabled');
    }

    public static function whatsappEnabled(): bool
    {
        return self::flag('whatsapp_enabled');
    }

    private static function flag(string $key): bool
    {
        try {
            $v = Setting::where('group', 'notifications')->where('key', $key)->value('value');
        } catch (\Throwable) {
            return true;
        }
        return $v === null ? true : filter_var($v, FILTER_VALIDATE_BOOLEAN);
    }

    /** Apply from address/name from the general settings (falls back to .env values). */
    public static function applyMailFrom(): void
    {
        try {
            $email = Setting::where('group', 'general')->where('key', 'site_email')->value('value');
            $name = Setting::where('group', 'general')->where('key', 'site_name')->first()?->translate('en')?->value
                ?? Setting::where('group', 'general')->where('key', 'site_name')->value('value');
        } catch (\Throwable) {
            return;
        }
        if ($email && filter_var($email, FILTER_VALIDATE_EMAIL)) {
            config(['mail.from.address' => $email]);
        }
        if ($name) {
            config(['mail.from.name' => $name]);
        }
    }
}
