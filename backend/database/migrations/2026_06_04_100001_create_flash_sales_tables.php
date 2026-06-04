<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration {
    public function up(): void
    {
        Schema::create('flash_sales', function (Blueprint $t) {
            $t->id();
            $t->string('title');
            $t->decimal('discount_percent', 5, 2);
            $t->dateTime('starts_at');
            $t->dateTime('ends_at');
            $t->boolean('is_active')->default(true);
            $t->timestamps();
            $t->index(['is_active', 'starts_at', 'ends_at']);
        });

        Schema::create('flash_sale_products', function (Blueprint $t) {
            $t->id();
            $t->foreignId('flash_sale_id')->constrained('flash_sales')->cascadeOnDelete();
            $t->foreignId('product_id')->constrained('products')->cascadeOnDelete();
            $t->unique(['flash_sale_id', 'product_id']);
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('flash_sale_products');
        Schema::dropIfExists('flash_sales');
    }
};
