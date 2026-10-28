<?php

namespace App\Console\Commands;

use App\Services\WhatsappService;
use Illuminate\Console\Command;

class FlushQueuedWhatsapp extends Command
{
    protected $signature = 'whatsapp:flush-queued';
    protected $description = 'Send WhatsApp messages parked because of the QR sending limit or a disconnected session';

    public function handle(WhatsappService $whatsapp): int
    {
        $this->info($whatsapp->flushQueued() . ' queued message(s) sent.');

        return self::SUCCESS;
    }
}
