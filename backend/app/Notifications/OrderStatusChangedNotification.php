<?php

namespace App\Notifications;

use App\Models\Order;
use Illuminate\Bus\Queueable;
use Illuminate\Notifications\Notification;

class OrderStatusChangedNotification extends Notification
{
    use Queueable;

    public function __construct(public Order $order, public string $fromStatus) {}

    public function via(object $notifiable): array
    {
        return ['database'];
    }

    public function toArray(object $notifiable): array
    {
        return [
            'type' => 'order_status_changed',
            'title' => 'Order Updated',
            'body' => "Your order {$this->order->reference} status changed to {$this->order->status}.",
            'order_id' => $this->order->id,
            'reference' => $this->order->reference,
            'from_status' => $this->fromStatus,
            'status' => $this->order->status,
        ];
    }
}
