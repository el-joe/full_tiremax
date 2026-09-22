<?php

namespace App\Services;

use App\Integrations\Daftra;
use App\Models\Booking;
use App\Models\DaftraSyncLog;
use Illuminate\Support\Facades\Log;
use Throwable;

class DaftraBookingSyncService
{
    public function __construct(private readonly Daftra $daftra) {}

    /**
     * Push a standalone booking (not linked to an order) to Daftra as a sales invoice.
     * Skips if already synced or if the booking belongs to an order (handled by DaftraOrderSyncService).
     */
    public function push(Booking $booking): void
    {
        if ($booking->daftra_invoice_id || $booking->order_id) {
            return;
        }

        $booking->loadMissing(['customer', 'service.translations', 'branch.translations']);

        $log = DaftraSyncLog::create([
            'syncable_type' => Booking::class,
            'syncable_id'   => $booking->id,
            'action'        => 'create_invoice',
            'status'        => 'pending',
            'payload'       => $this->buildPayload($booking),
            'attempts'      => 0,
        ]);

        try {
            $daftraClientId = $this->resolveClient($booking);
            $payload        = $this->buildPayload($booking, $daftraClientId);
            $response       = $this->daftra->pushOrder($payload);

            $invoiceData = $response['Invoice'] ?? $response['data']['Invoice'] ?? null;
            $invoiceId   = $invoiceData['id'] ?? ($response['id'] ?? null);

            $booking->update(['daftra_invoice_id' => (string) $invoiceId]);

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

            Log::error('DaftraBookingSync: failed to push booking', [
                'booking_id' => $booking->id,
                'error'      => $e->getMessage(),
            ]);

            throw $e;
        }
    }

    private function resolveClient(Booking $booking): int|string
    {
        $customer = $booking->customer;
        $snapshot = (object) [
            'name' => $booking->customer_name ?? $customer?->name,
            'email' => $booking->customer_email ?? $customer?->email,
            'phone' => $booking->customer_phone ?? $customer?->phone,
        ];

        $clientData = $this->daftra->findOrCreateClient([
            'name'  => $snapshot->name,
            'email' => $snapshot->email ?? '',
            'phone' => $snapshot->phone,
        ]);

        $daftraId = $clientData['id'] ?? $clientData['Client']['id'] ?? 0;

        if ($daftraId && $customer && !$customer->daftra_id) {
            $customer->update(['daftra_id' => (string) $daftraId]);
        }

        return $daftraId;
    }

    private function buildPayload(Booking $booking, int|string|null $clientId = null): array
    {
        $service  = $booking->service;
        $price    = (float) ($service?->price ?? 0);

        return [
            'client_id'     => $clientId,
            'date'          => $booking->scheduled_at?->format('Y-m-d') ?? now()->format('Y-m-d'),
            'reference_no'  => $booking->reference,
            'notes'         => $booking->customer_notes,
            'invoice_lines' => [
                [
                    'product_id'  => null,
                    'description' => $service?->name ?? 'Service Booking',
                    'unit_price'  => $price,
                    'quantity'    => 1,
                    'total'       => $price,
                ],
            ],
        ];
    }
}
