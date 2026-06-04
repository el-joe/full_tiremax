<?php

namespace App\Http\Resources;

use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

class CartResource extends JsonResource
{
    public function toArray(Request $request): array
    {
        $items = $this->items;
        $subtotal = (float) $items->sum(fn($i) => $i->unit_price * $i->quantity);

        return [
            'id' => $this->id,
            'governorate_id' => $this->governorate_id,
            'governorate' => new GovernorateResource($this->whenLoaded('governorate')),
            'items' => $items->map(fn($item) => [
                'id' => $item->id,
                'product_id' => $item->product_id,
                'product' => new ProductResource($item->product),
                'quantity' => $item->quantity,
                'unit_price' => (float) $item->unit_price,
                'total' => round($item->unit_price * $item->quantity, 2),
            ]),
            'subtotal' => $subtotal,
            'items_count' => $items->sum('quantity'),
        ];
    }
}
