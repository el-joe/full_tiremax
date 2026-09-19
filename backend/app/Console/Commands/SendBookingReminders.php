<?php

namespace App\Console\Commands;

use App\Models\Booking;
use App\Services\BookingNotifier;
use Illuminate\Console\Attributes\Description;
use Illuminate\Console\Attributes\Signature;
use Illuminate\Console\Command;

#[Signature('bookings:send-reminders')]
#[Description('Send reminder notifications for bookings scheduled tomorrow')]
class SendBookingReminders extends Command
{
    public function handle(): void
    {
        $tomorrow = now()->addDay();

        Booking::with(['customer', 'service', 'branch'])
            ->whereIn('status', [Booking::STATUS_PENDING, Booking::STATUS_CONFIRMED])
            ->whereDate('scheduled_at', $tomorrow->toDateString())
            ->each(function (Booking $booking) {
                $already = \App\Models\NotificationLog::where('event', 'booking_reminder')
                    ->where('subject_type', Booking::class)->where('subject_id', $booking->id)
                    ->where('created_at', '>=', now()->subHours(20))->exists();
                if (!$already) {
                    app(BookingNotifier::class)->reminder($booking);
                }
            });

        $this->info('Booking reminders sent.');
    }
}
