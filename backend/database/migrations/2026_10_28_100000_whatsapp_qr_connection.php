<?php

use Illuminate\Support\Facades\DB;
use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::table('whatsapp_logs', function (Blueprint $table) {
            $table->string('channel', 10)->default('api')->after('status')->index();
        });

        $defaults = [
            'wa_provider' => ['string', 'api'],      // api | qr
            'wa_daily_limit' => ['int', '200'],      // 0 = unlimited
            'wa_hourly_limit' => ['int', '40'],      // 0 = unlimited
            'wa_min_gap' => ['int', '4'],            // seconds between messages
            'wa_max_gap' => ['int', '10'],
        ];
        foreach ($defaults as $key => [$cast, $value]) {
            if (!DB::table('settings')->where('key', $key)->exists()) {
                DB::table('settings')->insert(['key' => $key, 'group' => 'whatsapp', 'cast' => $cast, 'is_translatable' => false, 'value' => $value, 'created_at' => now(), 'updated_at' => now()]);
            }
        }
    }

    public function down(): void
    {
        Schema::table('whatsapp_logs', fn (Blueprint $t) => $t->dropColumn('channel'));
    }
};
