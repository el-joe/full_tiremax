<?php

namespace App\Notifications;

use App\Notifications\Channels\WhatsappChannel;
use Illuminate\Bus\Queueable;
use Illuminate\Contracts\Queue\ShouldQueue;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Notifications\Notification;

class WhatsappTemplateNotification extends Notification implements ShouldQueue
{
    use Queueable;

    public int $tries = 3;

    public function __construct(
        public string $template,
        public Model $subject,
        public string $lang = 'ar',
        public bool $force = false,
    ) {}

    public function backoff(): array
    {
        return [60, 300, 900];
    }

    public function via(object $notifiable): array
    {
        return [WhatsappChannel::class];
    }

    public function toWhatsapp(object $notifiable): array
    {
        return ['template' => $this->template, 'subject' => $this->subject, 'locale' => $this->lang, 'force' => $this->force];
    }
}
