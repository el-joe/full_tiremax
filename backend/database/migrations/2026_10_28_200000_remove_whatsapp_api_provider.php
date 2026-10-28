<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Support\Facades\DB;

return new class extends Migration
{
    public function up(): void
    {
        DB::table('settings')->where('key', 'wa_provider')->delete();
        DB::table('settings')->whereIn('key', ['wa_daily_limit', 'wa_hourly_limit'])->update(['value' => '0']);
    }

    public function down(): void
    {
    }
};
