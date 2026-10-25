<?php

namespace App\Listeners;

use App\Events\OrderPlaced;
use App\Integrations\Daftra;
use App\Models\Booking;

/**
 * With Daftra the order's pending bookings are confirmed once the invoice is pushed
 * (DaftraOrderSyncService). Without Daftra nothing would ever confirm them, so do it here.
 */
class ConfirmOrderBookings
{
    public function handle(OrderPlaced $event): void
    {
        if (Daftra::isActive()) {
            return;
        }

        $event->order->bookings()
            ->where('status', Booking::STATUS_PENDING)
            ->each(fn (Booking $b) => $b->update(['status' => Booking::STATUS_CONFIRMED]));
    }
}
