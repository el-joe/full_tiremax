<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration {
    public function up(): void
    {
        Schema::table('brands', function (Blueprint $t) {
            $t->string('daftra_id')->nullable()->unique()->after('id');
        });

        Schema::table('categories', function (Blueprint $t) {
            $t->string('daftra_id')->nullable()->unique()->after('id');
        });

        Schema::table('products', function (Blueprint $t) {
            $t->string('daftra_id')->nullable()->unique()->after('id');
        });

        // Generalise daftra_sync_logs to support product/brand/category syncs in addition to orders
        Schema::table('daftra_sync_logs', function (Blueprint $t) {
            $t->string('syncable_type')->nullable()->after('order_id');
            $t->unsignedBigInteger('syncable_id')->nullable()->after('syncable_type');
            $t->index(['syncable_type', 'syncable_id'], 'dsl_syncable_index');
        });
    }

    public function down(): void
    {
        Schema::table('daftra_sync_logs', function (Blueprint $t) {
            $t->dropIndex('dsl_syncable_index');
            $t->dropColumn(['syncable_type', 'syncable_id']);
        });

        Schema::table('products', function (Blueprint $t) {
            $t->dropColumn('daftra_id');
        });

        Schema::table('categories', function (Blueprint $t) {
            $t->dropColumn('daftra_id');
        });

        Schema::table('brands', function (Blueprint $t) {
            $t->dropColumn('daftra_id');
        });
    }
};
