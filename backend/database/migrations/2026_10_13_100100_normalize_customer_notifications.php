<?php

use App\Support\NotificationPresenter;
use Illuminate\Database\Migrations\Migration;
use Illuminate\Support\Facades\DB;

/**
 * Notification wording is now rendered per-locale from the payload (see NotificationPresenter).
 * Legacy rows that carry a known `type` already hold the needed params, so they are kept and
 * only get their English fallback title/body refreshed. Rows we cannot translate (unknown or
 * missing type) are removed.
 */
return new class extends Migration {
    private const KNOWN_TYPES = [
        'order_placed', 'order_status_changed', 'booking_created', 'booking_status_changed', 'booking_reminder',
    ];

    public function up(): void
    {
        DB::table('notifications')->orderBy('created_at')->each(function ($row) {
            $data = json_decode($row->data, true) ?: [];

            if (!in_array($data['type'] ?? null, self::KNOWN_TYPES, true)) {
                DB::table('notifications')->where('id', $row->id)->delete();
                return;
            }

            $en = NotificationPresenter::present($data, 'en');
            DB::table('notifications')->where('id', $row->id)->update([
                'data' => json_encode([...$data, 'title' => $en['title'], 'body' => $en['body']], JSON_UNESCAPED_UNICODE),
            ]);
        });
    }

    public function down(): void
    {
        // irreversible data clean-up
    }
};
