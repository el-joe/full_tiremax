<?php

namespace Tests\Feature\Admin;

use App\Livewire\Admin\WhatsappConnection\WhatsappConnectionManager;
use App\Models\WhatsappLog;
use App\Services\WhatsappService;
use App\Support\WhatsappSettings;
use Database\Seeders\WhatsappTemplateSeeder;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Illuminate\Support\Facades\Http;
use Livewire\Livewire;
use Tests\TestCase;

class WhatsappConnectionTest extends TestCase
{
    use RefreshDatabase, ActingAsAdmin;

    public function test_page_shows_qr_and_saves_settings(): void
    {
        config(['services.whatsapp_gateway.url' => 'http://gw.test']);
        Http::fake(['gw.test/status' => Http::response(['status' => 'qr', 'qr' => 'data:image/png;base64,AAA', 'number' => null, 'name' => null, 'error' => null])]);
        $this->actingAsAdmin(['whatsapp.view', 'whatsapp.update']);

        Livewire::test(WhatsappConnectionManager::class)
            ->assertSee('data:image/png;base64,AAA', false)
            ->assertSet('dailyLimit', 200);

    }

    public function test_qr_provider_sends_then_queues_over_limit(): void
    {
        config(['services.whatsapp_gateway.url' => 'http://gw.test']);
        Http::fake([
            'gw.test/status' => Http::response(['status' => 'connected']),
            'gw.test/send' => Http::response(['id' => 'ABC']),
        ]);
        $this->seed(WhatsappTemplateSeeder::class);
        WhatsappSettings::set('wa_daily_limit', 1);
        $key = \App\Models\WhatsappTemplate::first()->key;

        $svc = app(WhatsappService::class);
        $a = $svc->send('01012345678', $key, [], 'en');
        $b = $svc->send('01012345679', $key, [], 'en');

        $this->assertSame('sent', $a->status);
        $this->assertSame('qr', $a->channel);
        $this->assertSame('queued', $b->status);

        WhatsappSettings::set('wa_daily_limit', 10);
        $this->assertSame(1, $svc->flushQueued());
        $this->assertSame('sent', $b->fresh()->status);
        $this->assertSame(2, WhatsappLog::where('status', 'sent')->count());
    }
}
