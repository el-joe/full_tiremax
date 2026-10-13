<?php

namespace App\Support;

use Carbon\Carbon;

/**
 * Renders a stored database notification in the requested locale.
 *
 * The payload only stores the notification `type` plus raw params (reference, status,
 * scheduled_at ...); the wording lives in lang/{locale}/notifications.php so one record
 * reads correctly in both Arabic and English. The stored `title`/`body` (English) are only
 * a fallback for types we have no translation for.
 */
class NotificationPresenter
{
    public static function present(array $data, ?string $locale = null): array
    {
        $locale = $locale ?: app()->getLocale();
        $type = $data['type'] ?? null;

        if (!$type || !is_array(trans("notifications.$type", [], $locale))) {
            return ['title' => $data['title'] ?? null, 'body' => $data['body'] ?? null];
        }

        $statusGroup = str_starts_with($type, 'booking') ? 'booking_statuses' : 'order_statuses';
        $status = $data['status'] ?? null;
        $scheduledAt = !empty($data['scheduled_at']) ? Carbon::parse($data['scheduled_at']) : null;

        $params = [
            'reference' => $data['reference'] ?? '',
            'status' => $status ? self::statusLabel($statusGroup, $status, $locale) : '',
            'date' => $scheduledAt?->format('Y-m-d H:i') ?? '',
            'time' => $scheduledAt?->format('H:i') ?? '',
        ];

        return [
            'title' => trans("notifications.$type.title", $params, $locale),
            'body' => trans("notifications.$type.body", $params, $locale),
        ];
    }

    protected static function statusLabel(string $group, string $status, string $locale): string
    {
        $key = "notifications.$group.$status";
        $label = trans($key, [], $locale);

        return $label === $key ? $status : $label;
    }
}
