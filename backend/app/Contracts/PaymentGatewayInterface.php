<?php

namespace App\Contracts;

use App\DTOs\PaymentResult;
use App\Models\Order;

interface PaymentGatewayInterface
{
    public function initiate(Order $order, array $data = []): PaymentResult;

    public function verify(string $transactionId, array $payload = []): PaymentResult;

    public function getDriver(): string;
}
