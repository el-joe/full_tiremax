<?php

namespace App\Services;

use App\Mail\BookingCreatedMail;
use App\Mail\BookingReminderMail;
use App\Mail\BookingStatusChangedMail;
use App\Models\Booking;
use App\Models\NotificationLog;
use App\Notifications\BookingCreatedNotification;
use App\Notifications\BookingReminderNotification;
use App\Notifications\BookingStatusChangedNotification;

class BookingNotifier extends BaseNotifier
{
    public const STATUS_TEMPLATES = [
        Booking::STATUS_CONFIRMED => 'booking_confirmed',
        Booking::STATUS_CANCELLED => 'booking_cancelled',
    ];

    public function created(Booking $b, bool $force = false): void
    {
        $loc = $b->customer_locale ?: 'ar';
        $this->email($b, 'booking_created', new BookingCreatedMail($b), $b->customer_email, $loc);
        $this->whatsapp($b, 'booking_created', $b->customer_phone, $loc, $force);
        $this->database($b->customer, new BookingCreatedNotification($b));
    }

    public function statusChanged(Booking $b, ?string $from, bool $force = false): void
    {
        $loc = $b->customer_locale ?: 'ar';
        $this->email($b, 'booking_status', new BookingStatusChangedMail($b, $from), $b->customer_email, $loc, ['from' => $from]);
        if ($tpl = self::STATUS_TEMPLATES[$b->status] ?? null) {
            $this->whatsapp($b, $tpl, $b->customer_phone, $loc, $force);
        }
        $this->database($b->customer, new BookingStatusChangedNotification($b, $from));
    }

    public function reminder(Booking $b): void
    {
        $loc = $b->customer_locale ?: 'ar';
        $this->email($b, 'booking_reminder', new BookingReminderMail($b), $b->customer_email, $loc);
        $this->whatsapp($b, 'booking_reminder', $b->customer_phone, $loc);
        $this->database($b->customer, new BookingReminderNotification($b));
    }

    public function resendEmail(NotificationLog $log, Booking $b): void
    {
        $mail = match ($log->event) {
            'booking_created' => new BookingCreatedMail($b),
            'booking_reminder' => new BookingReminderMail($b),
            default => new BookingStatusChangedMail($b, $log->meta['from'] ?? null),
        };
        $this->email($b, $log->event, $mail, $b->customer_email, $b->customer_locale ?: 'ar', $log->meta ?? []);
    }
}
