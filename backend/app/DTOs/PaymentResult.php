<?php

namespace App\DTOs;

class PaymentResult
{
    public function __construct(
        public readonly string $status,
        public readonly ?string $transactionId = null,
        public readonly ?string $redirectUrl = null,
        public readonly array $gatewayResponse = [],
        public readonly ?string $message = null,
    ) {}

    public static function pending(array $gatewayResponse = [], ?string $message = null): self
    {
        return new self(status: 'pending', gatewayResponse: $gatewayResponse, message: $message);
    }

    public static function processing(string $transactionId, string $redirectUrl, array $gatewayResponse = []): self
    {
        return new self(
            status: 'processing',
            transactionId: $transactionId,
            redirectUrl: $redirectUrl,
            gatewayResponse: $gatewayResponse,
        );
    }

    public static function paid(string $transactionId, array $gatewayResponse = []): self
    {
        return new self(status: 'paid', transactionId: $transactionId, gatewayResponse: $gatewayResponse);
    }

    public static function failed(string $message, array $gatewayResponse = []): self
    {
        return new self(status: 'failed', gatewayResponse: $gatewayResponse, message: $message);
    }
}
