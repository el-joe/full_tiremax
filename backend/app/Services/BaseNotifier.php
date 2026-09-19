<?php

namespace App\Services;

use App\Mail\TransactionalMail;
use App\Models\NotificationLog;
use App\Notifications\WhatsappTemplateNotification;
use App\Support\NotificationSettings;
use App\Support\Phone;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Support\Facades\Log;
use Illuminate\Support\Facades\Mail;
use Illuminate\Support\Facades\Notification;

/**
 * Sends to the snapshot contact on the order/booking (works for guests and customers alike).
 * Never throws: notification problems must not break the API.
 */
abstract class BaseNotifier
{
    protected function email(Model $subject, string $event, TransactionalMail $mail, ?string $email, string $locale, array $meta = []): ?NotificationLog
    {
        if (!$email || !NotificationSettings::emailEnabled()) {
            return null;
        }
        try {
            NotificationSettings::applyMailFrom();
            $log = NotificationLog::create([
                'channel' => 'email', 'event' => $event, 'subject_type' => $subject::class, 'subject_id' => $subject->getKey(),
                'recipient' => $email, 'locale' => $locale, 'status' => 'queued', 'meta' => $meta ?: null,
            ]);
            Mail::to($email)->send($mail->withLog($log->id));
            return $log;
        } catch (\Throwable $e) {
            Log::error('Email notification failed', ['event' => $event, 'error' => $e->getMessage()]);
            isset($log) && $log->update(['status' => 'failed', 'error' => $e->getMessage()]);
            return $log ?? null;
        }
    }

    protected function whatsapp(Model $subject, string $template, ?string $phone, string $locale, bool $force = false): void
    {
        if (!$phone || !NotificationSettings::whatsappEnabled()) {
            return;
        }
        try {
            Notification::route('whatsapp', Phone::normalize($phone) ?: $phone)
                ->notify(new WhatsappTemplateNotification($template, $subject, $locale, $force));
        } catch (\Throwable $e) {
            Log::error('WhatsApp notification dispatch failed', ['template' => $template, 'error' => $e->getMessage()]);
        }
    }

    protected function database(?Model $customer, $notification): void
    {
        if (!$customer) {
            return;
        }
        try {
            $customer->notify($notification);
        } catch (\Throwable $e) {
            Log::error('Database notification failed', ['error' => $e->getMessage()]);
        }
    }
}
