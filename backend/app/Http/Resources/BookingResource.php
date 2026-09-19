<?php

namespace App\Http\Resources;

use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

class BookingResource extends JsonResource
{
    public function toArray(Request $request): array
    {
        return [
            'id' => $this->id,
            'reference' => $this->reference,
            'scheduled_at' => optional($this->scheduled_at)->toIso8601String(),
            'duration_minutes' => $this->duration_minutes,
            'status' => $this->status,
            'is_guest' => (bool) $this->is_guest,
            'customer_name' => $this->customer_name ?? $this->customer?->name,
            'customer_phone' => $this->customer_phone ?? $this->customer?->phone,
            'customer_email' => $this->customer_email ?? $this->customer?->email,
            'customer_notes' => $this->customer_notes,
            'branch' => new BranchResource($this->whenLoaded('branch')),
            'service' => new ServiceResource($this->whenLoaded('service')),
        ];
    }
}
