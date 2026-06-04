<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration {
    public function up(): void
    {
        Schema::create('offers', function (Blueprint $t) {
            $t->id();
            $t->string('code')->unique();
            $t->string('discount_type', 20); // percent | fixed
            $t->decimal('discount_value', 12, 2);
            $t->decimal('min_subtotal', 12, 2)->default(0);
            $t->unsignedInteger('usage_limit')->nullable();
            $t->unsignedInteger('used_count')->default(0);
            $t->dateTime('starts_at')->nullable();
            $t->dateTime('ends_at')->nullable();
            $t->boolean('is_active')->default(true);
            $t->timestamps();
        });

        Schema::create('offer_translations', function (Blueprint $t) {
            $t->id();
            $t->foreignId('offer_id')->constrained()->cascadeOnDelete();
            $t->string('locale', 5)->index();
            $t->string('title');
            $t->text('description')->nullable();
            $t->unique(['offer_id', 'locale']);
        });

        Schema::create('offer_product', function (Blueprint $t) {
            $t->foreignId('offer_id')->constrained()->cascadeOnDelete();
            $t->foreignId('product_id')->constrained()->cascadeOnDelete();
            $t->primary(['offer_id', 'product_id']);
        });

        Schema::create('offer_governorate', function (Blueprint $t) {
            $t->foreignId('offer_id')->constrained()->cascadeOnDelete();
            $t->foreignId('governorate_id')->constrained()->cascadeOnDelete();
            $t->primary(['offer_id', 'governorate_id']);
        });

        Schema::create('offer_customer', function (Blueprint $t) {
            $t->foreignId('offer_id')->constrained()->cascadeOnDelete();
            $t->foreignId('customer_id')->constrained()->cascadeOnDelete();
            $t->primary(['offer_id', 'customer_id']);
        });

        Schema::create('whatsapp_templates', function (Blueprint $t) {
            $t->id();
            $t->string('key')->unique(); // e.g. order_confirmed, after_3_days, after_3_months
            $t->unsignedInteger('trigger_after_days')->nullable();
            $t->boolean('is_active')->default(true);
            $t->json('variables')->nullable();
            $t->timestamps();
        });

        Schema::create('whatsapp_template_translations', function (Blueprint $t) {
            $t->id();
            $t->foreignId('whatsapp_template_id')->constrained()->cascadeOnDelete();
            $t->string('locale', 5)->index();
            $t->string('subject')->nullable();
            $t->text('body');
            // $t->unique(['whatsapp_template_id', 'locale']);
        });

        Schema::create('whatsapp_logs', function (Blueprint $t) {
            $t->id();
            $t->foreignId('customer_id')->nullable()->constrained()->nullOnDelete();
            $t->foreignId('order_id')->nullable()->constrained()->nullOnDelete();
            $t->foreignId('whatsapp_template_id')->nullable()->constrained()->nullOnDelete();
            $t->string('phone');
            $t->string('status', 20)->default('pending'); // pending|sent|delivered|read|failed
            $t->string('provider_message_id')->nullable();
            $t->text('body');
            $t->json('response')->nullable();
            $t->timestamp('sent_at')->nullable();
            $t->timestamps();
            $t->index(['customer_id', 'whatsapp_template_id']);
        });

        Schema::create('automation_settings', function (Blueprint $t) {
            $t->id();
            $t->foreignId('customer_id')->nullable()->constrained()->cascadeOnDelete();
            $t->boolean('is_disabled')->default(false);
            $t->timestamps();
            $t->unique(['customer_id']);
        });

        Schema::create('settings', function (Blueprint $t) {
            $t->id();
            $t->string('group', 50)->default('general')->index();
            $t->string('key')->unique();
            $t->text('value')->nullable();
            $t->string('cast')->default('string'); // string|int|float|bool|json
            $t->boolean('is_translatable')->default(false);
            $t->timestamps();
        });

        Schema::create('setting_translations', function (Blueprint $t) {
            $t->id();
            $t->foreignId('setting_id')->constrained()->cascadeOnDelete();
            $t->string('locale', 5)->index();
            $t->text('value')->nullable();
            $t->unique(['setting_id', 'locale']);
        });

        Schema::create('audit_logs', function (Blueprint $t) {
            $t->id();
            $t->foreignId('admin_id')->nullable()->constrained()->nullOnDelete();
            $t->string('action', 50); // create|update|delete|login|logout|...
            $t->string('subject_type')->nullable();
            $t->unsignedBigInteger('subject_id')->nullable();
            $t->json('changes')->nullable();
            $t->string('ip', 45)->nullable();
            $t->string('user_agent')->nullable();
            $t->timestamps();
            $t->index(['subject_type', 'subject_id']);
        });

        Schema::create('daftra_sync_logs', function (Blueprint $t) {
            $t->id();
            $t->foreignId('order_id')->nullable()->constrained()->cascadeOnDelete();
            $t->string('action', 30); // create_invoice|update_status|deduct_stock
            $t->string('status', 20); // pending|success|failed
            $t->json('payload')->nullable();
            $t->json('response')->nullable();
            $t->unsignedSmallInteger('attempts')->default(0);
            $t->timestamps();
        });

        Schema::create('product_views', function (Blueprint $t) {
            $t->id();
            $t->foreignId('product_id')->constrained()->cascadeOnDelete();
            $t->foreignId('customer_id')->nullable()->constrained()->nullOnDelete();
            $t->string('ip', 45)->nullable();
            $t->string('user_agent')->nullable();
            $t->timestamps();
            $t->index(['product_id', 'created_at']);
        });

        Schema::create('cart_abandonments', function (Blueprint $t) {
            $t->id();
            $t->foreignId('cart_id')->constrained()->cascadeOnDelete();
            $t->timestamp('reminder_sent_at')->nullable();
            $t->boolean('recovered')->default(false);
            $t->timestamps();
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('cart_abandonments');
        Schema::dropIfExists('product_views');
        Schema::dropIfExists('daftra_sync_logs');
        Schema::dropIfExists('audit_logs');
        Schema::dropIfExists('setting_translations');
        Schema::dropIfExists('settings');
        Schema::dropIfExists('automation_settings');
        Schema::dropIfExists('whatsapp_logs');
        Schema::dropIfExists('whatsapp_template_translations');
        Schema::dropIfExists('whatsapp_templates');
        Schema::dropIfExists('offer_customer');
        Schema::dropIfExists('offer_governorate');
        Schema::dropIfExists('offer_product');
        Schema::dropIfExists('offer_translations');
        Schema::dropIfExists('offers');
    }
};
