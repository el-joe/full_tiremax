<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration {
    public function up(): void
    {
        Schema::create('cities', function (Blueprint $t) {
            $t->id();
            $t->foreignId('governorate_id')->constrained()->cascadeOnDelete();
            $t->string('name_ar');
            $t->string('name_en');
            $t->boolean('is_active')->default(true);
            $t->unsignedInteger('sort_order')->default(0);
            $t->timestamps();
        });

        Schema::create('addresses', function (Blueprint $t) {
            $t->id();
            $t->foreignId('customer_id')->constrained()->cascadeOnDelete();
            $t->string('full_name');
            $t->string('phone');
            $t->foreignId('governorate_id')->constrained();
            $t->foreignId('city_id')->constrained();
            $t->string('address');
            $t->boolean('is_default')->default(false);
            $t->timestamps();
            $t->softDeletes();
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('addresses');
        Schema::dropIfExists('cities');
    }
};
