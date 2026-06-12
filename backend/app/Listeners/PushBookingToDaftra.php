<?php

namespace App\Listeners;

use App\Events\BookingCreated;
use App\Services\DaftraBookingSyncService;
use Illuminate\Contracts\Queue\ShouldQueue;
use RuntimeException;
use Throwable;

class PushBookingToDaftra implements ShouldQueue
{
    public int $tries = 3;
    public int $backoff = 60;

    public function handle(BookingCreated $event): void
    {
        try {
            app(DaftraBookingSyncService::class)->push($event->booking);
        } catch (RuntimeException $e) {
            // Daftra not configured — skip silently
        }
    }

    public function failed(BookingCreated $event, Throwable $e): void
    {
        // Final failure logged inside DaftraBookingSyncService
    }
}
