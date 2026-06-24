<?php

namespace App\Notifications;

use App\Models\Booking;
use Illuminate\Bus\Queueable;
use Illuminate\Notifications\Notification;

class BookingReminderNotification extends Notification
{
    use Queueable;

    public function __construct(public Booking $booking) {}

    public function via(object $notifiable): array
    {
        return ['database'];
    }

    public function toArray(object $notifiable): array
    {
        return [
            'type' => 'booking_reminder',
            'title' => 'Booking Reminder',
            'body' => "Reminder: your booking {$this->booking->reference} is tomorrow at {$this->booking->scheduled_at->format('H:i')}.",
            'booking_id' => $this->booking->id,
            'reference' => $this->booking->reference,
            'scheduled_at' => $this->booking->scheduled_at->toISOString(),
            'status' => $this->booking->status,
        ];
    }
}
