<?php

namespace App\Services;

use App\Models\Order;
use App\Models\WhatsappLog;
use App\Models\WhatsappTemplate;
use Illuminate\Support\Facades\Http;
use Illuminate\Support\Facades\Log;

class WhatsappService
{
    public function sendForOrder(Order $order, string $templateKey): ?WhatsappLog
    {
        $template = WhatsappTemplate::where('key', $templateKey)
            ->where('is_active', true)
            ->first();

        if (!$template) {
            return null;
        }

        $locale = 'ar';
        $body = $template->translateOrDefault($locale)->body ?? $template->translate('en')?->body;

        if (!$body) {
            return null;
        }

        $variables = $this->resolveOrderVariables($order);
        $body = $this->interpolate($body, $variables);

        $phone = $order->customer_phone;

        $log = WhatsappLog::create([
            'customer_id'           => $order->customer_id,
            'order_id'              => $order->id,
            'whatsapp_template_id'  => $template->id,
            'phone'                 => $phone,
            'status'                => 'pending',
            'body'                  => $body,
        ]);

        try {
            $response = $this->dispatch($phone, $body);

            $log->update([
                'status'              => 'sent',
                'provider_message_id' => $response['id'] ?? null,
                'response'            => $response,
                'sent_at'             => now(),
            ]);
        } catch (\Throwable $e) {
            $log->update([
                'status'   => 'failed',
                'response' => ['error' => $e->getMessage()],
            ]);

            Log::error('WhatsApp send failed', [
                'log_id' => $log->id,
                'error'  => $e->getMessage(),
            ]);
        }

        return $log;
    }

    private function dispatch(string $phone, string $body): array
    {
        $apiUrl   = config('services.whatsapp.api_url');
        $apiToken = config('services.whatsapp.api_token');
        $from     = config('services.whatsapp.from_number');

        $response = Http::timeout(15)
            ->withToken($apiToken)
            ->post($apiUrl, [
                'from'    => $from,
                'to'      => $this->normalizePhone($phone),
                'type'    => 'text',
                'message' => ['body' => $body],
            ]);

        $response->throw();

        return $response->json() ?? [];
    }

    private function resolveOrderVariables(Order $order): array
    {
        $items = $order->items ?? $order->load('items')->items;

        return [
            'customer_name'  => $order->customer_name,
            'order_ref'      => $order->reference,
            'total'          => number_format((float) $order->total, 0),
            'items_count'    => $items->sum('quantity'),
            'tracking_number' => $order->tracking_number ?? '—',
            'review_url'     => config('app.url') . '/review',
            'shop_url'       => config('app.url'),
        ];
    }

    private function interpolate(string $body, array $vars): string
    {
        foreach ($vars as $key => $value) {
            $body = str_replace("{{{$key}}}", $value, $body);
        }
        return $body;
    }

    private function normalizePhone(string $phone): string
    {
        $digits = preg_replace('/\D/', '', $phone);

        if (str_starts_with($digits, '0')) {
            $digits = '964' . ltrim($digits, '0');
        }

        return '+' . ltrim($digits, '+');
    }
}
