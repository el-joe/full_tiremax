<?php

namespace App\Services;

use App\Mail\OrderPlacedMail;
use App\Mail\OrderStatusChangedMail;
use App\Models\NotificationLog;
use App\Models\Order;
use App\Notifications\OrderPlacedNotification;
use App\Notifications\OrderStatusChangedNotification;

class OrderNotifier extends BaseNotifier
{
    /** order status => whatsapp template key */
    public const STATUS_TEMPLATES = [
        Order::STATUS_CONFIRMED => 'order_confirmed',
        Order::STATUS_SHIPPED => 'order_shipped',
        Order::STATUS_DELIVERED => 'order_delivered',
    ];

    public function placed(Order $order, bool $force = false): void
    {
        $loc = $order->customer_locale ?: 'ar';
        $this->email($order, 'order_placed', new OrderPlacedMail($order), $order->customer_email, $loc);
        $this->whatsapp($order, 'order_placed', $order->customer_phone, $loc, $force);
        $this->database($order->customer, new OrderPlacedNotification($order));
    }

    public function statusChanged(Order $order, ?string $from, bool $force = false): void
    {
        $loc = $order->customer_locale ?: 'ar';
        $this->email($order, 'order_status', new OrderStatusChangedMail($order, $from), $order->customer_email, $loc, ['from' => $from]);
        if ($tpl = self::STATUS_TEMPLATES[$order->status] ?? null) {
            $this->whatsapp($order, $tpl, $order->customer_phone, $loc, $force);
        } elseif ($order->status === Order::STATUS_CANCELLED) {
            $this->whatsapp($order, 'order_cancelled', $order->customer_phone, $loc, $force);
        }
        $this->database($order->customer, new OrderStatusChangedNotification($order, $from));
    }

    public function resendEmail(NotificationLog $log, Order $order): void
    {
        $mail = $log->event === 'order_placed'
            ? new OrderPlacedMail($order)
            : new OrderStatusChangedMail($order, $log->meta['from'] ?? null);
        $this->email($order, $log->event, $mail, $order->customer_email, $order->customer_locale ?: 'ar', $log->meta ?? []);
    }
}
