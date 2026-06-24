<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Order;
use App\Services\PaymentService;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

class PaymentController extends Controller
{
    public function __construct(protected PaymentService $paymentService) {}

    public function gateways(): JsonResponse
    {
        return response()->json([
            'data' => $this->paymentService->activeGateways(),
        ]);
    }

    public function show(Order $order): JsonResponse
    {
        $this->authorizeOrder($order);

        $payment = $this->paymentService->getForOrder($order);

        if (!$payment) {
            return response()->json(['message' => 'No payment found for this order.'], 404);
        }

        return response()->json(['data' => $payment->load('gateway:id,name,display_name,driver')]);
    }

    public function paymobCallback(Request $request): JsonResponse
    {
        $payload = $request->all();

        $result = $this->paymentService->handleCallback('paymob', $payload);

        return response()->json(['status' => $result->status]);
    }

    private function authorizeOrder(Order $order): void
    {
        $customer = auth('api')->user();
        if ($order->customer_id !== $customer?->id) {
            abort(403);
        }
    }
}
