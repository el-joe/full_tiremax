<?php

namespace App\Console\Commands\Daftra;

use App\Integrations\Daftra;
use App\Models\Order;
use App\Services\DaftraOrderSyncService;
use Illuminate\Console\Attributes\Description;
use Illuminate\Console\Attributes\Signature;
use Illuminate\Console\Command;
use RuntimeException;
use Throwable;

#[Signature('daftra:push-orders
    {--order= : Push a specific order by ID or reference}
    {--dry-run : Show what would be pushed without actually calling Daftra}')]
#[Description('Push confirmed TireMax orders to Daftra as sales invoices')]
class PushOrdersToDaftra extends Command
{
    public function handle(DaftraOrderSyncService $service): int
    {
        try {
            app(Daftra::class); // Validate Daftra config early
        } catch (RuntimeException $e) {
            $this->error($e->getMessage());
            return Command::FAILURE;
        }

        $orderId = $this->option('order');
        $dryRun  = (bool) $this->option('dry-run');

        if ($orderId !== null) {
            return $this->pushSingle($service, $orderId, $dryRun);
        }

        return $this->pushAll($service, $dryRun);
    }

    // ──────────────────────────────────────────────────────────────────────────

    private function pushSingle(DaftraOrderSyncService $service, string $orderId, bool $dryRun): int
    {
        $order = Order::with(['customer', 'items.product', 'bookings.service'])
            ->where('id', $orderId)
            ->orWhere('reference', $orderId)
            ->first();

        if (!$order) {
            $this->error("Order [{$orderId}] not found.");
            return Command::FAILURE;
        }

        if ($order->daftra_invoice_id) {
            $this->warn("Order [{$order->reference}] already synced (invoice: {$order->daftra_invoice_id}).");
            return Command::SUCCESS;
        }

        $this->printOrderRow($order);

        if ($dryRun) {
            $this->line('<fg=yellow>[dry-run] Skipping actual push.</>');
            return Command::SUCCESS;
        }

        try {
            $service->push($order);
            $order->refresh();
            $this->info("✓ Pushed → invoice #{$order->daftra_invoice_id}");
        } catch (Throwable $e) {
            $this->error("✗ Failed: {$e->getMessage()}");
            return Command::FAILURE;
        }

        return Command::SUCCESS;
    }

    private function pushAll(DaftraOrderSyncService $service, bool $dryRun): int
    {
        $pending = Order::whereNull('daftra_invoice_id')
            ->whereIn('status', [
                Order::STATUS_CONFIRMED,
                Order::STATUS_PROCESSING,
                Order::STATUS_SHIPPED,
                Order::STATUS_DELIVERED,
                Order::STATUS_COMPLETED,
            ])
            ->count();

        if ($pending === 0) {
            $this->info('No pending orders to push.');
            return Command::SUCCESS;
        }

        $this->info("Pushing {$pending} order(s) to Daftra…");

        if ($dryRun) {
            Order::whereNull('daftra_invoice_id')
                ->whereIn('status', [
                    Order::STATUS_CONFIRMED,
                    Order::STATUS_PROCESSING,
                    Order::STATUS_SHIPPED,
                    Order::STATUS_DELIVERED,
                    Order::STATUS_COMPLETED,
                ])
                ->with('customer')
                ->get()
                ->each(fn (Order $o) => $this->printOrderRow($o));

            $this->line('<fg=yellow>[dry-run] No orders were pushed.</>');
            return Command::SUCCESS;
        }

        $bar = $this->output->createProgressBar($pending);
        $bar->setFormat(' %current%/%max% [%bar%] %percent:3s%%  %message%');
        $bar->start();

        $synced = $failed = 0;

        $service->pushPendingOrders(function (Order $order, ?Throwable $e) use ($bar, &$synced, &$failed) {
            if ($e) {
                $failed++;
                $bar->setMessage("<fg=red>✗ {$order->reference}</>");
            } else {
                $synced++;
                $bar->setMessage("<fg=green>✓ {$order->reference} → #{$order->daftra_invoice_id}</>");
            }
            $bar->advance();
        });

        $bar->finish();
        $this->newLine();

        $this->info(sprintf(
            'Done. Pushed: <fg=green>%d</> | Failed: <fg=red>%d</>',
            $synced,
            $failed
        ));

        // List bookings confirmed as part of this push
        $confirmedBookings = \App\Models\Booking::whereIn('order_id',
            Order::whereNotNull('daftra_invoice_id')->pluck('id')
        )->where('status', \App\Models\Booking::STATUS_CONFIRMED)->count();

        if ($confirmedBookings > 0) {
            $this->line("Appointments confirmed: <fg=cyan>{$confirmedBookings}</>");
        }

        return $failed > 0 ? Command::FAILURE : Command::SUCCESS;
    }

    private function printOrderRow(Order $order): void
    {
        $bookings = $order->relationLoaded('bookings') ? $order->bookings->count() : '?';

        $this->table(
            ['ID', 'Reference', 'Customer', 'Status', 'Total', 'Bookings'],
            [[
                $order->id,
                $order->reference,
                $order->customer_name,
                $order->status,
                number_format((float) $order->total, 2),
                $bookings,
            ]]
        );
    }
}
