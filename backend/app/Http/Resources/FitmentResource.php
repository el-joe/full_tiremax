<?php

namespace App\Http\Resources;

use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

class FitmentResource extends JsonResource
{
    public function toArray(Request $request): array
    {
        return [
            'id' => $this->id,
            'vehicle_id' => $this->vehicle_id,
            'product_id' => $this->product_id,
            'year_from' => $this->year_from,
            'year_to' => $this->year_to,
            'trim' => $this->trim,
            'is_alternative' => $this->is_alternative,
            'is_excluded' => $this->is_excluded,
            'is_oem' => $this->is_oem,
            'notes' => $this->notes,
            'product' => new ProductResource($this->whenLoaded('product')),
            'vehicle' => new VehicleResource($this->whenLoaded('vehicle')),
        ];
    }
}
