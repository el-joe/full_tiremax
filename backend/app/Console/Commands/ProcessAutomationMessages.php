<?php

namespace App\Console\Commands;

use App\Jobs\SendWhatsappMessage;
use App\Models\Order;
use App\Models\WhatsappLog;
use App\Models\WhatsappTemplate;
use Illuminate\Console\Command;

class ProcessAutomationMessages extends Command
{
    protected $signature   = 'automation:process';
    protected $description = 'Dispatch scheduled post-purchase WhatsApp messages';

    public function handle(): void
    {
        $templates = WhatsappTemplate::where('is_active', true)
            ->whereNotNull('trigger_after_days')
            ->where('key', '!=', 'invoice') // invoice is sent immediately on order
            ->get();

        if ($templates->isEmpty()) {
            return;
        }

        foreach ($templates as $template) {
            $days      = $template->trigger_after_days;
            $targetDate = now()->subDays($days)->toDateString();

            // Orders placed exactly `days` ago (within today's window)
            Order::whereDate('placed_at', $targetDate)
                ->whereNotIn('status', [Order::STATUS_CANCELLED, Order::STATUS_REFUNDED])
                ->with('customer.automationSetting')
                ->chunk(100, function ($orders) use ($template) {
                    foreach ($orders as $order) {
                        $customer = $order->customer;
                        if (!$customer) continue;

                        // Skip if customer opted out
                        if ($customer->automationSetting?->is_disabled) continue;

                        // Skip if already sent for this order + template
                        $alreadySent = WhatsappLog::where('order_id', $order->id)
                            ->where('whatsapp_template_id', $template->id)
                            ->whereIn('status', ['sent', 'delivered', 'read'])
                            ->exists();

                        if ($alreadySent) continue;

                        SendWhatsappMessage::dispatch($template, $customer, $order);
                    }
                });
        }

        $this->info('Automation messages dispatched.');
    }
}
