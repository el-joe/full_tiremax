<?php

namespace App\Http\Resources;

use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

class FlashSaleResource extends JsonResource
{
    public function toArray(Request $request): array
    {
        return [
            'id' => $this->id,
            'title' => $this->title,
            'discount_percent' => (float) $this->discount_percent,
            'starts_at' => $this->starts_at->toIso8601String(),
            'ends_at' => $this->ends_at->toIso8601String(),
            'status' => $this->status,
            'is_running' => $this->is_running,
            'countdown_seconds' => $this->countdown_seconds,
            'products_count' => $this->whenCounted('products'),
        ];
    }
}
