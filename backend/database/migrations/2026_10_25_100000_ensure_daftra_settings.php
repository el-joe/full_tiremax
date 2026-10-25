<?php

use App\Models\Setting;
use Illuminate\Database\Migrations\Migration;

return new class extends Migration
{
    /**
     * Daftra is optional. `settings.key` is globally unique and `enabled` already belongs to the
     * maintenance group, so the toggle lives under its own key. Off by default.
     */
    public function up(): void
    {
        foreach (['api_url' => ['string', null], 'api_key' => ['string', null], 'daftra_enabled' => ['bool', '0']] as $key => [$cast, $value]) {
            Setting::firstOrCreate(
                ['key' => $key],
                ['group' => 'daftra', 'cast' => $cast, 'is_translatable' => false, 'value' => $value],
            );
        }
    }

    public function down(): void
    {
        // settings are kept
    }
};
