<?php

namespace App\Notifications;

use App\Models\Booking;
use Illuminate\Bus\Queueable;
use Illuminate\Notifications\Notification;

class BookingCreatedNotification extends Notification
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
            'type' => 'booking_created',
            'title' => 'Booking Confirmed',
            'body' => "Your booking {$this->booking->reference} is scheduled for {$this->booking->scheduled_at->format('Y-m-d H:i')}.",
            'booking_id' => $this->booking->id,
            'reference' => $this->booking->reference,
            'scheduled_at' => $this->booking->scheduled_at->toISOString(),
            'status' => $this->booking->status,
        ];
    }
}
