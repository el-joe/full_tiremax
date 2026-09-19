<?php

namespace App\Mail;

use App\Models\Order;

class OrderPlacedMail extends TransactionalMail
{
    public function __construct(public Order $order) {}

    protected function viewName(): string { return 'emails.order'; }
    protected function subjectKey(): string { return 'emails.order_placed.subject'; }
    protected function recipientLocale(): string { return $this->order->customer_locale ?: 'ar'; }
    protected function reference(): string { return $this->order->reference; }

    protected function viewData(): array
    {
        return ['order' => $this->order->loadMissing(['items', 'branch', 'governorate']), 'kind' => 'order_placed', 'from' => null];
    }
}
