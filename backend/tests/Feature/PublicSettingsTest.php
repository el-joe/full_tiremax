<?php

namespace Tests\Feature;

use App\Models\Setting;
use Database\Seeders\SettingSeeder;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Tests\TestCase;

class PublicSettingsTest extends TestCase
{
    use RefreshDatabase;

    public function test_returns_whitelist_only_with_wa_urls(): void
    {
        $this->seed(SettingSeeder::class);
        Setting::where('key', 'api_token')->update(['value' => 'SECRET-TOKEN']);

        $res = $this->getJson('/api/v1/settings/public', ['X-Locale' => 'ar'])->assertOk();
        $d = $res->json('data');
        $this->assertStringStartsWith('https://wa.me/9647700000001?text=', $d['whatsapp_url']);
        $this->assertStringContainsString('api.whatsapp.com/send?phone=9647700000001&text=', $d['whatsapp_url_fallback']);
        $this->assertTrue($d['whatsapp_button_enabled']);
        $this->assertArrayNotHasKey('api_token', $d);
        $this->assertStringNotContainsString('SECRET-TOKEN', $res->getContent());
        $this->assertStringNotContainsString('daftra', strtolower($res->getContent()));
    }

    public function test_cache_busted_on_save(): void
    {
        $this->seed(SettingSeeder::class);
        $this->getJson('/api/v1/settings/public')->assertJsonPath('data.site_email', 'info@iraqmaxtire.iq');
        Setting::where('key', 'site_email')->first()->update(['value' => 'new@x.iq']);
        $this->getJson('/api/v1/settings/public')->assertJsonPath('data.site_email', 'new@x.iq');
    }
}
