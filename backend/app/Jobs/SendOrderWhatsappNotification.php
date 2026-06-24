<?php

namespace App\Jobs;

use App\Models\Order;
use App\Services\WhatsappService;
use Illuminate\Contracts\Queue\ShouldQueue;
use Illuminate\Foundation\Queue\Queueable;

class SendOrderWhatsappNotification implements ShouldQueue
{
    use Queueable;

    public int $tries = 3;
    public int $backoff = 60;

    public function __construct(
        public readonly int $orderId,
        public readonly string $templateKey,
    ) {}

    public function handle(WhatsappService $whatsapp): void
    {
        $order = Order::with('items')->find($this->orderId);

        if (!$order) {
            return;
        }

        $whatsapp->sendForOrder($order, $this->templateKey);
    }
}
