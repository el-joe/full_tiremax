<?php

use App\Support\Phone;
use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Schema;

return new class extends Migration {
    public function up(): void
    {
        // customers
        Schema::table('customers', function (Blueprint $t) {
            $t->string('phone_normalized', 20)->nullable()->index()->after('phone');
        });

        // orders
        Schema::table('orders', function (Blueprint $t) {
            $t->dropForeign(['customer_id']);
        });
        Schema::table('orders', function (Blueprint $t) {
            $t->unsignedBigInteger('customer_id')->nullable()->change();
            $t->foreign('customer_id')->references('id')->on('customers')->nullOnDelete();
            $t->boolean('is_guest')->default(false);
            $t->string('guest_token', 64)->nullable()->index();
            $t->string('customer_locale', 5)->default('ar');
            $t->string('phone_normalized', 20)->nullable()->index();
        });

        // bookings
        Schema::table('bookings', function (Blueprint $t) {
            $t->dropForeign(['customer_id']);
        });
        Schema::table('bookings', function (Blueprint $t) {
            $t->unsignedBigInteger('customer_id')->nullable()->change();
            $t->foreign('customer_id')->references('id')->on('customers')->nullOnDelete();
            $t->string('customer_name')->nullable();
            $t->string('customer_phone')->nullable();
            $t->string('customer_email')->nullable();
            $t->string('customer_locale', 5)->default('ar');
            $t->boolean('is_guest')->default(false);
            $t->string('guest_token', 64)->nullable()->index();
            $t->string('phone_normalized', 20)->nullable()->index();
        });

        // status log actor is unknown for guests / system changes
        Schema::table('order_status_logs', function (Blueprint $t) {
            $t->string('actor_type')->nullable()->change();
            $t->unsignedBigInteger('actor_id')->nullable()->change();
        });

        Schema::table('carts', function (Blueprint $t) {
            $t->string('guest_token', 64)->nullable()->unique();
        });

        Schema::table('whatsapp_logs', function (Blueprint $t) {
            $t->foreignId('booking_id')->nullable()->after('order_id')->constrained()->nullOnDelete();
        });

        // Backfill
        DB::table('customers')->orderBy('id')->chunkById(500, function ($rows) {
            foreach ($rows as $r) {
                DB::table('customers')->where('id', $r->id)->update(['phone_normalized' => Phone::normalize($r->phone)]);
            }
        });
        DB::table('orders')->orderBy('id')->chunkById(500, function ($rows) {
            foreach ($rows as $r) {
                DB::table('orders')->where('id', $r->id)->update(['phone_normalized' => Phone::normalize($r->customer_phone)]);
            }
        });
        DB::table('bookings')->orderBy('id')->chunkById(500, function ($rows) {
            foreach ($rows as $r) {
                $c = $r->customer_id ? DB::table('customers')->find($r->customer_id) : null;
                DB::table('bookings')->where('id', $r->id)->update([
                    'customer_name' => $c->name ?? null,
                    'customer_phone' => $c->phone ?? null,
                    'customer_email' => $c->email ?? null,
                    'customer_locale' => $c->locale ?? 'ar',
                    'phone_normalized' => Phone::normalize($c->phone ?? null),
                ]);
            }
        });
    }

    public function down(): void
    {
        Schema::table('whatsapp_logs', function (Blueprint $t) {
            $t->dropConstrainedForeignId('booking_id');
        });
        Schema::table('carts', function (Blueprint $t) {
            $t->dropUnique(['guest_token']);
            $t->dropColumn('guest_token');
        });
        Schema::table('bookings', function (Blueprint $t) {
            $t->dropColumn(['customer_name', 'customer_phone', 'customer_email', 'customer_locale', 'is_guest', 'guest_token', 'phone_normalized']);
        });
        Schema::table('orders', function (Blueprint $t) {
            $t->dropColumn(['is_guest', 'guest_token', 'customer_locale', 'phone_normalized']);
        });
        Schema::table('customers', function (Blueprint $t) {
            $t->dropColumn('phone_normalized');
        });
    }
};
