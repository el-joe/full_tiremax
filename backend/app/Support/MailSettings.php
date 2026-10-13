<?php

namespace App\Support;

use App\Models\Setting;
use Illuminate\Support\Facades\Cache;
use Illuminate\Support\Facades\Schema;

/**
 * Mail transport configuration managed from the admin panel (settings group "mail").
 * Values stored in the database override whatever is in .env; any key left empty
 * falls back to the config/.env default.
 */
class MailSettings
{
    private const CACHE_KEY = 'mail_settings';

    public static function apply(): void
    {
        try {
            $s = self::load();
        } catch (\Throwable) {
            return; // DB not ready (fresh install / migrating): keep .env defaults
        }

        $mailer = $s['mail_mailer'] ?? null;
        if ($mailer && array_key_exists($mailer, config('mail.mailers', []))) {
            config(['mail.default' => $mailer]);
        }

        foreach (['host' => 'smtp_host', 'port' => 'smtp_port', 'username' => 'smtp_username', 'password' => 'smtp_password'] as $key => $setting) {
            if (($s[$setting] ?? '') !== '') {
                config(["mail.mailers.smtp.$key" => $key === 'port' ? (int) $s[$setting] : $s[$setting]]);
            }
        }

        // "tls" is STARTTLS (smtp scheme), "ssl" is implicit TLS (smtps scheme), "none" lets the transport decide
        $encryption = $s['smtp_encryption'] ?? '';
        if ($encryption !== '') {
            config(['mail.mailers.smtp.scheme' => $encryption === 'ssl' ? 'smtps' : 'smtp']);
        }

        if (!empty($s['mail_from_address']) && filter_var($s['mail_from_address'], FILTER_VALIDATE_EMAIL)) {
            config(['mail.from.address' => $s['mail_from_address']]);
        }
        if (!empty($s['mail_from_name'])) {
            config(['mail.from.name' => $s['mail_from_name']]);
        }
    }

    public static function flush(): void
    {
        Cache::forget(self::CACHE_KEY);
    }

    /** @return array<string, string|null> */
    private static function load(): array
    {
        return Cache::remember(self::CACHE_KEY, 300, function () {
            if (!Schema::hasTable('settings')) {
                return [];
            }

            return Setting::where('group', 'mail')->get()
                ->mapWithKeys(fn (Setting $row) => [$row->key => $row->value])
                ->all();
        });
    }
}
