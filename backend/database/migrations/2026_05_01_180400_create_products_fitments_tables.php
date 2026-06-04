<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration {
    public function up(): void
    {
        Schema::create('products', function (Blueprint $t) {
            $t->id();
            $t->string('type', 20); // tire | battery
            $t->string('sku')->unique();
            $t->foreignId('brand_id')->constrained()->cascadeOnDelete();
            $t->foreignId('category_id')->nullable()->constrained()->nullOnDelete();
            $t->decimal('price', 12, 2);
            $t->decimal('sale_price', 12, 2)->nullable();
            $t->decimal('cost', 12, 2)->nullable();
            $t->unsignedInteger('stock')->default(0);
            $t->unsignedInteger('low_stock_threshold')->default(5);
            $t->unsignedSmallInteger('manufacture_year')->nullable();
            $t->unsignedSmallInteger('manufacturer_warranty_months')->nullable();
            $t->unsignedSmallInteger('agency_warranty_months')->nullable();
            $t->decimal('expert_rating', 3, 1)->nullable(); // 0..5 manually set
            $t->unsignedInteger('virtual_sales_count')->default(0); // marketing
            $t->unsignedInteger('virtual_views_count')->default(0); // marketing
            $t->unsignedInteger('real_sales_count')->default(0);
            $t->unsignedInteger('real_views_count')->default(0);
            $t->unsignedInteger('sort_order')->default(0);
            $t->boolean('is_active')->default(true);
            $t->boolean('is_featured')->default(false);
            $t->timestamps();
            $t->softDeletes();
            $t->index(['type', 'is_active']);
            $t->index(['brand_id']);
        });

        Schema::create('product_translations', function (Blueprint $t) {
            $t->id();
            $t->foreignId('product_id')->constrained()->cascadeOnDelete();
            $t->string('locale', 5)->index();
            $t->string('name');
            $t->text('short_description')->nullable();
            $t->longText('description')->nullable();
            $t->string('pattern_name')->nullable(); // e.g. "ثبات عالي"
            $t->string('usage_notes')->nullable();
            $t->string('meta_title')->nullable();
            $t->string('meta_description')->nullable();
            $t->unique(['product_id', 'locale']);
        });

        Schema::create('product_images', function (Blueprint $t) {
            $t->id();
            $t->foreignId('product_id')->constrained()->cascadeOnDelete();
            $t->string('path');
            $t->boolean('is_primary')->default(false);
            $t->unsignedInteger('sort_order')->default(0);
            $t->timestamps();
        });

        Schema::create('product_badges', function (Blueprint $t) {
            $t->id();
            $t->foreignId('product_id')->constrained()->cascadeOnDelete();
            $t->string('badge', 30); // best_seller | best_choice | special_offer | new
            $t->unique(['product_id', 'badge']);
        });

        Schema::create('tire_specs', function (Blueprint $t) {
            $t->id();
            $t->foreignId('product_id')->constrained()->cascadeOnDelete();
            $t->unsignedSmallInteger('width');     // e.g. 225
            $t->unsignedTinyInteger('aspect_ratio'); // e.g. 45
            $t->unsignedTinyInteger('rim_diameter'); // e.g. 17
            $t->string('load_index', 10)->nullable();
            $t->string('speed_rating', 5)->nullable();
            $t->string('usage_type', 30)->nullable(); // sport, comfort, off-road, all-season
            $t->boolean('runflat')->default(false);
            $t->index(['width', 'aspect_ratio', 'rim_diameter']);
            $t->unique(['product_id']);
        });

        Schema::create('battery_specs', function (Blueprint $t) {
            $t->id();
            $t->foreignId('product_id')->constrained()->cascadeOnDelete();
            $t->unsignedTinyInteger('voltage')->default(12);
            $t->unsignedSmallInteger('ampere_hour'); // Ah
            $t->unsignedSmallInteger('cca')->nullable(); // cold cranking amps
            $t->string('battery_type', 30)->nullable(); // AGM, EFB, lead-acid
            $t->string('terminal_position', 20)->nullable(); // L | R
            $t->string('size_code', 30)->nullable();
            $t->unique(['product_id']);
        });

        Schema::create('fitments', function (Blueprint $t) {
            $t->id();
            $t->foreignId('vehicle_id')->constrained()->cascadeOnDelete();
            $t->foreignId('product_id')->constrained()->cascadeOnDelete();
            $t->unsignedSmallInteger('year_from')->nullable();
            $t->unsignedSmallInteger('year_to')->nullable();
            $t->string('trim')->nullable();
            $t->boolean('is_alternative')->default(false);
            $t->boolean('is_excluded')->default(false);
            $t->boolean('is_oem')->default(false);
            $t->timestamps();
            $t->index(['vehicle_id', 'product_id']);
            $t->index(['product_id']);
        });

        Schema::create('fitment_translations', function (Blueprint $t) {
            $t->id();
            $t->foreignId('fitment_id')->constrained()->cascadeOnDelete();
            $t->string('locale', 5)->index();
            $t->text('notes')->nullable();
            $t->unique(['fitment_id', 'locale']);
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('fitment_translations');
        Schema::dropIfExists('fitments');
        Schema::dropIfExists('battery_specs');
        Schema::dropIfExists('tire_specs');
        Schema::dropIfExists('product_badges');
        Schema::dropIfExists('product_images');
        Schema::dropIfExists('product_translations');
        Schema::dropIfExists('products');
    }
};
