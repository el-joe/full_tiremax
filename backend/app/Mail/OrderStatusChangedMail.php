<?php

namespace App\Mail;

use App\Models\Order;

class OrderStatusChangedMail extends TransactionalMail
{
    public function __construct(public Order $order, public ?string $prev = null) {}

    protected function viewName(): string { return 'emails.order'; }
    protected function subjectKey(): string { return 'emails.order_status.subject'; }
    protected function recipientLocale(): string { return $this->order->customer_locale ?: 'ar'; }
    protected function reference(): string { return $this->order->reference; }

    protected function viewData(): array
    {
        return ['order' => $this->order->loadMissing(['items', 'branch', 'governorate']), 'kind' => 'order_status', 'from' => $this->prev];
    }
}
