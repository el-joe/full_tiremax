<?php

namespace App\Jobs;

use App\Models\Customer;
use App\Models\Order;
use App\Models\WhatsappTemplate;
use App\Services\WhatsappService;
use Illuminate\Bus\Queueable;
use Illuminate\Contracts\Queue\ShouldQueue;
use Illuminate\Foundation\Bus\Dispatchable;
use Illuminate\Queue\InteractsWithQueue;
use Illuminate\Queue\SerializesModels;

class SendWhatsappMessage implements ShouldQueue
{
    use Dispatchable, InteractsWithQueue, Queueable, SerializesModels;

    public int $tries = 3;
    public int $backoff = 60;

    public function __construct(
        public readonly WhatsappTemplate $template,
        public readonly Customer $customer,
        public readonly ?Order $order = null,
        public readonly array $extraVars = [],
    ) {}

    public function handle(WhatsappService $service): void
    {
        $service->sendFromTemplate($this->template, $this->customer, $this->order, $this->extraVars);
    }
}
