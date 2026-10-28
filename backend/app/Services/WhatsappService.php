<?php

namespace App\Services;

use App\Models\Booking;
use App\Models\Order;
use App\Models\WhatsappLog;
use App\Models\WhatsappTemplate;
use App\Support\Phone;
use App\Support\WhatsappSettings;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Support\Facades\Log;

class WhatsappService
{
    /** Order wrapper kept for the artisan command / legacy job. */
    public function sendForOrder(Order $order, string $templateKey): ?WhatsappLog
    {
        return $this->send($order->customer_phone, $templateKey, [], $order->customer_locale ?: 'ar', $order);
    }

    /**
     * Send a template to any phone. Returns the log (status sent|failed|skipped) or null when the
     * template is missing/inactive or a duplicate was sent within the last minute.
     */
    public function send(?string $phone, string $templateKey, array $vars = [], string $locale = 'ar', ?Model $subject = null, bool $force = false): ?WhatsappLog
    {
        if (!$phone) {
            return null;
        }

        $template = WhatsappTemplate::with('translations')->where('key', $templateKey)->where('is_active', true)->first();
        if (!$template) {
            return null;
        }

        $body = $template->translate($locale)?->body ?: $template->translate('en')?->body ?: $template->translate('ar')?->body;
        if (!$body) {
            return null;
        }

        $vars = $vars + $this->variablesFor($subject, $locale);
        $body = $this->interpolate($body, $vars);
        $to = Phone::normalize($phone) ?: $phone;

        $subjectCols = [
            'order_id' => $subject instanceof Order ? $subject->id : null,
            'booking_id' => $subject instanceof Booking ? $subject->id : null,
        ];

        if (!$force && $subject) {
            $dup = WhatsappLog::where('whatsapp_template_id', $template->id)
                ->where('phone', $to)
                ->where('status', '!=', 'failed')
                ->where('created_at', '>=', now()->subMinute())
                ->where($subjectCols['order_id'] ? ['order_id' => $subjectCols['order_id']] : ['booking_id' => $subjectCols['booking_id']])
                ->exists();
            if ($dup) {
                return null;
            }
        }

        $log = WhatsappLog::create($subjectCols + [
            'customer_id' => $subject?->customer_id ?? null,
            'whatsapp_template_id' => $template->id,
            'template_key' => $templateKey,
            'locale' => $locale,
            'phone' => $to,
            'status' => 'pending',
            'body' => $body,
        ]);

        return $this->deliver($log);
    }

    /**
     * Deliver a pending/queued log through the QR-linked session. Hourly/daily
     * caps are enforced; messages over the cap stay 'queued' and are flushed later by
     * whatsapp:flush-queued, so automations are delayed rather than lost (and the number isn't flooded).
     */
    public function deliver(WhatsappLog $log): WhatsappLog
    {
        $log->channel = 'qr';

        try {
            $gateway = app(WhatsappGateway::class);
            if (!$gateway->isConnected()) {
                return $this->park($log, 'WhatsApp QR session is not connected');
            }
            if ($this->overLimit()) {
                return $this->park($log, 'Sending limit reached, will retry automatically');
            }
            $response = $gateway->send($log->phone, $log->body, WhatsappSettings::get('wa_min_gap'), WhatsappSettings::get('wa_max_gap'));
            $log->update(['status' => 'sent', 'provider_message_id' => $response['id'] ?? null, 'response' => $response, 'sent_at' => now()]);
        } catch (\Throwable $e) {
            $log->update(['status' => 'failed', 'response' => ['error' => $e->getMessage()]]);
            Log::error('WhatsApp send failed', ['log_id' => $log->id, 'error' => $e->getMessage()]);
        }

        return $log;
    }

    private function park(WhatsappLog $log, string $reason): WhatsappLog
    {
        $log->update(['status' => 'queued', 'response' => ['error' => $reason]]);

        return $log;
    }

    public function overLimit(): bool
    {
        foreach (['wa_daily_limit' => now()->startOfDay(), 'wa_hourly_limit' => now()->subHour()] as $key => $since) {
            $limit = WhatsappSettings::get($key);
            if ($limit > 0 && WhatsappLog::where('channel', 'qr')->where('status', 'sent')->where('sent_at', '>=', $since)->count() >= $limit) {
                return true;
            }
        }

        return false;
    }

    public function flushQueued(int $max = 20): int
    {
        $sent = 0;
        $logs = WhatsappLog::where('status', 'queued')->orderBy('id')->limit($max)->get();
        foreach ($logs as $log) {
            if (!app(WhatsappGateway::class)->isConnected() || $this->overLimit()) {
                break;
            }
            $sent += $this->deliver($log)->status === 'sent' ? 1 : 0;
        }

        return $sent;
    }

    public function variablesFor(?Model $subject, string $locale): array
    {
        if ($subject instanceof Order) {
            return $this->orderVariables($subject);
        }
        if ($subject instanceof Booking) {
            return $this->bookingVariables($subject, $locale);
        }
        return [];
    }

    private function orderVariables(Order $order): array
    {
        $order->loadMissing('items');

        return [
            'customer_name' => $order->customer_name,
            'order_ref' => $order->reference,
            'total' => number_format((float) $order->total, 0),
            'items_count' => $order->items->sum('quantity'),
            'tracking_number' => $order->tracking_number ?? '—',
            'cancellation_reason' => $order->cancellation_reason ?? '',
            'review_url' => config('app.frontend_url') . '/review',
            'shop_url' => config('app.frontend_url'),
            'track_url' => config('app.frontend_url') . '/profile/orders/' . $order->reference,
        ];
    }

    private function bookingVariables(Booking $b, string $locale): array
    {
        $b->loadMissing(['service.translations', 'branch.translations']);
        $service = $b->service?->translate($locale)?->name ?? $b->service?->translate('en')?->name ?? '';
        $branch = $b->branch?->translate($locale)?->name ?? $b->branch?->translate('en')?->name ?? '';
        $at = $b->scheduled_at;

        return [
            'customer_name' => $b->customer_name,
            'booking_ref' => $b->reference,
            'service' => $service,
            'service_name' => $service,
            'branch' => $branch,
            'branch_name' => $branch,
            'date' => $at?->format('Y-m-d'),
            'time' => $at?->format('H:i'),
            'scheduled_at' => $at?->format('Y-m-d H:i'),
        ];
    }

    private function interpolate(string $body, array $vars): string
    {
        foreach ($vars as $key => $value) {
            $body = str_replace('{{' . $key . '}}', (string) $value, $body);
        }
        return $body;
    }
}
