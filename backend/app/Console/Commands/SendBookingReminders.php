<?php

namespace App\Console\Commands;

use App\Models\Booking;
use App\Notifications\BookingReminderNotification;
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

        Booking::with('customer')
            ->whereIn('status', [Booking::STATUS_PENDING, Booking::STATUS_CONFIRMED])
            ->whereDate('scheduled_at', $tomorrow->toDateString())
            ->each(function (Booking $booking) {
                if ($booking->customer) {
                    $booking->customer->notify(new BookingReminderNotification($booking));
                }
            });

        $this->info('Booking reminders sent.');
    }
}
