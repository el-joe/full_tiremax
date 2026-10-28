<?php

namespace App\Livewire\Admin\WhatsappConnection;

use App\Livewire\Concerns\AuthorizesAdmin;
use App\Models\WhatsappLog;
use App\Services\WhatsappGateway;
use App\Support\Phone;
use App\Support\WhatsappSettings;
use Livewire\Attributes\Layout;
use Livewire\Component;

class WhatsappConnectionManager extends Component
{
    use AuthorizesAdmin;

    public string $provider = 'api';
    public int $dailyLimit = 200;
    public int $hourlyLimit = 40;
    public int $minGap = 4;
    public int $maxGap = 10;
    public string $testPhone = '';
    public ?string $flash = null;
    public ?string $flashType = null;

    public function mount(): void
    {
        $this->authorizePermission('whatsapp.view');
        $this->provider = WhatsappSettings::get('wa_provider');
        $this->dailyLimit = WhatsappSettings::get('wa_daily_limit');
        $this->hourlyLimit = WhatsappSettings::get('wa_hourly_limit');
        $this->minGap = WhatsappSettings::get('wa_min_gap');
        $this->maxGap = WhatsappSettings::get('wa_max_gap');
    }

    public function connect(WhatsappGateway $gateway): void
    {
        $this->authorizePermission('whatsapp.update');
        try {
            $gateway->connect();
        } catch (\Throwable) {
            $this->notify(__('messages.admin.wa_gateway_offline'), 'error');
        }
    }

    public function disconnect(WhatsappGateway $gateway): void
    {
        $this->authorizePermission('whatsapp.update');
        try {
            $gateway->logout();
            $this->notify(__('messages.admin.wa_disconnected'), 'ok');
        } catch (\Throwable) {
            $this->notify(__('messages.admin.wa_gateway_offline'), 'error');
        }
    }

    public function saveSettings(): void
    {
        $this->authorizePermission('whatsapp.update');
        $this->validate([
            'provider' => 'required|in:api,qr',
            'dailyLimit' => 'required|integer|min:0|max:100000',
            'hourlyLimit' => 'required|integer|min:0|max:10000',
            'minGap' => 'required|integer|min:1|max:600',
            'maxGap' => 'required|integer|min:1|max:600|gte:minGap',
        ]);
        WhatsappSettings::set('wa_provider', $this->provider);
        WhatsappSettings::set('wa_daily_limit', $this->dailyLimit);
        WhatsappSettings::set('wa_hourly_limit', $this->hourlyLimit);
        WhatsappSettings::set('wa_min_gap', $this->minGap);
        WhatsappSettings::set('wa_max_gap', $this->maxGap);
        $this->notify(__('messages.admin.saved'), 'ok');
    }

    public function sendTest(WhatsappGateway $gateway): void
    {
        $this->authorizePermission('whatsapp.update');
        $this->validate(['testPhone' => 'required|string|max:30']);
        $phone = Phone::normalize($this->testPhone);
        if (!$phone) {
            $this->addError('testPhone', __('messages.admin.wa_invalid_phone'));
            return;
        }
        try {
            $gateway->send($phone, 'TireMax WhatsApp test ✅', 1, 1);
            $this->notify(__('messages.admin.wa_test_sent'), 'ok');
        } catch (\Throwable $e) {
            $this->notify($e->getMessage(), 'error');
        }
    }

    private function notify(string $msg, string $type): void
    {
        $this->flash = $msg;
        $this->flashType = $type;
    }

    #[Layout('components.admin.layout', ['title' => 'WhatsApp Connection'])]
    public function render(WhatsappGateway $gateway)
    {
        $this->authorizePermission('whatsapp.view');
        $qr = WhatsappLog::where('channel', 'qr');

        return view('livewire.admin.whatsapp-connection.whatsapp-connection-manager', [
            'gw' => $gateway->status(),
            'sentToday' => (clone $qr)->where('status', 'sent')->where('sent_at', '>=', now()->startOfDay())->count(),
            'sentHour' => (clone $qr)->where('status', 'sent')->where('sent_at', '>=', now()->subHour())->count(),
            'queued' => WhatsappLog::where('status', 'queued')->count(),
        ]);
    }
}
