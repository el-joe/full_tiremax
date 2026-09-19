<?php

namespace App\Http\Resources;

use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

class OrderResource extends JsonResource
{
    public function toArray(Request $request): array
    {
        return [
            'id' => $this->id,
            'reference' => $this->reference,
            'type' => $this->type,
            'status' => $this->status,
            'payment_method' => $this->payment_method,
            'payment_status' => $this->payment_status,
            'subtotal' => (float) $this->subtotal,
            'discount' => (float) $this->discount,
            'shipping_fee' => (float) $this->shipping_fee,
            'installation_fee' => (float) $this->installation_fee,
            'total' => (float) $this->total,
            'is_guest' => (bool) $this->is_guest,
            'customer_id' => $this->customer_id,
            'customer_name' => $this->customer_name,
            'customer_phone' => $this->customer_phone,
            'customer_email' => $this->customer_email,
            'shipping_address' => $this->shipping_address,
            'tracking_number' => $this->tracking_number,
            'placed_at' => optional($this->placed_at)->toIso8601String(),
            'governorate' => new GovernorateResource($this->whenLoaded('governorate')),
            'branch' => new BranchResource($this->whenLoaded('branch')),
            'items' => $this->whenLoaded('items', fn() => $this->items->map(fn($i) => [
                'id' => $i->id,
                'product_id' => $i->product_id,
                'product_name' => $i->product_name,
                'product_sku' => $i->product_sku,
                'quantity' => $i->quantity,
                'unit_price' => (float) $i->unit_price,
                'total' => (float) $i->total,
            ])),
        ];
    }
}
