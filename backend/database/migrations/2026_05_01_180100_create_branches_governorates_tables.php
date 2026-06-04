<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration {
    public function up(): void
    {
        Schema::create('branches', function (Blueprint $t) {
            $t->id();
            $t->string('code')->unique();
            $t->string('phone')->nullable();
            $t->string('email')->nullable();
            $t->decimal('latitude', 10, 7)->nullable();
            $t->decimal('longitude', 10, 7)->nullable();
            $t->boolean('is_main')->default(false);
            $t->boolean('is_active')->default(true);
            $t->unsignedSmallInteger('default_capacity')->default(2);
            $t->boolean('auto_confirm_bookings')->default(false);
            $t->timestamps();
            $t->softDeletes();
        });

        Schema::create('branch_translations', function (Blueprint $t) {
            $t->id();
            $t->foreignId('branch_id')->constrained()->cascadeOnDelete();
            $t->string('locale', 5)->index();
            $t->string('name');
            $t->string('address')->nullable();
            $t->text('description')->nullable();
            $t->unique(['branch_id', 'locale']);
        });

        Schema::create('branch_schedules', function (Blueprint $t) {
            $t->id();
            $t->foreignId('branch_id')->constrained()->cascadeOnDelete();
            $t->unsignedTinyInteger('day_of_week'); // 0=Sun..6=Sat
            $t->time('opens_at')->nullable();
            $t->time('closes_at')->nullable();
            $t->unsignedSmallInteger('capacity')->default(2);
            $t->boolean('is_closed')->default(false);
            $t->unique(['branch_id', 'day_of_week']);
        });

        Schema::create('governorates', function (Blueprint $t) {
            $t->id();
            $t->string('code')->unique();
            $t->boolean('is_basra')->default(false);
            $t->decimal('shipping_fee', 12, 2)->default(0);
            $t->boolean('is_active')->default(true);
            $t->unsignedInteger('sort_order')->default(0);
            $t->timestamps();
        });

        Schema::create('governorate_translations', function (Blueprint $t) {
            $t->id();
            $t->foreignId('governorate_id')->constrained()->cascadeOnDelete();
            $t->string('locale', 5)->index();
            $t->string('name');
            $t->unique(['governorate_id', 'locale']);
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('governorate_translations');
        Schema::dropIfExists('governorates');
        Schema::dropIfExists('branch_schedules');
        Schema::dropIfExists('branch_translations');
        Schema::dropIfExists('branches');
    }
};
