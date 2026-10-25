<?php

namespace App\Listeners;

use App\Events\OrderPlaced;
use App\Services\DaftraOrderSyncService;
use App\Integrations\Daftra;
use Illuminate\Contracts\Queue\ShouldQueue;
use RuntimeException;
use Throwable;

class PushOrderToDaftra implements ShouldQueue
{
    public int $tries = 3;
    public int $backoff = 60;

    public function handle(OrderPlaced $event): void
    {
        // Daftra is optional: when switched off in Settings, nothing is pushed.
        if (! Daftra::isActive()) {
            return;
        }

        try {
            app(DaftraOrderSyncService::class)->push($event->order);
        } catch (RuntimeException $e) {
            // Daftra not configured — skip silently
        }
    }

    public function failed(OrderPlaced $event, Throwable $e): void
    {
        // Final failure is already logged inside DaftraOrderSyncService
    }
}
