<?php

namespace App\Payment;

use App\Contracts\PaymentGatewayInterface;
use App\DTOs\PaymentResult;
use App\Models\Order;
use App\Models\PaymentGateway;

class BankTransferGateway implements PaymentGatewayInterface
{
    public function __construct(protected PaymentGateway $gateway) {}

    public function initiate(Order $order, array $data = []): PaymentResult
    {
        $credentials = $this->gateway->credentials;

        return PaymentResult::pending(
            gatewayResponse: [
                'bank_name'      => $credentials['bank_name'] ?? null,
                'account_name'   => $credentials['account_name'] ?? null,
                'account_number' => $credentials['account_number'] ?? null,
                'iban'           => $credentials['iban'] ?? null,
                'swift'          => $credentials['swift'] ?? null,
                'note'           => 'Please transfer the order total and upload your receipt.',
            ],
            message: 'Transfer the amount to the bank account and upload proof of payment.',
        );
    }

    public function verify(string $transactionId, array $payload = []): PaymentResult
    {
        // Bank transfer verification is done manually by admin after receipt review
        return PaymentResult::pending(message: 'Bank transfer is awaiting manual verification.');
    }

    public function getDriver(): string
    {
        return 'bank_transfer';
    }
}
