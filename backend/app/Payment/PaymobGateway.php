<?php

namespace App\Payment;

use App\Contracts\PaymentGatewayInterface;
use App\DTOs\PaymentResult;
use App\Models\Order;
use App\Models\PaymentGateway;
use Illuminate\Support\Facades\Http;
use Illuminate\Support\Facades\Log;

class PaymobGateway implements PaymentGatewayInterface
{
    private const BASE_URL = 'https://accept.paymob.com/api';

    public function __construct(protected PaymentGateway $gateway) {}

    public function initiate(Order $order, array $data = []): PaymentResult
    {
        try {
            $token = $this->authenticate();
            $paymobOrderId = $this->createOrder($token, $order);
            $paymentKey = $this->requestPaymentKey($token, $paymobOrderId, $order);
            $iframeId = $this->gateway->credentials['iframe_id'];
            $redirectUrl = "https://accept.paymob.com/api/acceptance/iframes/{$iframeId}?payment_token={$paymentKey}";

            return PaymentResult::processing(
                transactionId: (string) $paymobOrderId,
                redirectUrl: $redirectUrl,
                gatewayResponse: [
                    'paymob_order_id' => $paymobOrderId,
                    'payment_key'     => $paymentKey,
                    'iframe_id'       => $iframeId,
                ],
            );
        } catch (\Throwable $e) {
            Log::error('Paymob initiate failed', ['order' => $order->id, 'error' => $e->getMessage()]);
            return PaymentResult::failed('Payment gateway error. Please try again.');
        }
    }

    public function verify(string $transactionId, array $payload = []): PaymentResult
    {
        $hmacSecret = $this->gateway->credentials['hmac_secret'] ?? '';

        if (!$this->validateHmac($payload, $hmacSecret)) {
            return PaymentResult::failed('Invalid HMAC signature.');
        }

        $success = filter_var($payload['success'] ?? false, FILTER_VALIDATE_BOOLEAN);

        if ($success) {
            return PaymentResult::paid(
                transactionId: $payload['id'] ?? $transactionId,
                gatewayResponse: $payload,
            );
        }

        return PaymentResult::failed($payload['data_message'] ?? 'Payment failed.', $payload);
    }

    public function getDriver(): string
    {
        return 'paymob';
    }

    private function authenticate(): string
    {
        $response = Http::post(self::BASE_URL . '/auth/tokens', [
            'api_key' => $this->gateway->credentials['api_key'],
        ]);

        return $response->json('token');
    }

    private function createOrder(string $token, Order $order): int
    {
        $response = Http::post(self::BASE_URL . '/ecommerce/orders', [
            'auth_token'         => $token,
            'delivery_needed'    => false,
            'amount_cents'       => (int) round((float) $order->total * 100),
            'currency'           => $this->gateway->settings['currency'] ?? 'EGP',
            'merchant_order_id'  => $order->reference,
            'items'              => [],
        ]);

        return $response->json('id');
    }

    private function requestPaymentKey(string $token, int $paymobOrderId, Order $order): string
    {
        $response = Http::post(self::BASE_URL . '/acceptance/payment_keys', [
            'auth_token'     => $token,
            'amount_cents'   => (int) round((float) $order->total * 100),
            'expiration'     => 3600,
            'order_id'       => $paymobOrderId,
            'currency'       => $this->gateway->settings['currency'] ?? 'EGP',
            'integration_id' => $this->gateway->credentials['integration_id'],
            'billing_data'   => [
                'first_name'    => $order->customer_name ?? 'N/A',
                'last_name'     => 'N/A',
                'email'         => $order->customer_email ?? 'N/A',
                'phone_number'  => $order->customer_phone ?? 'N/A',
                'apartment'     => 'N/A',
                'floor'         => 'N/A',
                'street'        => $order->shipping_address ?? 'N/A',
                'building'      => 'N/A',
                'shipping_method' => 'N/A',
                'postal_code'   => 'N/A',
                'city'          => 'N/A',
                'country'       => 'N/A',
                'state'         => 'N/A',
            ],
        ]);

        return $response->json('token');
    }

    private function validateHmac(array $payload, string $secret): bool
    {
        if (empty($secret)) {
            return true; // skip if not configured
        }

        $hmacFields = [
            'amount_cents', 'created_at', 'currency', 'error_occured',
            'has_parent_transaction', 'id', 'integration_id', 'is_3d_secure',
            'is_auth', 'is_capture', 'is_refunded', 'is_standalone_payment',
            'is_voided', 'order', 'owner', 'pending', 'source_data_pan',
            'source_data_sub_type', 'source_data_type', 'success',
        ];

        $concatenated = collect($hmacFields)
            ->map(fn($k) => $payload[$k] ?? '')
            ->implode('');

        return hash_hmac('sha512', $concatenated, $secret) === ($payload['hmac'] ?? '');
    }
}
