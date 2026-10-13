<?php

return [
    'order_placed' => [
        'title' => 'Order placed',
        'body' => 'Your order :reference has been placed successfully.',
    ],
    'order_status_changed' => [
        'title' => 'Order updated',
        'body' => 'Your order :reference status changed to :status.',
    ],
    'booking_created' => [
        'title' => 'Booking confirmed',
        'body' => 'Your booking :reference is scheduled for :date.',
    ],
    'booking_status_changed' => [
        'title' => 'Booking updated',
        'body' => 'Your booking :reference status changed to :status.',
    ],
    'booking_reminder' => [
        'title' => 'Booking reminder',
        'body' => 'Reminder: your booking :reference is tomorrow at :time.',
    ],
    'order_statuses' => [
        'pending' => 'Pending',
        'confirmed' => 'Confirmed',
        'processing' => 'Processing',
        'shipped' => 'On the way',
        'delivered' => 'Delivered',
        'completed' => 'Completed',
        'cancelled' => 'Cancelled',
        'refunded' => 'Refunded',
    ],
    'booking_statuses' => [
        'pending' => 'Pending',
        'confirmed' => 'Confirmed',
        'in_progress' => 'In progress',
        'completed' => 'Completed',
        'cancelled' => 'Cancelled',
        'no_show' => 'No show',
    ],
];
