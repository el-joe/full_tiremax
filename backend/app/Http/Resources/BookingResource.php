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
            'customer_notes' => $this->customer_notes,
            'branch' => new BranchResource($this->whenLoaded('branch')),
            'service' => new ServiceResource($this->whenLoaded('service')),
        ];
    }
}
