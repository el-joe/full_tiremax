<?php

namespace App\Listeners;

use App\Events\BookingCreated;
use App\Events\BookingStatusChanged;
use App\Services\BookingNotifier;
use Illuminate\Contracts\Queue\ShouldQueue;

class SendBookingNotifications implements ShouldQueue
{
    public bool $afterCommit = true;
    public int $tries = 3;
    public int $backoff = 30;

    public function handle(BookingCreated|BookingStatusChanged $event): void
    {
        $notifier = app(BookingNotifier::class);
        try {
            $event instanceof BookingCreated
            ? $notifier->created($event->booking)
            : $notifier->statusChanged($event->booking, $event->from);
        } catch (\Throwable $e) {
            \Illuminate\Support\Facades\Log::error('Notification listener failed', ['error' => $e->getMessage()]);
        }
    }
}
