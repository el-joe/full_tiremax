<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration {
    public function up(): void
    {
        Schema::table('reviews', function (Blueprint $t) {
            $t->boolean('is_approved')->nullable()->default(null)->change();
        });
    }

    public function down(): void
    {
        \Illuminate\Support\Facades\DB::table('reviews')->whereNull('is_approved')->update(['is_approved' => false]);
        Schema::table('reviews', function (Blueprint $t) {
            $t->boolean('is_approved')->default(false)->change();
        });
    }
};
