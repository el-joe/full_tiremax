<?php

namespace App\Notifications\Channels;

use App\Services\WhatsappService;
use Illuminate\Notifications\Notification;

class WhatsappChannel
{
    public function __construct(private WhatsappService $whatsapp) {}

    public function send(object $notifiable, Notification $notification): void
    {
        $phone = $notifiable->routeNotificationFor('whatsapp', $notification);
        if (!$phone || !method_exists($notification, 'toWhatsapp')) {
            return;
        }

        $m = $notification->toWhatsapp($notifiable);
        $log = $this->whatsapp->send($phone, $m['template'], $m['vars'] ?? [], $m['locale'] ?? 'ar', $m['subject'] ?? null, $m['force'] ?? false);

        // Throw on failure so the queue retries with backoff (skipped/duplicate are not retried).
        if ($log && $log->status === 'failed') {
            throw new \RuntimeException('WhatsApp delivery failed: ' . ($log->response['error'] ?? 'unknown'));
        }
    }
}
