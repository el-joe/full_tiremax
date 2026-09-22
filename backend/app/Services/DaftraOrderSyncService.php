<?php

namespace App\Services;

use App\Integrations\Daftra;
use App\Models\Booking;
use App\Models\DaftraSyncLog;
use App\Models\Order;
use Illuminate\Support\Facades\Log;
use Throwable;

/**
 * Pushes TireMax orders to Daftra as sales invoices and handles related bookings.
 *
 * Responsibilities:
 *  - Find or create the Daftra client for the order's customer.
 *  - Build invoice line items from order items (using products' daftra_id).
 *  - Push the invoice to Daftra and save daftra_invoice_id/url on the Order.
 *  - If the order has bookings, confirm/create them in TireMax.
 *  - Log every attempt to daftra_sync_logs.
 */
class DaftraOrderSyncService
{
    public function __construct(private readonly Daftra $daftra) {}

    // ──────────────────────────────────────────────────────────────────────────
    // Push a single order
    // ──────────────────────────────────────────────────────────────────────────

    /**
     * Push an order to Daftra as a sales invoice.
     * Skips orders that already have a daftra_invoice_id.
     *
     * @throws Throwable on fatal errors (caller decides whether to abort or log-and-continue)
     */
    public function push(Order $order): void
    {
        if ($order->daftra_invoice_id) {
            return; // Already synced
        }

        $order->loadMissing(['customer', 'items.product.translations', 'bookings.service.translations']);

        $log = DaftraSyncLog::create([
            'order_id' => $order->id,
            'action'   => 'create_invoice',
            'status'   => 'pending',
            'payload'  => $this->buildInvoicePayload($order),
            'attempts' => 0,
        ]);

        try {
            // 1. Resolve Daftra client
            $daftraClientId = $this->resolveClient($order);

            // 2. Build & push invoice
            $payload  = $this->buildInvoicePayload($order, $daftraClientId);
            $response = $this->daftra->pushOrder($payload);

            $invoiceData = $response['Invoice'] ?? $response['data']['Invoice'] ?? null;

            $daftraInvoiceId  = $invoiceData['id']          ?? ($response['id']          ?? null);
            $daftraInvoiceUrl = $invoiceData['invoice_url'] ?? ($response['invoice_url'] ?? null);

            // 3. Persist result on the order
            $order->update([
                'daftra_invoice_id'  => (string) $daftraInvoiceId,
                'daftra_invoice_url' => $daftraInvoiceUrl,
                'daftra_meta'        => $invoiceData ?? $response,
            ]);

            // 4. Handle bookings
            $this->handleBookings($order);

            $log->update([
                'status'   => 'success',
                'response' => $invoiceData ?? $response,
                'attempts' => $log->attempts + 1,
            ]);
        } catch (Throwable $e) {
            $log->update([
                'status'   => 'failed',
                'response' => ['error' => $e->getMessage()],
                'attempts' => $log->attempts + 1,
            ]);

            Log::error('DaftraOrderSync: failed to push order', [
                'order_id' => $order->id,
                'error'    => $e->getMessage(),
            ]);

            throw $e;
        }
    }

    /**
     * Push all orders that have not been synced to Daftra yet.
     */
    public function pushPendingOrders(?callable $onEach = null): array
    {
        $synced = $failed = 0;

        Order::whereNull('daftra_invoice_id')
            ->whereIn('status', [
                Order::STATUS_CONFIRMED,
                Order::STATUS_PROCESSING,
                Order::STATUS_SHIPPED,
                Order::STATUS_DELIVERED,
                Order::STATUS_COMPLETED,
            ])
            ->with(['customer', 'items.product', 'bookings.service'])
            ->chunkById(50, function (\Illuminate\Database\Eloquent\Collection $orders) use (&$synced, &$failed, $onEach) {
                /** @var Order $order */
                foreach ($orders as $order) {
                    try {
                        $this->push($order);
                        $synced++;
                    } catch (Throwable $e) {
                        $failed++;
                    }

                    if ($onEach) {
                        $onEach($order, $e ?? null);
                    }
                    unset($e);
                }
            });

        return ['synced' => $synced, 'failed' => $failed];
    }

    // ──────────────────────────────────────────────────────────────────────────
    // Helpers
    // ──────────────────────────────────────────────────────────────────────────

    /**
     * Find or create a Daftra client for the order's customer.
     * Returns the Daftra client id.
     */
    private function resolveClient(Order $order): int|string
    {
        $customer = $order->customer;

        $clientData = $this->daftra->findOrCreateClient([
            'name'    => $order->customer_name,
            'email'   => $order->customer_email ?? ($customer?->email ?? ''),
            'phone'   => $order->customer_phone,
            'address' => $order->shipping_address ?? ($customer?->address ?? ''),
        ]);

        $daftraId = $clientData['id'] ?? $clientData['Client']['id'] ?? 0;

        // Persist daftra_id on the customer so future orders skip the search
        if ($daftraId && $customer && !$customer->daftra_id) {
            $customer->update(['daftra_id' => (string) $daftraId]);
        }

        return $daftraId;
    }

    /**
     * Build the Daftra invoice payload from a TireMax order.
     */
    private function buildInvoicePayload(Order $order, int|string|null $clientId = null): array
    {
        $lines = [];

        foreach ($order->items as $item) {
            $lines[] = [
                'product_id'  => $item->product?->daftra_id ?? null,
                'description' => $item->product_name,
                'unit_price'  => (float) $item->unit_price,
                'quantity'    => $item->quantity,
                'total'       => (float) $item->total,
            ];
        }

        // Add booking / installation service lines
        foreach ($order->bookings ?? [] as $booking) {
            if (!$booking->service) {
                continue;
            }
            $lines[] = [
                'product_id'  => null,
                'description' => 'Installation: ' . ($booking->service->name ?? 'Service'),
                'unit_price'  => 0,
                'quantity'    => 1,
                'total'       => 0,
            ];
        }

        return [
            'client_id'      => $clientId,
            'date'           => $order->placed_at?->format('Y-m-d') ?? now()->format('Y-m-d'),
            'reference_no'   => $order->reference,
            'notes'          => $order->notes,
            'discount'       => (float) $order->discount,
            'invoice_lines'  => $lines,
        ];
    }

    /**
     * Confirm pending bookings linked to a just-pushed order.
     * Creates a pending booking record if the order is basra-type but has no booking yet.
     */
    private function handleBookings(Order $order): void
    {
        // Confirm any existing pending bookings for this order
        $order->bookings
            ->where('status', Booking::STATUS_PENDING)
            ->each(fn (Booking $b) => $b->update(['status' => Booking::STATUS_CONFIRMED]));
    }
}
