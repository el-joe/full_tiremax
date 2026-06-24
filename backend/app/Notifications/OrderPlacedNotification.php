<?php

namespace App\Notifications;

use App\Models\Order;
use Illuminate\Bus\Queueable;
use Illuminate\Notifications\Notification;

class OrderPlacedNotification extends Notification
{
    use Queueable;

    public function __construct(public Order $order) {}

    public function via(object $notifiable): array
    {
        return ['database'];
    }

    public function toArray(object $notifiable): array
    {
        return [
            'type' => 'order_placed',
            'title' => 'Order Placed',
            'body' => "Your order {$this->order->reference} has been placed successfully.",
            'order_id' => $this->order->id,
            'reference' => $this->order->reference,
            'status' => $this->order->status,
        ];
    }
}
