<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration {
    public function up(): void
    {
        Schema::table('customers', function (Blueprint $t) {
            $t->string('daftra_id')->nullable()->unique()->after('id');
        });

        Schema::table('bookings', function (Blueprint $t) {
            $t->string('daftra_invoice_id')->nullable()->after('admin_notes');
        });
    }

    public function down(): void
    {
        Schema::table('bookings', function (Blueprint $t) {
            $t->dropColumn('daftra_invoice_id');
        });

        Schema::table('customers', function (Blueprint $t) {
            $t->dropColumn('daftra_id');
        });
    }
};
