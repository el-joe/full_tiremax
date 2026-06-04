<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration {
    public function up(): void
    {
        Schema::create('services', function (Blueprint $t) {
            $t->id();
            $t->string('slug')->unique();
            $t->string('icon')->nullable();
            $t->unsignedSmallInteger('duration_minutes')->default(30);
            $t->decimal('price', 12, 2)->default(0);
            $t->boolean('is_active')->default(true);
            $t->unsignedInteger('sort_order')->default(0);
            $t->timestamps();
        });

        Schema::create('service_translations', function (Blueprint $t) {
            $t->id();
            $t->foreignId('service_id')->constrained()->cascadeOnDelete();
            $t->string('locale', 5)->index();
            $t->string('name');
            $t->text('description')->nullable();
            $t->unique(['service_id', 'locale']);
        });

        Schema::create('branch_service', function (Blueprint $t) {
            $t->id();
            $t->foreignId('branch_id')->constrained()->cascadeOnDelete();
            $t->foreignId('service_id')->constrained()->cascadeOnDelete();
            $t->decimal('price_override', 12, 2)->nullable();
            $t->boolean('is_active')->default(true);
            $t->unique(['branch_id', 'service_id']);
        });

        Schema::create('bookings', function (Blueprint $t) {
            $t->id();
            $t->string('reference')->unique();
            $t->foreignId('customer_id')->constrained()->cascadeOnDelete();
            $t->foreignId('branch_id')->constrained()->cascadeOnDelete();
            $t->foreignId('service_id')->constrained()->cascadeOnDelete();
            $t->foreignId('order_id')->nullable();
            $t->dateTime('scheduled_at');
            $t->unsignedSmallInteger('duration_minutes');
            $t->string('status', 20)->default('pending'); // pending|confirmed|in_progress|completed|cancelled|no_show
            $t->text('customer_notes')->nullable();
            $t->text('admin_notes')->nullable();
            $t->timestamps();
            $t->index(['branch_id', 'scheduled_at']);
            $t->index(['customer_id']);
            $t->index(['status']);
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('bookings');
        Schema::dropIfExists('branch_service');
        Schema::dropIfExists('service_translations');
        Schema::dropIfExists('services');
    }
};
