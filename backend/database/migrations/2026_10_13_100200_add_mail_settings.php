<?php

use App\Models\Setting;
use Illuminate\Database\Migrations\Migration;

/**
 * Moves the mail configuration into the admin-managed settings table.
 * Initial values are copied once from the current .env/config so nothing changes on deploy.
 */
return new class extends Migration {
    public function up(): void
    {
        $smtp = config('mail.mailers.smtp', []);
        $scheme = $smtp['scheme'] ?? null;

        $rows = [
            'mail_mailer' => [config('mail.default'), 'string'],
            'smtp_host' => [$smtp['host'] ?? null, 'string'],
            'smtp_port' => [$smtp['port'] ?? 587, 'int'],
            'smtp_username' => [$smtp['username'] ?? null, 'string'],
            'smtp_password' => [$smtp['password'] ?? null, 'string'],
            'smtp_encryption' => [$scheme === 'smtps' ? 'ssl' : 'tls', 'string'],
            'mail_from_address' => [config('mail.from.address'), 'string'],
            'mail_from_name' => [config('mail.from.name'), 'string'],
        ];

        foreach ($rows as $key => [$value, $cast]) {
            Setting::firstOrCreate(
                ['group' => 'mail', 'key' => $key],
                ['cast' => $cast, 'is_translatable' => false, 'value' => $value === null || $value === 'null' ? null : (string) $value]
            );
        }
    }

    public function down(): void
    {
        Setting::where('group', 'mail')->delete();
    }
};
