<?php

namespace App\Services;

use App\Models\Customer;
use App\Models\Order;
use App\Models\WhatsappLog;
use App\Models\WhatsappTemplate;
use Illuminate\Support\Facades\Http;
use Illuminate\Support\Facades\Log;

class WhatsappService
{
    private string $apiUrl;
    private string $token;
    private string $phoneId;

    public function __construct()
    {
        $this->apiUrl  = config('services.whatsapp.api_url', '');
        $this->token   = config('services.whatsapp.token', '');
        $this->phoneId = config('services.whatsapp.phone_id', '');
    }

    public function sendFromTemplate(
        WhatsappTemplate $template,
        Customer $customer,
        ?Order $order = null,
        array $extraVars = []
    ): WhatsappLog {
        $phone = $customer->phone;
        $body  = $this->renderBody($template, $customer, $order, $extraVars);

        $log = WhatsappLog::create([
            'customer_id'          => $customer->id,
            'order_id'             => $order?->id,
            'whatsapp_template_id' => $template->id,
            'phone'                => $phone,
            'status'               => 'pending',
            'body'                 => $body,
        ]);

        if (!$this->token || !$this->phoneId) {
            Log::warning('WhatsApp not configured — skipping send', ['log_id' => $log->id]);
            $log->update(['status' => 'failed', 'response' => ['error' => 'not_configured']]);
            return $log;
        }

        try {
            $response = Http::withToken($this->token)
                ->post("https://graph.facebook.com/v19.0/{$this->phoneId}/messages", [
                    'messaging_product' => 'whatsapp',
                    'to'                => $this->normalizePhone($phone),
                    'type'              => 'text',
                    'text'              => ['body' => $body],
                ]);

            $data      = $response->json();
            $messageId = $data['messages'][0]['id'] ?? null;
            $status    = $response->successful() ? 'sent' : 'failed';

            $log->update([
                'status'              => $status,
                'provider_message_id' => $messageId,
                'response'            => $data,
                'sent_at'             => now(),
            ]);
        } catch (\Throwable $e) {
            Log::error('WhatsApp send failed', ['error' => $e->getMessage(), 'log_id' => $log->id]);
            $log->update(['status' => 'failed', 'response' => ['error' => $e->getMessage()]]);
        }

        return $log;
    }

    private function renderBody(WhatsappTemplate $template, Customer $customer, ?Order $order, array $extra): string
    {
        $vars = array_merge([
            '{{customer_name}}'  => $customer->name,
            '{{customer_phone}}' => $customer->phone,
            '{{order_ref}}'      => $order?->reference ?? '',
            '{{order_total}}'    => $order ? number_format((float) $order->total, 2) : '',
            '{{order_date}}'     => $order?->placed_at?->format('Y-m-d') ?? '',
            '{{invoice_url}}'    => $order?->daftra_invoice_url ?? '',
        ], $extra);

        $locale = app()->getLocale();
        $body   = $template->translateOrDefault($locale)?->body ?? '';

        return str_replace(array_keys($vars), array_values($vars), $body);
    }

    private function normalizePhone(string $phone): string
    {
        $phone = preg_replace('/\D/', '', $phone);
        if (!str_starts_with($phone, '964')) {
            $phone = '964' . ltrim($phone, '0');
        }
        return $phone;
    }
}
