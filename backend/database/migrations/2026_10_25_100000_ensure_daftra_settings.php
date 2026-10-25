<?php

use App\Models\Setting;
use Illuminate\Database\Migrations\Migration;

return new class extends Migration
{
    /** Daftra is optional: make sure the toggle + credentials exist (off by default) on already-seeded installs. */
    public function up(): void
    {
        foreach (['api_url' => ['string', null], 'api_key' => ['string', null], 'enabled' => ['bool', '0']] as $key => [$cast, $value]) {
            Setting::firstOrCreate(
                ['group' => 'daftra', 'key' => $key],
                ['cast' => $cast, 'is_translatable' => false, 'value' => $value],
            );
        }
    }

    public function down(): void
    {
        // settings are kept
    }
};
