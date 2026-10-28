<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Support\Facades\DB;

return new class extends Migration
{
    public function up(): void
    {
        foreach (['wa_daily_limit' => '200', 'wa_hourly_limit' => '40', 'wa_min_gap' => '4', 'wa_max_gap' => '10'] as $key => $value) {
            DB::table('settings')->where('key', $key)->update(['value' => $value]);
        }
    }

    public function down(): void
    {
    }
};
