<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration {
    public function up(): void
    {
        Schema::create('vehicle_makes', function (Blueprint $t) {
            $t->id();
            $t->string('slug')->unique();
            $t->string('logo')->nullable();
            $t->boolean('is_active')->default(true);
            $t->unsignedInteger('sort_order')->default(0);
            $t->timestamps();
        });

        Schema::create('vehicle_make_translations', function (Blueprint $t) {
            $t->id();
            $t->foreignId('vehicle_make_id')->constrained()->cascadeOnDelete();
            $t->string('locale', 5)->index();
            $t->string('name');
            $t->unique(['vehicle_make_id', 'locale']);
        });

        Schema::create('vehicle_models', function (Blueprint $t) {
            $t->id();
            $t->foreignId('vehicle_make_id')->constrained()->cascadeOnDelete();
            $t->string('slug');
            $t->boolean('is_active')->default(true);
            $t->unsignedInteger('sort_order')->default(0);
            $t->timestamps();
            $t->unique(['vehicle_make_id', 'slug']);
        });

        Schema::create('vehicle_model_translations', function (Blueprint $t) {
            $t->id();
            $t->foreignId('vehicle_model_id')->constrained()->cascadeOnDelete();
            $t->string('locale', 5)->index();
            $t->string('name');
            $t->unique(['vehicle_model_id', 'locale']);
        });

        Schema::create('vehicles', function (Blueprint $t) {
            $t->id();
            $t->foreignId('vehicle_model_id')->constrained()->cascadeOnDelete();
            $t->unsignedSmallInteger('year_from');
            $t->unsignedSmallInteger('year_to')->nullable();
            $t->string('trim_code')->nullable();
            $t->string('engine')->nullable();
            $t->boolean('is_active')->default(true);
            $t->timestamps();
            $t->softDeletes();
            $t->index(['vehicle_model_id', 'year_from', 'year_to']);
        });

        Schema::create('vehicle_translations', function (Blueprint $t) {
            $t->id();
            $t->foreignId('vehicle_id')->constrained()->cascadeOnDelete();
            $t->string('locale', 5)->index();
            $t->string('trim_name')->nullable();
            $t->text('notes')->nullable();
            $t->unique(['vehicle_id', 'locale']);
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('vehicle_translations');
        Schema::dropIfExists('vehicles');
        Schema::dropIfExists('vehicle_model_translations');
        Schema::dropIfExists('vehicle_models');
        Schema::dropIfExists('vehicle_make_translations');
        Schema::dropIfExists('vehicle_makes');
    }
};
