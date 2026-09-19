<?php

namespace App\Listeners;

use App\Events\OrderPlaced;
use App\Events\OrderStatusChanged;
use App\Services\OrderNotifier;
use Illuminate\Contracts\Queue\ShouldQueue;

class SendOrderNotifications implements ShouldQueue
{
    public bool $afterCommit = true;
    public int $tries = 3;
    public int $backoff = 30;

    public function handle(OrderPlaced|OrderStatusChanged $event): void
    {
        $notifier = app(OrderNotifier::class);
        try {
            $event instanceof OrderPlaced
            ? $notifier->placed($event->order)
            : $notifier->statusChanged($event->order, $event->from);
        } catch (\Throwable $e) {
            \Illuminate\Support\Facades\Log::error('Notification listener failed', ['error' => $e->getMessage()]);
        }
    }
}
