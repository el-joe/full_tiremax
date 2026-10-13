<?php

return [
    'order_placed' => [
        'title' => 'تم تسجيل الطلب',
        'body' => 'تم تسجيل طلبك :reference بنجاح.',
    ],
    'order_status_changed' => [
        'title' => 'تحديث الطلب',
        'body' => 'تغيّرت حالة طلبك :reference إلى :status.',
    ],
    'booking_created' => [
        'title' => 'تم تأكيد الحجز',
        'body' => 'حجزك :reference مجدول بتاريخ :date.',
    ],
    'booking_status_changed' => [
        'title' => 'تحديث الحجز',
        'body' => 'تغيّرت حالة حجزك :reference إلى :status.',
    ],
    'booking_reminder' => [
        'title' => 'تذكير بالحجز',
        'body' => 'تذكير: حجزك :reference غدًا في الساعة :time.',
    ],
    'order_statuses' => [
        'pending' => 'قيد الانتظار',
        'confirmed' => 'مؤكد',
        'processing' => 'قيد المعالجة',
        'shipped' => 'في الطريق',
        'delivered' => 'تم التسليم',
        'completed' => 'مكتمل',
        'cancelled' => 'ملغي',
        'refunded' => 'تم الاسترداد',
    ],
    'booking_statuses' => [
        'pending' => 'قيد الانتظار',
        'confirmed' => 'مؤكد',
        'in_progress' => 'قيد التنفيذ',
        'completed' => 'مكتمل',
        'cancelled' => 'ملغي',
        'no_show' => 'لم يحضر',
    ],
];
