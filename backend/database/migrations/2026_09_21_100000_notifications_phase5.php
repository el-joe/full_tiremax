<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Schema;

return new class extends Migration {
    public function up(): void
    {
        Schema::create('notification_logs', function (Blueprint $t) {
            $t->id();
            $t->string('channel', 20)->default('email');
            $t->string('event', 40);
            $t->nullableMorphs('subject');
            $t->string('recipient');
            $t->string('locale', 5)->default('ar');
            $t->string('status', 20)->default('queued'); // queued|sent|failed
            $t->text('error')->nullable();
            $t->json('meta')->nullable();
            $t->timestamps();
        });

        Schema::table('whatsapp_logs', function (Blueprint $t) {
            $t->string('template_key', 60)->nullable()->after('whatsapp_template_id');
            $t->string('locale', 5)->nullable()->after('template_key');
        });

        foreach (['email_enabled', 'whatsapp_enabled'] as $key) {
            if (!DB::table('settings')->where('group', 'notifications')->where('key', $key)->exists()) {
                DB::table('settings')->insert([
                    'group' => 'notifications', 'key' => $key, 'value' => '1', 'cast' => 'bool',
                    'is_translatable' => false, 'created_at' => now(), 'updated_at' => now(),
                ]);
            }
        }
    }

    public function down(): void
    {
        Schema::table('whatsapp_logs', function (Blueprint $t) {
            $t->dropColumn(['template_key', 'locale']);
        });
        Schema::dropIfExists('notification_logs');
        DB::table('settings')->where('group', 'notifications')->delete();
    }
};
