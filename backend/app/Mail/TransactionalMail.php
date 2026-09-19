<?php

namespace App\Mail;

use App\Models\NotificationLog;
use Illuminate\Bus\Queueable;
use Illuminate\Contracts\Queue\ShouldQueue;
use Illuminate\Mail\Mailable;
use Illuminate\Mail\Mailables\Content;
use Illuminate\Mail\Mailables\Envelope;
use Illuminate\Queue\SerializesModels;
use Throwable;

/** Base for all bilingual (ar RTL / en) queued customer mails. */
abstract class TransactionalMail extends Mailable implements ShouldQueue
{
    use Queueable, SerializesModels;

    public int $tries = 3;
    public array $backoff = [60, 300, 900];

    public ?int $logId = null;

    /** Blade view (markdown) name and subject translation key. */
    abstract protected function viewName(): string;
    abstract protected function subjectKey(): string;
    abstract protected function viewData(): array;
    abstract protected function recipientLocale(): string;

    protected function reference(): string
    {
        return '';
    }

    public function withLog(?int $id): static
    {
        $this->logId = $id;
        return $this;
    }

    public function envelope(): Envelope
    {
        $loc = $this->recipientLocale();
        return new Envelope(subject: __($this->subjectKey(), ['ref' => $this->reference()], $loc));
    }

    public function content(): Content
    {
        $loc = $this->recipientLocale();
        return new Content(markdown: $this->viewName(), with: $this->viewData() + [
            'loc' => $loc,
            'rtl' => $loc === 'ar',
            'siteName' => config('mail.from.name'),
        ]);
    }

    public function send($mailer)
    {
        $this->locale($this->recipientLocale());
        try {
            $result = parent::send($mailer);
            $this->markLog('sent');
            return $result;
        } catch (Throwable $e) {
            $this->markLog('failed', $e->getMessage());
            throw $e;
        }
    }

    public function failed(Throwable $e): void
    {
        $this->markLog('failed', $e->getMessage());
    }

    private function markLog(string $status, ?string $error = null): void
    {
        if ($this->logId) {
            NotificationLog::whereKey($this->logId)->update(['status' => $status, 'error' => $error]);
        }
    }
}
