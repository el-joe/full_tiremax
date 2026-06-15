<?php

namespace Database\Seeders;

use App\Models\WhatsappTemplate;
use Illuminate\Database\Seeder;

class WhatsappTemplateSeeder extends Seeder
{
    public function run(): void
    {
        $templates = [
            // ── Transactional ─────────────────────────────────────────────
            [
                'key' => 'order_confirmed',
                'trigger_after_days' => null,
                'is_active' => true,
                'variables' => ['customer_name', 'order_ref', 'total', 'items_count'],
                'en' => [
                    'subject' => 'Order Confirmed ✅',
                    'body' => "Hello {{customer_name}},\n\nYour order *{{order_ref}}* has been confirmed.\nTotal: *{{total}} IQD* ({{items_count}} item(s))\n\nWe'll notify you once it's on the way.\n\nIraq Max Tire 🔧",
                ],
                'ar' => [
                    'subject' => 'تم تأكيد طلبك ✅',
                    'body' => "مرحباً {{customer_name}}،\n\nتم تأكيد طلبك *{{order_ref}}* بنجاح.\nالإجمالي: *{{total}} دينار* ({{items_count}} منتج)\n\nسنُعلمك فور إرساله.\n\nإيراق ماكس تاير 🔧",
                ],
            ],
            [
                'key' => 'order_shipped',
                'trigger_after_days' => null,
                'is_active' => true,
                'variables' => ['customer_name', 'order_ref', 'tracking_number'],
                'en' => [
                    'subject' => 'Your Order is on the Way 🚚',
                    'body' => "Hi {{customer_name}},\n\nGreat news! Your order *{{order_ref}}* has been shipped.\nTracking No: *{{tracking_number}}*\n\nExpected delivery: 2–5 business days.\n\nIraq Max Tire",
                ],
                'ar' => [
                    'subject' => 'طلبك في الطريق 🚚',
                    'body' => "مرحباً {{customer_name}}،\n\nبشرى! تم شحن طلبك *{{order_ref}}*.\nرقم التتبع: *{{tracking_number}}*\n\nالتسليم المتوقع: 2–5 أيام عمل.\n\nإيراق ماكس تاير",
                ],
            ],
            [
                'key' => 'order_delivered',
                'trigger_after_days' => null,
                'is_active' => true,
                'variables' => ['customer_name', 'order_ref'],
                'en' => [
                    'subject' => 'Order Delivered 🎉',
                    'body' => "Hello {{customer_name}},\n\nYour order *{{order_ref}}* has been delivered successfully! 🎉\n\nWe hope you're satisfied. Please leave us a review:\n👉 https://iraqmaxtire.iq/review\n\nThank you for choosing Iraq Max Tire!",
                ],
                'ar' => [
                    'subject' => 'تم تسليم طلبك 🎉',
                    'body' => "مرحباً {{customer_name}}،\n\nتم تسليم طلبك *{{order_ref}}* بنجاح! 🎉\n\nنأمل أنك راضٍ عن طلبك. شاركنا رأيك:\n👉 https://iraqmaxtire.iq/review\n\nشكراً لاختيارك إيراق ماكس تاير!",
                ],
            ],
            [
                'key' => 'booking_confirmed',
                'trigger_after_days' => null,
                'is_active' => true,
                'variables' => ['customer_name', 'booking_ref', 'service_name', 'scheduled_at', 'branch_name'],
                'en' => [
                    'subject' => 'Booking Confirmed 📅',
                    'body' => "Hi {{customer_name}},\n\nYour booking *{{booking_ref}}* is confirmed.\n\n📋 Service: *{{service_name}}*\n📅 Date: *{{scheduled_at}}*\n📍 Branch: *{{branch_name}}*\n\nPlease arrive 5 minutes early. See you soon!\n\nIraq Max Tire",
                ],
                'ar' => [
                    'subject' => 'تم تأكيد الحجز 📅',
                    'body' => "مرحباً {{customer_name}}،\n\nتم تأكيد حجزك *{{booking_ref}}*.\n\n📋 الخدمة: *{{service_name}}*\n📅 التاريخ: *{{scheduled_at}}*\n📍 الفرع: *{{branch_name}}*\n\nنرجو الحضور قبل 5 دقائق. نراك قريباً!\n\nإيراق ماكس تاير",
                ],
            ],
            [
                'key' => 'booking_reminder',
                'trigger_after_days' => null,
                'is_active' => true,
                'variables' => ['customer_name', 'booking_ref', 'service_name', 'scheduled_at'],
                'en' => [
                    'subject' => 'Booking Reminder ⏰',
                    'body' => "Hi {{customer_name}},\n\nReminder: your *{{service_name}}* appointment is scheduled for *{{scheduled_at}}*.\n\nBooking Ref: {{booking_ref}}\n\nWe look forward to seeing you!\n\nIraq Max Tire",
                ],
                'ar' => [
                    'subject' => 'تذكير بالحجز ⏰',
                    'body' => "مرحباً {{customer_name}}،\n\nتذكير: موعدك لـ *{{service_name}}* مقرر في *{{scheduled_at}}*.\n\nرقم الحجز: {{booking_ref}}\n\nنتطلع لرؤيتك!\n\nإيراق ماكس تاير",
                ],
            ],

            // ── Automated follow-ups ──────────────────────────────────────
            [
                'key' => 'invoice',
                'trigger_after_days' => 0,
                'is_active' => true,
                'variables' => ['customer_name', 'order_ref', 'order_total', 'order_date', 'invoice_url'],
                'en' => [
                    'subject' => 'Your Invoice 🧾',
                    'body' => "Hello {{customer_name}} 👋\n\nThank you for your order from TireMax!\n\n🧾 Order: *{{order_ref}}*\n💰 Total: *{{order_total}} IQD*\n📅 Date: {{order_date}}\n\n{{invoice_url}}\n\nIraq Max Tire",
                ],
                'ar' => [
                    'subject' => 'فاتورة طلبك 🧾',
                    'body' => "مرحباً {{customer_name}} 👋\n\nشكراً لطلبك من TireMax!\n\n🧾 رقم الطلب: *{{order_ref}}*\n💰 الإجمالي: *{{order_total}} د.ع*\n📅 التاريخ: {{order_date}}\n\n{{invoice_url}}\n\nإيراق ماكس تاير",
                ],
            ],
            [
                'key' => 'review_request',
                'trigger_after_days' => 3,
                'is_active' => true,
                'variables' => ['customer_name', 'order_ref', 'review_url'],
                'en' => [
                    'subject' => 'How was your experience? ⭐',
                    'body' => "Hi {{customer_name}},\n\nIt's been 3 days since you received your order *{{order_ref}}*.\nWe'd love to hear your feedback!\n\n⭐ Rate your purchase:\n👉 {{review_url}}\n\nYour opinion helps other customers choose better.\n\nIraq Max Tire",
                ],
                'ar' => [
                    'subject' => 'كيف كانت تجربتك؟ ⭐',
                    'body' => "مرحباً {{customer_name}}،\n\nمرت 3 أيام منذ استلام طلبك *{{order_ref}}*.\nنود معرفة رأيك!\n\n⭐ قيّم مشترياتك:\n👉 {{review_url}}\n\nرأيك يساعد العملاء الآخرين على الاختيار الأفضل.\n\nإيراق ماكس تاير",
                ],
            ],
            [
                'key' => 'seasonal_tire_reminder',
                'trigger_after_days' => 90,
                'is_active' => true,
                'variables' => ['customer_name', 'product_name', 'shop_url'],
                'en' => [
                    'subject' => 'Time to Check Your Tyres? 🔄',
                    'body' => "Hi {{customer_name}},\n\nIt's been 3 months since you purchased *{{product_name}}*.\n\nRegular tyre checks improve safety and fuel efficiency.\n\n🛒 Browse our latest offers:\n👉 {{shop_url}}\n\nWe're always here to help!\nIraq Max Tire",
                ],
                'ar' => [
                    'subject' => 'حان وقت فحص إطاراتك؟ 🔄',
                    'body' => "مرحباً {{customer_name}}،\n\nمرت 3 أشهر على شرائك *{{product_name}}*.\n\nالفحص الدوري للإطارات يحسّن الأمان ويقلل استهلاك الوقود.\n\n🛒 تصفح عروضنا الأخيرة:\n👉 {{shop_url}}\n\nنحن دائماً هنا لمساعدتك!\nإيراق ماكس تاير",
                ],
            ],
            [
                'key' => 'balance_check',
                'trigger_after_days' => 180,
                'is_active' => true,
                'variables' => ['customer_name', 'order_ref'],
                'en' => [
                    'subject' => 'Tire Maintenance Reminder 🔧',
                    'body' => "Hi {{customer_name}} 🔧\n\nIt's been 6 months since your last order *{{order_ref}}*.\n\nWe recommend checking your tire pressure and alignment for your safety.\n\nContact us to book a free inspection!\n\nIraq Max Tire",
                ],
                'ar' => [
                    'subject' => 'تذكير بصيانة الإطارات 🔧',
                    'body' => "مرحباً {{customer_name}} 🔧\n\nمرت 6 أشهر على آخر طلبك *{{order_ref}}*.\n\nننصحك بفحص ضغط إطاراتك وتوازنها للحفاظ على سلامتك.\n\nتواصل معنا لحجز فحص مجاني!\n\nإيراق ماكس تاير",
                ],
            ],
            [
                'key' => 'offer_proposal',
                'trigger_after_days' => 270,
                'is_active' => true,
                'variables' => ['customer_name', 'order_ref'],
                'en' => [
                    'subject' => 'A Special Offer Just for You 🎁',
                    'body' => "Hi {{customer_name}} 🎁\n\nAs a valued customer, we have an exclusive offer waiting for you!\n\nContact us today and get the best prices on your next set of tires.\n\nIraq Max Tire",
                ],
                'ar' => [
                    'subject' => 'عرض خاص لك 🎁',
                    'body' => "مرحباً {{customer_name}} 🎁\n\nبصفتك عميلاً مميزاً، لدينا عرض حصري ينتظرك!\n\nتواصل معنا اليوم وتمتع بأفضل الأسعار على إطاراتك القادمة.\n\nإيراق ماكس تاير",
                ],
            ],
            [
                'key' => 'tire_change_reminder',
                'trigger_after_days' => 365,
                'is_active' => true,
                'variables' => ['customer_name', 'order_ref'],
                'en' => [
                    'subject' => 'Time to Change Your Tires! ⏰',
                    'body' => "Hi {{customer_name}} ⏰\n\nA full year has passed since your order *{{order_ref}}* from TireMax!\n\nIt's time to inspect and possibly replace your tires.\nContact us to book an appointment — we're happy to help!\n\nIraq Max Tire",
                ],
                'ar' => [
                    'subject' => 'حان وقت تغيير الإطارات! ⏰',
                    'body' => "مرحباً {{customer_name}} ⏰\n\nمرت سنة كاملة على طلبك *{{order_ref}}* من TireMax!\n\nحان وقت فحص إطاراتك وتغييرها إذا لزم الأمر.\nتواصل معنا لحجز موعد — يسعدنا مساعدتك!\n\nإيراق ماكس تاير",
                ],
            ],
            [
                'key' => 'cart_abandonment',
                'trigger_after_days' => 1,
                'is_active' => true,
                'variables' => ['customer_name', 'cart_total', 'cart_url'],
                'en' => [
                    'subject' => 'You left something behind! 🛒',
                    'body' => "Hi {{customer_name}},\n\nYou left items worth *{{cart_total}} IQD* in your cart.\n\nComplete your order now and get them delivered fast:\n👉 {{cart_url}}\n\nIraq Max Tire",
                ],
                'ar' => [
                    'subject' => 'نسيت شيئاً! 🛒',
                    'body' => "مرحباً {{customer_name}}،\n\nتركت منتجات بقيمة *{{cart_total}} دينار* في سلة التسوق.\n\nأكمل طلبك الآن واستلمه بسرعة:\n👉 {{cart_url}}\n\nإيراق ماكس تاير",
                ],
            ],
        ];

        foreach ($templates as $data) {
            $template = WhatsappTemplate::updateOrCreate(
                ['key' => $data['key']],
                [
                    'trigger_after_days' => $data['trigger_after_days'],
                    'is_active' => $data['is_active'],
                    'variables' => $data['variables'],
                ]
            );

            $template->translateOrNew('en')->fill($data['en']);
            $template->translateOrNew('ar')->fill($data['ar']);
            $template->save();
        }
    }
}
