<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration {
    public function up(): void
    {
        Schema::create('carts', function (Blueprint $t) {
            $t->id();
            $t->foreignId('customer_id')->nullable()->constrained()->cascadeOnDelete();
            $t->string('session_id')->nullable()->index();
            $t->foreignId('governorate_id')->nullable()->constrained()->nullOnDelete();
            $t->timestamps();
            $t->index(['customer_id']);
        });

        Schema::create('cart_items', function (Blueprint $t) {
            $t->id();
            $t->foreignId('cart_id')->constrained()->cascadeOnDelete();
            $t->foreignId('product_id')->constrained()->cascadeOnDelete();
            $t->unsignedInteger('quantity')->default(1);
            $t->decimal('unit_price', 12, 2);
            $t->timestamps();
            $t->unique(['cart_id', 'product_id']);
        });

        Schema::create('orders', function (Blueprint $t) {
            $t->id();
            $t->string('reference')->unique();
            $t->foreignId('customer_id')->constrained()->cascadeOnDelete();
            $t->foreignId('governorate_id')->nullable()->constrained()->nullOnDelete();
            $t->foreignId('branch_id')->nullable()->constrained()->nullOnDelete();
            $t->string('type', 20); // basra | delivery
            $t->string('status', 30)->default('pending');
            $t->string('payment_method', 30)->default('cod');
            $t->string('payment_status', 20)->default('pending');
            $t->decimal('subtotal', 14, 2)->default(0);
            $t->decimal('discount', 14, 2)->default(0);
            $t->decimal('shipping_fee', 14, 2)->default(0);
            $t->decimal('installation_fee', 14, 2)->default(0);
            $t->decimal('total', 14, 2)->default(0);
            $t->string('customer_name');
            $t->string('customer_phone');
            $t->string('customer_email')->nullable();
            $t->string('shipping_address')->nullable();
            $t->string('tracking_number')->nullable();
            $t->string('daftra_invoice_id')->nullable();
            $t->string('daftra_invoice_url')->nullable();
            $t->json('daftra_meta')->nullable();
            $t->text('notes')->nullable();
            $t->timestamp('placed_at')->nullable();
            $t->timestamps();
            $t->softDeletes();
            $t->index(['status']);
            $t->index(['type']);
            $t->index(['customer_id']);
        });

        Schema::create('order_items', function (Blueprint $t) {
            $t->id();
            $t->foreignId('order_id')->constrained()->cascadeOnDelete();
            $t->foreignId('product_id')->constrained()->cascadeOnDelete();
            $t->string('product_name');
            $t->string('product_sku');
            $t->unsignedInteger('quantity');
            $t->decimal('unit_price', 12, 2);
            $t->decimal('total', 12, 2);
            $t->timestamps();
        });

        Schema::create('order_status_logs', function (Blueprint $t) {
            $t->id();
            $t->foreignId('order_id')->constrained()->cascadeOnDelete();
            $t->string('from_status', 30)->nullable();
            $t->string('to_status', 30);
            $t->text('note')->nullable();
            $t->morphs('actor'); // admin or customer
            $t->timestamps();
        });

        Schema::create('favorites', function (Blueprint $t) {
            $t->id();
            $t->foreignId('customer_id')->constrained()->cascadeOnDelete();
            $t->foreignId('product_id')->constrained()->cascadeOnDelete();
            $t->timestamps();
            $t->unique(['customer_id', 'product_id']);
        });

        Schema::create('reviews', function (Blueprint $t) {
            $t->id();
            $t->foreignId('customer_id')->nullable()->constrained()->nullOnDelete();
            $t->foreignId('product_id')->constrained()->cascadeOnDelete();
            $t->foreignId('order_id')->nullable()->constrained()->nullOnDelete();
            $t->string('type', 20)->default('customer'); // customer | expert
            $t->unsignedTinyInteger('rating'); // 1..5
            $t->text('comment')->nullable();
            $t->boolean('is_approved')->default(false);
            $t->timestamps();
            $t->index(['product_id', 'is_approved']);
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('reviews');
        Schema::dropIfExists('favorites');
        Schema::dropIfExists('order_status_logs');
        Schema::dropIfExists('order_items');
        Schema::dropIfExists('orders');
        Schema::dropIfExists('cart_items');
        Schema::dropIfExists('carts');
    }
};
