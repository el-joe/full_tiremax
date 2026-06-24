<?php

namespace App\Payment;

use App\Contracts\PaymentGatewayInterface;
use App\DTOs\PaymentResult;
use App\Models\Order;
use App\Models\PaymentGateway;

class CodGateway implements PaymentGatewayInterface
{
    public function __construct(protected PaymentGateway $gateway) {}

    public function initiate(Order $order, array $data = []): PaymentResult
    {
        return PaymentResult::pending(
            gatewayResponse: ['note' => 'Cash will be collected upon delivery.'],
            message: 'Cash on Delivery selected. Pay when your order arrives.',
        );
    }

    public function verify(string $transactionId, array $payload = []): PaymentResult
    {
        // COD payments are confirmed manually by admin when delivered
        return PaymentResult::pending(message: 'COD payments are confirmed upon delivery.');
    }

    public function getDriver(): string
    {
        return 'cod';
    }
}
