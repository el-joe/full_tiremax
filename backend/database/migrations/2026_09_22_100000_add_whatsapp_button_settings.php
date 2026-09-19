<?php

use App\Models\Setting;
use Illuminate\Database\Migrations\Migration;

return new class extends Migration
{
    public function up(): void
    {
        $m = Setting::firstOrCreate(['key' => 'whatsapp_default_message'], ['group' => 'general', 'cast' => 'string', 'is_translatable' => true]);
        if (!$m->translate('en')) {
            $m->translateOrNew('en')->value = 'Hello Iraq Max Tire, I would like to ask about your products and services.';
            $m->translateOrNew('ar')->value = 'مرحباً إيراق ماكس تاير، أود الاستفسار عن منتجاتكم وخدماتكم.';
            $m->save();
        }
        Setting::firstOrCreate(['key' => 'whatsapp_button_enabled'], ['group' => 'general', 'cast' => 'bool', 'is_translatable' => false, 'value' => '1']);
    }

    public function down(): void
    {
        Setting::whereIn('key', ['whatsapp_default_message', 'whatsapp_button_enabled'])->delete();
    }
};
