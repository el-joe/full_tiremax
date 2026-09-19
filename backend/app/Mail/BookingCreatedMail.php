<?php

namespace App\Mail;

use App\Models\Booking;

class BookingCreatedMail extends TransactionalMail
{
    public function __construct(public Booking $booking, public ?string $prev = null) {}

    protected function viewName(): string { return 'emails.booking'; }
    protected function subjectKey(): string { return 'emails.booking_created.subject'; }
    protected function recipientLocale(): string { return $this->booking->customer_locale ?: 'ar'; }
    protected function reference(): string { return $this->booking->reference; }

    protected function viewData(): array
    {
        return ['booking' => $this->booking->loadMissing(['branch', 'service']), 'kind' => 'booking_created', 'from' => $this->prev];
    }
}
