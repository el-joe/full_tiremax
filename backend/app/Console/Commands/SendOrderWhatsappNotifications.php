<?php

namespace App\Console\Commands;

use App\Jobs\SendOrderWhatsappNotification;
use App\Models\Order;
use App\Models\WhatsappLog;
use Illuminate\Console\Command;

class SendOrderWhatsappNotifications extends Command
{
    protected $signature = 'whatsapp:order-notifications
                            {--order= : Specific order ID to notify}
                            {--template= : Specific template key to send}
                            {--dry-run : Print what would be sent without dispatching jobs}';

    protected $description = 'Dispatch WhatsApp notification jobs for orders based on their status';

    // Status → template key mapping
    private const STATUS_TEMPLATES = [
        Order::STATUS_CONFIRMED   => 'order_confirmed',
        Order::STATUS_SHIPPED     => 'order_shipped',
        Order::STATUS_DELIVERED   => 'order_delivered',
    ];

    public function handle(): int
    {
        $dryRun     = $this->option('dry-run');
        $orderId    = $this->option('order');
        $templateKey = $this->option('template');

        if ($orderId && $templateKey) {
            return $this->handleSingle((int) $orderId, $templateKey, $dryRun);
        }

        return $this->handleBatch($dryRun);
    }

    private function handleSingle(int $orderId, string $templateKey, bool $dryRun): int
    {
        $order = Order::find($orderId);

        if (!$order) {
            $this->error("Order #{$orderId} not found.");
            return self::FAILURE;
        }

        $this->line("Order #{$orderId} — template: {$templateKey} — phone: {$order->customer_phone}");

        if (!$dryRun) {
            dispatch(new SendOrderWhatsappNotification($orderId, $templateKey));
            $this->info('Job dispatched.');
        }

        return self::SUCCESS;
    }

    private function handleBatch(bool $dryRun): int
    {
        $dispatched = 0;

        foreach (self::STATUS_TEMPLATES as $status => $templateKey) {
            // Find orders in this status that have NOT yet had this template sent
            $orders = Order::where('status', $status)
                ->whereDoesntHave('whatsappLogs', function ($q) use ($templateKey) {
                    $q->whereHas('template', fn($t) => $t->where('key', $templateKey))
                      ->whereIn('status', ['pending', 'sent', 'delivered', 'read']);
                })
                ->whereNotNull('customer_phone')
                ->get();

            foreach ($orders as $order) {
                $this->line("[{$status}] Order #{$order->id} ({$order->reference}) → {$templateKey}");

                if (!$dryRun) {
                    dispatch(new SendOrderWhatsappNotification($order->id, $templateKey));
                }

                $dispatched++;
            }
        }

        if ($dispatched === 0) {
            $this->info('No pending notifications.');
        } else {
            $verb = $dryRun ? 'would dispatch' : 'dispatched';
            $this->info("{$dispatched} job(s) {$verb}.");
        }

        return self::SUCCESS;
    }
}
