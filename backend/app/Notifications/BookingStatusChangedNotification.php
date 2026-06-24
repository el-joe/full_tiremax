<?php

namespace App\Notifications;

use App\Models\Booking;
use Illuminate\Bus\Queueable;
use Illuminate\Notifications\Notification;

class BookingStatusChangedNotification extends Notification
{
    use Queueable;

    public function __construct(public Booking $booking, public string $fromStatus) {}

    public function via(object $notifiable): array
    {
        return ['database'];
    }

    public function toArray(object $notifiable): array
    {
        return [
            'type' => 'booking_status_changed',
            'title' => 'Booking Updated',
            'body' => "Your booking {$this->booking->reference} status changed to {$this->booking->status}.",
            'booking_id' => $this->booking->id,
            'reference' => $this->booking->reference,
            'scheduled_at' => $this->booking->scheduled_at->toISOString(),
            'from_status' => $this->fromStatus,
            'status' => $this->booking->status,
        ];
    }
}
