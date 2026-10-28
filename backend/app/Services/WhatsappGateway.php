<?php

namespace App\Services;

use Illuminate\Support\Facades\Http;

/** Client for the local Node (Baileys) gateway in /whatsapp-gateway that holds the QR-linked session. */
class WhatsappGateway
{
    private function http()
    {
        return Http::baseUrl(config('services.whatsapp_gateway.url'))
            ->withHeaders(['X-Gateway-Secret' => (string) config('services.whatsapp_gateway.secret')])
            ->acceptJson();
    }

    /** @return array{status:string,qr:?string,number:?string,name:?string,error:?string} */
    public function status(): array
    {
        try {
            $r = $this->http()->timeout(4)->get('/status');
            if ($r->successful()) {
                return $r->json();
            }
        } catch (\Throwable) {
        }

        return ['status' => 'offline', 'qr' => null, 'number' => null, 'name' => null, 'error' => 'gateway_unreachable'];
    }

    public function connect(): void
    {
        $this->http()->timeout(5)->post('/connect');
    }

    public function logout(): void
    {
        $this->http()->timeout(15)->post('/logout');
    }

    public function isConnected(): bool
    {
        return $this->status()['status'] === 'connected';
    }

    /** @return array{id:?string} @throws \RuntimeException */
    public function send(string $phone, string $message, int $minGapSec, int $maxGapSec): array
    {
        $r = $this->http()->timeout(60)->post('/send', [
            'to' => ltrim($phone, '+'),
            'message' => $message,
            'min_gap_ms' => $minGapSec * 1000,
            'max_gap_ms' => max($minGapSec, $maxGapSec) * 1000,
        ]);
        if ($r->failed()) {
            throw new \RuntimeException('WhatsApp QR gateway: ' . ($r->json('error') ?? 'HTTP ' . $r->status()));
        }

        return $r->json() ?? [];
    }
}
