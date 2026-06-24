<?php

namespace App\Services;

use App\DTOs\PaymentResult;
use App\Models\Order;
use App\Models\Payment;
use App\Models\PaymentGateway;
use App\Support\ApiException;

class PaymentService
{
    public function initiate(Order $order, string $driver, array $data = []): Payment
    {
        $gatewayModel = PaymentGateway::where('driver', $driver)
            ->where('is_active', true)
            ->first();

        if (!$gatewayModel) {
            throw ApiException::badRequest("Payment gateway '{$driver}' is not available.");
        }

        $handler = $gatewayModel->makeHandler();
        $result = $handler->initiate($order, $data);

        return Payment::create([
            'order_id'           => $order->id,
            'payment_gateway_id' => $gatewayModel->id,
            'amount'             => $order->total,
            'currency'           => $gatewayModel->settings['currency'] ?? 'IQD',
            'status'             => $result->status,
            'transaction_id'     => $result->transactionId,
            'redirect_url'       => $result->redirectUrl,
            'gateway_response'   => $result->gatewayResponse,
        ]);
    }

    public function handleCallback(string $driver, array $payload): PaymentResult
    {
        $gatewayModel = PaymentGateway::where('driver', $driver)
            ->where('is_active', true)
            ->firstOrFail();

        $handler = $gatewayModel->makeHandler();

        $transactionId = (string) ($payload['id'] ?? $payload['transaction_id'] ?? '');
        $result = $handler->verify($transactionId, $payload);

        if ($result->transactionId) {
            $payment = Payment::where('transaction_id', $result->transactionId)
                ->orWhereHas('order', fn($q) => $q->where('reference', $payload['merchant_order_id'] ?? null))
                ->first();

            if ($payment) {
                $payment->update([
                    'status'           => $result->status,
                    'gateway_response' => array_merge($payment->gateway_response ?? [], $result->gatewayResponse),
                    'paid_at'          => $result->status === Payment::STATUS_PAID ? now() : null,
                ]);

                if ($result->status === Payment::STATUS_PAID) {
                    $payment->order->update(['payment_status' => 'paid']);
                }
            }
        }

        return $result;
    }

    public function getForOrder(Order $order): ?Payment
    {
        return $order->payments()->latest()->first();
    }

    public function activeGateways(): \Illuminate\Database\Eloquent\Collection
    {
        return PaymentGateway::where('is_active', true)
            ->select(['id', 'name', 'display_name', 'driver', 'settings'])
            ->get();
    }
}
