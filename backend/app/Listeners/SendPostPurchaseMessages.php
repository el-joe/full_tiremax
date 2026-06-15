<?php

namespace App\Listeners;

use App\Events\OrderPlaced;
use App\Jobs\SendWhatsappMessage;
use App\Models\WhatsappTemplate;
use Illuminate\Contracts\Queue\ShouldQueue;

class SendPostPurchaseMessages implements ShouldQueue
{
    public int $tries = 3;
    public int $backoff = 30;

    public function handle(OrderPlaced $event): void
    {
        $order    = $event->order;
        $customer = $order->customer;

        if (!$customer) {
            return;
        }

        // Check if customer has globally disabled automation
        if ($customer->automationSetting?->is_disabled) {
            return;
        }

        // Send invoice immediately
        $template = WhatsappTemplate::where('key', 'invoice')
            ->where('is_active', true)
            ->first();

        if ($template) {
            SendWhatsappMessage::dispatch($template, $customer, $order);
        }
    }
}
